// Copyright © 2020 Keith Ito. MIT License.
import AVFoundation
import CoreImage


/// Helper to assist with real-time detection in a video stream. You can call this from the
/// captureOutput function in a AVCaptureVideoDataOutputSampleBufferDelegate to feed frames
/// to the MaskDetector. See the Example for usage.
@available(iOS 13.0, *)
public class MaskDetectionVideoHelper {
    /// Kiểm soát cách thay đổi kích thước hình ảnh đầu vào thành hình ảnh vuông 260x260 cho mô hình.
    public enum ResizeMode {
        /// Hình ảnh được cắt dọc theo kích thước dài hơn, với số lượng bằng nhau bị xóa ở mỗi bên.
        /// Điều này không làm biến dạng hình ảnh, nhưng nhận dạng sẽ chỉ xảy ra ở hình vuông trung tâm.
        case centerCrop
        /// Hình ảnh được kéo dài để có hình vuông. Nhận dạng có thể diễn ra trong toàn bộ hình ảnh, nhưng
        /// sẽ có biến dạng, có thể ảnh hưởng đến hiệu suất của mô hình.
        case stretch
    }
    
    private let resizeMode: ResizeMode
    private let maskDetector: MaskDetector
    
    /// - Parameters:
    ///   - maskDetector: MaskDetector được sử dụng để phát hiện
    ///   - resizeMode: kiểm soát cách hình ảnh đầu vào để tạo thành hình vuông nếu chúng chưa có
    public init(maskDetector: MaskDetector, resizeMode: ResizeMode = .centerCrop) {
        self.maskDetector = maskDetector
        self.resizeMode = resizeMode
    }
    
    /// Chạy nhận diện trên CMSampleBuffer đã cho.
    /// Nó trả về kết quả nhận diện `MaskDetector.Result` và Không nên được gọi trên luồng chính.
    public func detectInFrame(_ buffer: CMSampleBuffer) throws -> [MaskDetector.Result] {
        guard let image = CMSampleBufferGetImageBuffer(buffer) else { return [] }
        let width = CVPixelBufferGetWidth(image)
        let height = CVPixelBufferGetHeight(image)
        let transform: CGAffineTransform
        if resizeMode == .centerCrop  {
            let scale = CGFloat(MaskDetector.InputImageSize) / CGFloat(min(width, height))
            transform = CGAffineTransform(scaleX: scale, y: scale)
        } else {
            let scaleX = CGFloat(MaskDetector.InputImageSize) / CGFloat(width)
            let scaleY = CGFloat(MaskDetector.InputImageSize) / CGFloat(height)
            transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
        
        let ciImage = CIImage(cvPixelBuffer: image)
            .transformed(by: transform, highQualityDownsample: true)
        let results = try maskDetector.detectMasks(ciImage: ciImage)
        
        if resizeMode == .centerCrop {
            // Chuyển đổi tọa độ khi ở trạng thái cắt ảnh trung tâm trở lại hình ảnh đầu vào
            let inputAspect = CGFloat(width) / CGFloat(height)
            return results.map { res in
                let bound = res.bound
                    .applying(CGAffineTransform(scaleX: 1, y: inputAspect))
                    .applying(CGAffineTransform(translationX: 0, y: 0.5 * (1 - inputAspect)))
                return MaskDetector.Result(status: res.status, bound: bound, confidence: res.confidence)
            }
        } else {
            return results
        }
    }
}
