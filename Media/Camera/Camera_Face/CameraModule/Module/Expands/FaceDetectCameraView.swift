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

    // thuộc tính layer
    private var focusStrokeColor: UIColor = .white
    private var focusStrokeWidth: CGFloat = 4
    private var focusCornerRadius: CGFloat = 0

    // Trả về kết quả
    var onResults: ((UIImage?, Bool, CameraError) -> Void)

    private let session = AVCaptureSession()
    private var videoLayer: AVCaptureVideoPreviewLayer { (layer as? AVCaptureVideoPreviewLayer)!}
    private let bufferQueue: DispatchQueue
    private let videoFocusLayer = CAShapeLayer()
    // Kiểm tra xem camera có bị tạm dừng ko
    private var isCaptureStopped = false
    var isCapture = false

    // Kiểm tra xem có khuôn mặt trong ảnh hay ko
    var checkDetectSuccess: Bool = false

    init(bufferQueue: DispatchQueue,
         onResults: @escaping ((UIImage?, Bool, CameraError) -> Void)) {
        self.bufferQueue = bufferQueue
        self.onResults = onResults
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
    private func updateVideoFocusArea(_ rect: CGRect) {
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

        let focusPath = UIBezierPath(roundedRect: videoFocusArea, cornerRadius: focusCornerRadius)
        videoFocusLayer.path = focusPath.cgPath
        videoFocusLayer.frame = bounds
        videoFocusLayer.mask = focusMaskLayer

        videoFocusLayer.strokeColor = UIColor.colorFromHexString(hex: "EDB91C").cgColor
        videoFocusLayer.fillColor = UIColor.clear.cgColor

        videoFocusLayer.lineWidth = focusStrokeWidth
        videoLayer.cornerRadius = 5
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
            onResults(nil, false, .initialization)
            return
        }

        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: bufferQueue)
        session.addInput(input)
        session.addOutput(output)
        session.sessionPreset = .photo

        // Chỗ này khả dụng cho IOS 13, 1 điều khá bất ổn đó là nếu không phải ios 13 thì tốc độ khung hình mà cái layer add vào nó sẽ không theo kịp tốc độ khi bạn di chuyển khuôn mặt. Xem xét trường hợp fix cứng khung ra giữa màn hình khi OS < 13.0
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
                        self?.onResults(nil, false, .denied)
                    }
                }
            }
        case .denied:
            onResults(nil, false, .denied)
        case .restricted:
            onResults(nil, false, .restricted)
        @unknown default:
            onResults(nil, false, .other)
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
        self.onResults(UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored), self.checkDetectSuccess, .none)
    }
}

// MARK: - Các hàm chức năng - Detect Face
extension FaceDetectCameraView {
    private func autoDetectFace(in image: CVPixelBuffer) {
        let request = VNDetectFaceLandmarksRequest { request, _ in
            DispatchQueue.main.async {
                self.videoFocusLayer.removeFromSuperlayer()
                guard let results = request.results as? [VNFaceObservation], let result = results.first else {
                    self.checkDetectSuccess = false
                    return
                }
                self.checkDetectSuccess = true
                self.updateVideoFocusArea(self.convert(rect: result.boundingBox))
            }
        }

        let sequenceHandler = VNSequenceRequestHandler()
        try? sequenceHandler.perform([request], on: image, orientation: .leftMirrored)
    }

    func convert(rect: CGRect) -> CGRect {
        // 1
        let origin = videoLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)

        // 2
        let size = videoLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)

        // 3
        return CGRect(origin: origin, size: size.cgSize)
    }

}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceDetectCameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("không thể lấy hình ảnh từ bộ đệm mẫu")
            return
        }

        self.autoDetectFace(in: frame)

        if isCapture {
            self.capture(in: frame)
        }
    }
}
