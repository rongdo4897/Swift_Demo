//
//  FaceDetectCameraView.swift
//  FaceXPress
//
//  Created by Hoang Lam on 01/11/2021.
//

import UIKit
import AVFoundation
import Vision
import VideoToolbox

class FaceDetectCameraView: UIView {
    // MARK: Properties
    /// Error
    enum CameraError {
        case initialization
        case denied
        case restricted
        case other
        case none
    }
    
    enum MaskType {
        case mask
        case noMask
    }

    // thuộc tính layer
    private var focusStrokeColor: UIColor = .white
    private var focusStrokeWidth: CGFloat = 4
    private var focusCornerRadius: CGFloat = 0

    // Trả về kết quả
    var onResults: ((UIImage?, Bool, MaskType?, CameraError) -> Void)

    private let session = AVCaptureSession()
    private var videoLayer: AVCaptureVideoPreviewLayer { (layer as? AVCaptureVideoPreviewLayer)!}
    private let bufferQueue: DispatchQueue
    private let videoFocusLayer = CAShapeLayer()
    private let textFocusLayer = CATextLayer()
    
    var detector: MaskDetectionVideoHelper!
    
    // Kiểm tra xem camera có bị tạm dừng ko
    private var isCaptureStopped = false
    var isCapture = false

    // Kiểm tra xem có khuôn mặt trong ảnh hay ko
    var checkDetectSuccess: Bool = false
    var maskType: MaskType?

    init(bufferQueue: DispatchQueue,
         onResults: @escaping ((UIImage?, Bool, MaskType?, CameraError) -> Void)) {
        self.bufferQueue = bufferQueue
        self.onResults = onResults
        self.detector = MaskDetectionVideoHelper(maskDetector: MaskDetector(maxResults: 1))
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Override
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
}

// MARK: - Các hàm khởi tạo, Setup
extension FaceDetectCameraView {
    private func initComponents() {

    }
}

// MARK: - Các hàm chức năng - setup video focus area
extension FaceDetectCameraView {
    private func updateVideoFocusArea(_ rect: CGRect, color: UIColor, text: String) {
        let videoFocusArea = rect
        // Layer - focus stroke
        let strokeSideLength: CGFloat = 36
        let firstStrokeMaskRect = CGRect(
            x: 0,
            y: videoFocusArea.minY + strokeSideLength,
            width: bounds.width,
            height: videoFocusArea.height - (strokeSideLength * 2)
        )
        let secondStrokeMaskRect = CGRect(
            x: videoFocusArea.minX + strokeSideLength,
            y: 0,
            width: videoFocusArea.width - (strokeSideLength * 2),
            height: bounds.height
        )

        let focusMaskLayer = CAShapeLayer()
        let focusMaskPath = UIBezierPath(rect: firstStrokeMaskRect)
        focusMaskPath.append(UIBezierPath(rect: secondStrokeMaskRect))
        focusMaskPath.append(UIBezierPath(rect: bounds))
        focusMaskLayer.path = focusMaskPath.cgPath
        focusMaskLayer.fillRule = .evenOdd

        // Focus layer
        let focusPath = UIBezierPath(roundedRect: videoFocusArea, cornerRadius: focusCornerRadius)
        videoFocusLayer.path = focusPath.cgPath
        videoFocusLayer.frame = bounds
        videoFocusLayer.mask = focusMaskLayer

        videoFocusLayer.strokeColor = color.cgColor
        videoFocusLayer.fillColor = UIColor.clear.cgColor

        videoFocusLayer.lineWidth = focusStrokeWidth
        videoLayer.cornerRadius = 5
        
        // Text Layer
//        textFocusLayer.foregroundColor = UIColor.black.cgColor
//        textFocusLayer.contentsScale = UIScreen.main.scale
//        textFocusLayer.fontSize = 14
//        textFocusLayer.font = UIFont(name: "Avenir", size: textFocusLayer.fontSize)
//        textFocusLayer.string = text
//        textFocusLayer.backgroundColor = color.cgColor
//
//        let attributes = [
//          NSAttributedString.Key.font: textFocusLayer.font as Any
//        ]
//
//        let textRect = text.boundingRect(with: CGSize(width: 400, height: 100),
//                                          options: .truncatesLastVisibleLine,
//                                          attributes: attributes, context: nil)
//        let textSize = CGSize(width: textRect.width + 12, height: textRect.height)
//        let textOrigin = CGPoint(x: frame.origin.x - 2, y: frame.origin.y - textSize.height)
//        print(CGRect(origin: textOrigin, size: textSize))
//        textFocusLayer.frame = CGRect(origin: textOrigin, size: textSize)
//
//        layer.addSublayer(textFocusLayer)
        
        layer.addSublayer(videoFocusLayer)
        
    }
}

// MARK: - Các hàm chức năng - Session, Capture
extension FaceDetectCameraView {
    private func startSession() {
        guard !isCaptureStopped else {
            isCaptureStopped = false
            session.startRunning()
            return
        }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            onResults(nil, false, nil, .initialization)
            return
        }

        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: bufferQueue)
        session.addInput(input)
        session.addOutput(output)
        session.sessionPreset = .photo

