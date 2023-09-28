// Copyright © 2020 Keith Ito. MIT License.
//
// Portions of this file are based on https://github.com/AIZOOTech/FaceMaskDetection
// Copyright (c) 2020 AIZOOTech. MIT License.
import AVFoundation
import CoreImage
import Vision


/// Phát hiện khuôn mặt trong một hình ảnh và xem khuôn mặt đó có mặt nạ hay không.
@available(iOS 13.0, *)
public class MaskDetector {
    public enum Status {
        /// Người đang đeo mặt nạ
        case mask
        /// Người không đeo mặt nạ
        case noMask
    }
    
    /// Kết quả phát hiện mặt nạ
    public struct Result {
        /// Trạng thái phát hiện (ví dụ: mask / noMask)
        public let status: Status
        
        /// Hộp giới hạn của khuôn mặt ở tọa độ chuẩn hóa (góc trên cùng bên trái của hình ảnh
        /// là [0, 0], và góc dưới bên phải là [1, 1]).
        public let bound: CGRect
        
        /// Giá trị từ 0 đến 1 thể hiện độ tin cậy trong kết quả
        public let confidence: Float
    }
    
    /// Hình ảnh được gửi đến mô hình phải có chiều cao và chiều rộng bằng giá trị này.
    public static let InputImageSize = 260
    
    private let minConfidence: Float
    private let iouThreshold: Float
    private let maxResults: Int
    // Không trả về kết quả trừ khi độ tin cậy của lớp tốt nhất là một yếu tố của điều này tốt hơn
    // sự đáng tin của lớp khác. TODO: Cân nhắc việc đặt đây là một tham số để init?
    private let margin: Float = 5
    private let mlModel = MaskModel()
    private let model: VNCoreMLModel
    private var anchors: [[Double]] = []
    
    /// - Parameters:
    ///   - minConfidence: độ tin cậy tối thiểu cho kết quả trả về. Default = 0.8
    ///   - iouThreshold: giao nhau vượt qua ngưỡng kết hợp để triệt tiêu không tối đa. Default = 0.2
    ///   - maxResults: số lượng kết quả tối đa để trả về. Default = 10
    public init(minConfidence: Float=0.8, maxResults: Int=10, iouThreshold: Float=0.2) {
        self.minConfidence = minConfidence
        self.maxResults = maxResults
        self.iouThreshold = iouThreshold
        model = try! VNCoreMLModel(for: mlModel.model)
    }
    
    /// Phát hiện khuôn mặt có mặt nạ hoặc không có trong hình ảnh đầu vào. Điều này chặn trong khi phát hiện là
    /// đang được thực hiện và không nên được gọi trên luồng chính.
    /// - Parameters:
    ///   - cvPixelBuffer: Một 260x260 CVPixelBuffer
    ///   - orientation: Hướng của hình ảnh đầu vào (default .up)
    /// - Returns: Một loạt các kết quả phát hiện, một kết quả cho mỗi khuôn mặt
    public func detectMasks(cvPixelBuffer: CVPixelBuffer,
                            orientation: CGImagePropertyOrientation = .up) throws -> [Result] {
        return try detectMasks(handler: VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer,
                                                              orientation: orientation))
    }
    
    /// Phát hiện khuôn mặt có mặt nạ hoặc không có trong hình ảnh đầu vào. Điều này chặn trong khi phát hiện là
    /// đang được thực hiện và không nên được gọi trên luồng chính.
    /// - Parameters:
    ///   - cgImage: Một 260x260 CGImage
    ///   - orientation: Hướng của hình ảnh đầu vào (default .up)
    /// - Returns: Một loạt các kết quả phát hiện, một kết quả cho mỗi khuôn mặt
    public func detectMasks(cgImage: CGImage,
                            orientation: CGImagePropertyOrientation = .up) throws -> [Result] {
        return try detectMasks(handler: VNImageRequestHandler(cgImage: cgImage,
                                                              orientation: orientation))
    }
    
    /// Phát hiện khuôn mặt có mặt nạ hoặc không có trong hình ảnh đầu vào. Điều này chặn trong khi phát hiện là
    /// đang được thực hiện và không nên được gọi trên luồng chính.
    /// - Parameters:
    ///   - ciImage: Một 260x260 CIImage
    ///   - orientation: Hướng của hình ảnh đầu vào (default .up)
    /// - Returns: Một loạt các kết quả phát hiện, một kết quả cho mỗi khuôn mặt
    public func detectMasks(ciImage: CIImage,
                            orientation: CGImagePropertyOrientation = .up) throws -> [Result] {
        return try detectMasks(handler: VNImageRequestHandler(ciImage: ciImage,
                                                              orientation: orientation))
    }
    
    private func detectMasks(handler: VNImageRequestHandler) throws -> [Result] {
        let request = VNCoreMLRequest(model: model)
        
        self.anchors = self.loadAnchors()
        
        try handler.perform([request])
        guard let results = request.results as? [VNCoreMLFeatureValueObservation],
              results.count == 2,
              results[0].featureName == "output_bounds",
              results[1].featureName == "output_scores",
              let boundOutputs = results[0].featureValue.multiArrayValue,
              let confOutputs = results[1].featureValue.multiArrayValue,
              confOutputs.dataType == .float32,
              boundOutputs.dataType == .float32,
              confOutputs.shape == [1, NSNumber(value: anchors.count), 2],
              boundOutputs.shape == [1, NSNumber(value: anchors.count), 4] else {
            print("Unexpected result from CoreML!")
            return []
        }
        
        // Model has 2 outputs:
        //  1. Confidences [1,5972,2]: confidence for each anchor for each class (mask, no_mask)
        //  2. Bounds [1,5972,4]: encoded bounding boxes for each anchor (see decodeBound)
        let confPtr = UnsafeMutablePointer<Float>(OpaquePointer(confOutputs.dataPointer))
        let boundPtr = UnsafeMutablePointer<Float>(OpaquePointer(boundOutputs.dataPointer))
        let confStrides = confOutputs.strides.map { $0.intValue }
        let boundStrides = boundOutputs.strides.map { $0.intValue }
        var detections: [Result] = []
        for i in 0..<confOutputs.shape[1].intValue {
            let maskConf = confPtr[i * confStrides[1]]
            let noMaskConf = confPtr[i * confStrides[1] + 1 * confStrides[2]]
            if max(maskConf, noMaskConf) > minConfidence {
                let offset = i * boundStrides[1]
                let rawBound: [Float] = [
                    boundPtr[offset],
                    boundPtr[offset + 1 * boundStrides[2]],
                    boundPtr[offset + 2 * boundStrides[2]],
                    boundPtr[offset + 3 * boundStrides[2]],
                ]
                let bound = decodeBound(anchor: anchors[i], rawBound: rawBound)
                if maskConf > noMaskConf * margin {
                    detections.append(Result(status: .mask, bound: bound, confidence: maskConf))
                } else if noMaskConf > maskConf * margin {
                    detections.append(Result(status: .noMask, bound: bound, confidence: noMaskConf))
                }
            }
        }
        return nonMaxSuppression(inputs: detections,
                                 iouThreshold: iouThreshold,
                                 maxResults: maxResults)
    }
}

