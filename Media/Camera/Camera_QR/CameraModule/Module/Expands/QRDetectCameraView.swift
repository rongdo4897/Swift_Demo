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

class QRDetectCameraView: UIView {
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
    var onResults: ((String?, CameraError) -> Void)

    private let session = AVCaptureSession()
    private var videoLayer: AVCaptureVideoPreviewLayer { (layer as? AVCaptureVideoPreviewLayer)!}
    private let bufferQueue: DispatchQueue
    private let videoFocusLayer = CAShapeLayer()
    // Kiểm tra xem camera có bị tạm dừng ko
    private var isCaptureStopped = false
    var isCapture = false

    init(bufferQueue: DispatchQueue,
         onResults: @escaping ((String?, CameraError) -> Void)) {
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
extension QRDetectCameraView {
    private func initComponents() {

    }
}

// MARK: - Các hàm chức năng - setup video focus area
extension QRDetectCameraView {
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
extension QRDetectCameraView {
    private func startSession() {
        guard !isCaptureStopped else {
            isCaptureStopped = false
            session.startRunning()
            return
        }

        let metaDataOutput = AVCaptureMetadataOutput()

        guard let videoDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice), session.canAddInput(videoInput) else {return}
        guard session.canAddOutput(metaDataOutput) else {return}

        // Commit Session
        session.beginConfiguration()
        session.addInput(videoInput)
        metaDataOutput.setMetadataObjectsDelegate(self, queue: bufferQueue)
        session.addOutput(metaDataOutput)
        metaDataOutput.metadataObjectTypes = [.qr]

        session.commitConfiguration()

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
                        self?.onResults(nil, .denied)
                    }
                }
            }
        case .denied:
            onResults(nil, .denied)
        case .restricted:
            onResults(nil, .restricted)
        @unknown default:
            onResults(nil, .other)
        }
    }

    func stopCapture() {
        isCaptureStopped = true
        isCapture = false
        session.stopRunning()
    }
}

// MARK: - Các hàm chức năng - Detect QR
extension QRDetectCameraView {
    private func autoDetectQRCode(in metadataObjects: [AVMetadataObject]) {
        DispatchQueue.main.async {
            self.videoFocusLayer.removeFromSuperlayer()
            guard let metadataObject = metadataObjects.first, let readableObject = self.videoLayer.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject, metadataObject.type == .qr else {return}
            let stringValue = readableObject.stringValue
            self.updateVideoFocusArea(readableObject.bounds)
            self.onResults(stringValue, .none)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRDetectCameraView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.autoDetectQRCode(in: metadataObjects)
    }
}