        if #available(iOS 13.0, *) {
            for connetion in session.connections {
                connetion.videoOrientation = .portrait
            }
        }

        videoLayer.session = session
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoLayer.connection?.videoOrientation = .portrait

        session.startRunning()
    }

    func startCapture() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthStatus {
        case .authorized:
            startSession()
        case .notDetermined: // Not asked for camera permission yet
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.startSession()
                    } else {
                        self?.onResults(nil, false, nil, .denied)
                    }
                }
            }
        case .denied:
            onResults(nil, false, nil, .denied)
        case .restricted:
            onResults(nil, false, nil, .restricted)
        @unknown default:
            onResults(nil, false, nil, .other)
        }
    }

    func stopCapture() {
        isCaptureStopped = true
        isCapture = false
        session.stopRunning()
    }

    private func capture(in buffer: CVPixelBuffer) {
        let ciImage = CIImage(cvImageBuffer: buffer)
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)

        self.stopCapture()
        let image = UIImage(cgImage: cgImage!)
        self.onResults(UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored), self.checkDetectSuccess, maskType, .none)
    }
}

// MARK: - Các hàm chức năng - Detect Face
extension FaceDetectCameraView {
    private func autoDetectFace(in buffer: CMSampleBuffer) {
        if let result = try? detector.detectInFrame(buffer) {
            DispatchQueue.main.async {
                self.videoFocusLayer.removeFromSuperlayer()
//                self.textFocusLayer.removeFromSuperlayer()
                guard !result.isEmpty, let firstResult = result.first else {
                    self.checkDetectSuccess = false
                    self.maskType = nil
                    return
                }
                self.checkDetectSuccess = true
                self.maskType = firstResult.status == .mask ? .mask : .noMask
                
                self.updateVideoFocusArea(
                    self.convert(firstResult.bound, mirrored: true),
                    color: firstResult.status == .noMask ? .green : .yellow,
                    text: "\(firstResult.status == .mask ? "Mask" : "No Mask") \(String(format: "%.2f", firstResult.confidence))"
                )
            }
        }
    }

    /// - Parameters:
    ///   - rect: tọa độ được trả về khi detect
    ///   - mirrored: chiều camera
    func convert(_ rect: CGRect, mirrored: Bool) -> CGRect {
        var bound = rect
        if mirrored {
            // Flip x-axis
            bound = bound
                .applying(CGAffineTransform(scaleX: -1, y: 1))
                .applying(CGAffineTransform(translationX: 1, y: 0))
        }
        
        // Adjust to match the aspect ratio of the preview
        let inputAspect: CGFloat = 12 / 16
        let viewAspect = bounds.width / bounds.height
        if inputAspect >= viewAspect {
            bound = bound
                .applying(CGAffineTransform(scaleX: inputAspect / viewAspect, y: 1))
                .applying(CGAffineTransform(translationX: 0.5 * (1 - inputAspect / viewAspect), y: 0))
        } else {
            bound = bound
                .applying(CGAffineTransform(scaleX: 1, y: viewAspect / inputAspect))
                .applying(CGAffineTransform(translationX: 0, y: 0.5 * (1 - viewAspect / inputAspect)))
        }
        
        // Scale to view size
        return bound.applying(CGAffineTransform(scaleX: bounds.width, y: bounds.height))
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceDetectCameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("không thể lấy hình ảnh từ bộ đệm mẫu")
            return
        }

        self.autoDetectFace(in: sampleBuffer)

        if isCapture {
            self.capture(in: frame)
        }
    }
}
