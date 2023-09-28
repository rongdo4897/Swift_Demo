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

class CameraFilterView: UIView {
    // MARK: Properties
    /// Error
    enum CameraError {
        case initialization
        case denied
        case restricted
        case other
        case none
    }
    
    var imageView: UIImageView!

    // Trả về kết quả
    var onResults: ((UIImage?, CameraError) -> Void)

    private let session = AVCaptureSession()
    private var videoLayer: AVCaptureVideoPreviewLayer { (layer as? AVCaptureVideoPreviewLayer)!}
    private let bufferQueue: DispatchQueue
    private let videoFocusLayer = CAShapeLayer()
    // Kiểm tra xem camera có bị tạm dừng ko
    var isCapture = false
    
    // Danh sách filter
    var listFilters: [FilterType]
    // Giá trị index của filter được chọn trong mảng
    var filterIndex: Int = 0
    
    init(bufferQueue: DispatchQueue,
         listFilters: [FilterType],
         onResults: @escaping ((UIImage?, CameraError) -> Void)) {
        self.bufferQueue = bufferQueue
        self.listFilters = listFilters
        self.onResults = onResults
        
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initComponents()
    }

    // MARK: Override
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
}

// MARK: - Các hàm khởi tạo, Setup
extension CameraFilterView {
    private func initComponents() {
        initImageView()
    }
    
    private func initImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: self.bounds.height)
        ])
    }
}

// MARK: - Các hàm chức năng - Session, Capture
extension CameraFilterView {
    private func startSession() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            onResults(nil, .initialization)
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
        isCapture = false
        session.stopRunning()
    }

    private func capture(in buffer: CVPixelBuffer) {
        let ciImage = CIImage(cvImageBuffer: buffer).applyFilter(in: .comic)
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)

        self.stopCapture()
        let image = UIImage(cgImage: cgImage!)
        self.onResults(UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored), .none)
    }
    
    private func realTimeFilterImage(in buffer: CVPixelBuffer) {
        let ciImage = CIImage(cvImageBuffer: buffer).applyFilter(in: .comic)
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)

        let image = UIImage(cgImage: cgImage!)
        self.imageView.image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraFilterView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("không thể lấy hình ảnh từ bộ đệm mẫu")
            return
        }
        
        DispatchQueue.main.async {
            self.realTimeFilterImage(in: frame)
        }

        if isCapture {
            self.capture(in: frame)
        }
    }
}
