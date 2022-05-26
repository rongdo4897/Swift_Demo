//
//  FilterManager.swift
//  CameraModule
//
//  Created by Hoang Lam on 25/05/2022.
//

import Foundation
import CoreImage

class FilterManager {
    /// - None
    static func none(ciImage: CIImage) -> CIImage? {
        return ciImage
    }
    
    /// - Invert Color
    static func invertColor(ciImage: CIImage) -> CIImage? {
        guard let colorInvert = CIFilter(name: "CIColorInvert") else {
            return nil
        }
        colorInvert.setValue(ciImage, forKey: kCIInputImageKey)
        return colorInvert.outputImage
    }
    
    /// - Vignette
    static func vignette(ciImage: CIImage, ratio: CGFloat = 2, inputRadiusRatio: CGFloat = 2) -> CIImage? {
        guard let vignetteFilter = CIFilter(name: "CIVignetteEffect") else {
            return nil
        }
        vignetteFilter.setValue(self, forKey: kCIInputImageKey)
        let center = CIVector(x: ciImage.extent.size.width / ratio, y: ciImage.extent.size.height / ratio)
        vignetteFilter.setValue(center, forKey: kCIInputCenterKey)
        vignetteFilter.setValue(ciImage.extent.size.height / inputRadiusRatio, forKey: kCIInputRadiusKey)
        
        return vignetteFilter.outputImage
    }
    
    /// - Photo Instant
    static func photoInstant(ciImage: CIImage) -> CIImage? {
        guard let photoEffectInstant = CIFilter(name: "CIPhotoEffectInstant") else {
            return nil
        }
        photoEffectInstant.setValue(ciImage, forKey: kCIInputImageKey)
        return photoEffectInstant.outputImage
    }
    
    /// - Crystallize
    static func crystallize(ciImage: CIImage, ratio: CGFloat = 2, inputRadius: NSNumber = 15) -> CIImage? {
        guard let crystallize = CIFilter(name: "CICrystallize") else {
            return nil
        }
        crystallize.setValue(ciImage, forKey: kCIInputImageKey)
        let center = CIVector(x: ciImage.extent.size.width / ratio, y: ciImage.extent.size.height / ratio)
        crystallize.setValue(center, forKey: kCIInputCenterKey)
        crystallize.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        return crystallize.outputImage
    }
    
    /// - Comic
    static func comic(ciImage: CIImage) -> CIImage? {
        guard let comicEffect = CIFilter(name: "CIComicEffect") else {
            return nil
        }
        comicEffect.setValue(ciImage, forKey: kCIInputImageKey)
        return comicEffect.outputImage
    }
    
    /// - Bloom
    static func bloom(ciImage: CIImage, inputRadiusRatio: CGFloat = 2, inputIntensity: NSNumber = 1) -> CIImage? {
        guard let bloom = CIFilter(name: "CIBloom") else {
            return nil
        }
        bloom.setValue(ciImage, forKey: kCIInputImageKey)
        bloom.setValue(ciImage.extent.size.height / inputRadiusRatio, forKey: kCIInputRadiusKey)
        bloom.setValue(inputIntensity, forKey: kCIInputIntensityKey)
        
        return bloom.outputImage
    }
    
    /// - Edges
    static func edges(ciImage: CIImage, inputIntensity: NSNumber = 0.5) -> CIImage? {
        guard let edges = CIFilter(name: "CIEdges") else {
            return nil
        }
        edges.setValue(ciImage, forKey: kCIInputImageKey)
        edges.setValue(inputIntensity, forKey: kCIInputIntensityKey)
        
        return edges.outputImage
    }
    
    /// - Edge Work
    static func edgeWork(ciImage: CIImage, inputRadius: NSNumber = 1) -> CIImage? {
        guard let edgeWork = CIFilter(name: "CIEdgeWork") else {
            return nil
        }
        edgeWork.setValue(ciImage, forKey: kCIInputImageKey)
        edgeWork.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        return edgeWork.outputImage
    }
    