@available(iOS 13.0, *)
extension MaskDetector {
    // Anchor bounds as generated by the python code in evaluate.py. These must match the anchors that
    // the model was trained with. We dump them from the python code and load them here.
    private func loadAnchors() -> [[Double]] {
        let path = Bundle(for: MaskDetector.self).path(forResource: "anchors", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return json["anchors"] as! [[Double]]
    }

    // Decodes the bound output from the model based on the anchor it is for. The model output is a
    // 4D vector where the first 2 components are the delta from the anchor center to the bound center
    // and the last 2 are the log of the ratio of the bound size to the anchor size.
    private func decodeBound(anchor: [Double], rawBound: [Float]) -> CGRect {
        let anchorW = anchor[2] - anchor[0]
        let anchorH = anchor[3] - anchor[1]
        let anchorCenterX = anchor[0] + 0.5 * anchorW
        let anchorCenterY = anchor[1] + 0.5 * anchorH
        let cx = Double(rawBound[0]) * 0.1 * anchorW + anchorCenterX
        let cy = Double(rawBound[1]) * 0.1 * anchorH + anchorCenterY
        let w = exp(Double(rawBound[2]) * 0.2) * anchorW
        let h = exp(Double(rawBound[3]) * 0.2) * anchorH
        return CGRect(x: CGFloat(cx - w / 2),
                      y: CGFloat(cy - h / 2),
                      width: CGFloat(w),
                      height: CGFloat(h))
    }


    // Performs non-max supression with a configurable overlap threshold.
    private func nonMaxSuppression(inputs: [MaskDetector.Result],
                                   iouThreshold: Float,
                                   maxResults: Int) -> [MaskDetector.Result] {
        var outputs: [MaskDetector.Result] = []
        let inputsByConfidenceDesc = inputs.sorted { $0.confidence > $1.confidence }
        for result in inputsByConfidenceDesc {
            if !hasOverlap(result, with: outputs, iouThreshold: iouThreshold) {
                outputs.append(result)
                if outputs.count >= maxResults {
                    break
                }
            }
        }
        return outputs;
    }

    private func hasOverlap(_ result: MaskDetector.Result,
                            with others: [MaskDetector.Result],
                            iouThreshold: Float) -> Bool {
        let resultArea = result.bound.width * result.bound.height
        for other in others {
            let intersection = areaOfIntersection(result.bound, other.bound)
            if intersection > 0 {
                let union = resultArea + other.bound.width * other.bound.height - intersection
                if Float(intersection / union) >= iouThreshold {
                    return true
                }
            }
        }
        return false
    }

    private func areaOfIntersection(_ a: CGRect, _ b: CGRect) -> CGFloat {
        let maxMinX = max(a.minX, b.minX)
        let minMaxX = min(a.maxX, b.maxX)
        let maxMinY = max(a.minY, b.minY)
        let minMaxY = min(a.maxY, b.maxY)
        return max(0, minMaxX - maxMinX) * max(0, minMaxY - maxMinY)
    }
}