    /// - Gloom
    static func gloom(ciImage: CIImage, inputRadiusRatio: CGFloat = 2, inputIntensity: NSNumber = 1) -> CIImage? {
        guard let gloom = CIFilter(name: "CIGloom") else {
            return nil
        }
        gloom.setValue(ciImage, forKey: kCIInputImageKey)
        gloom.setValue(ciImage.extent.size.height / inputRadiusRatio, forKey: kCIInputRadiusKey)
        gloom.setValue(inputIntensity, forKey: kCIInputIntensityKey)
        
        return gloom.outputImage
    }
    
    /// - Hexagonal Pixellate
    static func hexagonalPixellate(ciImage: CIImage, ratio: CGFloat = 2, inputScale: NSNumber = 8) -> CIImage? {
        guard let hexagonalPixellate = CIFilter(name: "CIHexagonalPixellate") else {
            return nil
        }
        hexagonalPixellate.setValue(self, forKey: kCIInputImageKey)
        let center = CIVector(x: ciImage.extent.size.width / ratio, y: ciImage.extent.size.height / ratio)
        hexagonalPixellate.setValue(center, forKey: kCIInputCenterKey)
        hexagonalPixellate.setValue(inputScale, forKey: kCIInputScaleKey)
        
        return hexagonalPixellate.outputImage
    }
    
    /// - Highlight Shadow
    static func highlightShadowAdjust(ciImage: CIImage, inputHighlightAmount: NSNumber = 1, inputShadowAmount: NSNumber = 1) -> CIImage? {
        guard let highlightShadowAdjust = CIFilter(name: "CIHighlightShadowAdjust") else {
            return nil
        }
        highlightShadowAdjust.setValue(ciImage, forKey: kCIInputImageKey)
        highlightShadowAdjust.setValue(inputHighlightAmount, forKey: "inputHighlightAmount")
        highlightShadowAdjust.setValue(inputShadowAmount, forKey: "inputShadowAmount")
        
        return highlightShadowAdjust.outputImage
    }
    
    /// - Pixellate
    static func pixellate(ciImage: CIImage, ratio: CGFloat = 2) -> CIImage? {
        guard let pixellate = CIFilter(name: "CIPixellate") else {
            return nil
        }
        pixellate.setValue(ciImage, forKey: kCIInputImageKey)
        let center = CIVector(x: ciImage.extent.size.width / ratio, y: ciImage.extent.size.height / ratio)
        pixellate.setValue(center, forKey: kCIInputCenterKey)
        pixellate.setValue(8, forKey: kCIInputScaleKey)
        
        return pixellate.outputImage
    }
    
    /// - Pointillize
    static func pointillize(ciImage: CIImage, ratio: CGFloat = 2) -> CIImage? {
        guard let pointillize = CIFilter(name: "CIPointillize") else {
            return nil
        }
        pointillize.setValue(self, forKey: kCIInputImageKey)
        let center = CIVector(x: ciImage.extent.size.width / ratio, y: ciImage.extent.size.height / ratio)
        pointillize.setValue(center, forKey: kCIInputCenterKey)
        pointillize.setValue(10, forKey: kCIInputRadiusKey)
        
        return pointillize.outputImage
    }
    
    /// - CMYK Halftone
    static func cymkHalftone(ciImage: CIImage, inputWidth: NSNumber = 20, inputSharpness: NSNumber = 1) -> CIImage? {
        guard let cymk = CIFilter(name: "CICMYKHalftone", parameters: ["inputWidth" : inputWidth, "inputSharpness": inputSharpness]) else {
            return nil
        }
        
        cymk.setValue(ciImage, forKey: kCIInputImageKey)
        return cymk.outputImage
    }
    
    /// - Line Overlay
    static func lineOverlay(ciImage: CIImage) -> CIImage? {
        guard let lineOverlay = CIFilter(name: "CILineOverlay") else {
            return nil
        }
        
        lineOverlay.setValue(ciImage, forKey: kCIInputImageKey)
        return lineOverlay.outputImage
    }
    
    /// - Posterize
    static func posterize(ciImage: CIImage, inputLevels: NSNumber = 5) -> CIImage? {
        guard let lineOverlay = CIFilter(name: "CIColorPosterize", parameters: ["inputLevels" : inputLevels]) else {
            return nil
        }
        
        lineOverlay.setValue(ciImage, forKey: kCIInputImageKey)
        return lineOverlay.outputImage
    }
}
