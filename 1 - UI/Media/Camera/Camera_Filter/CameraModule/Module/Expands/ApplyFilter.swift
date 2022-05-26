//
//  ApplyFilter.swift
//  CameraModule
//
//  Created by Hoang Lam on 25/05/2022.
//

import Foundation
import UIKit

extension CIImage {
    func applyFilter(in type: FilterType) -> CIImage {
        switch type {
        case .invert_color:
            return FilterManager.invertColor(ciImage: self) ?? self
        case .vignette:
            return FilterManager.vignette(ciImage: self) ?? self
        case .photo_instant:
            return FilterManager.photoInstant(ciImage: self) ?? self
        case .crystallize:
            return FilterManager.crystallize(ciImage: self) ?? self
        case .comic:
            return FilterManager.comic(ciImage: self) ?? self
        case .bloom:
            return FilterManager.bloom(ciImage: self) ?? self
        case .edges:
            return FilterManager.edges(ciImage: self) ?? self
        case .edge_work:
            return FilterManager.edgeWork(ciImage: self) ?? self
        case .gloom:
            return FilterManager.gloom(ciImage: self) ?? self
        case .hexagonal_pixellate:
            return FilterManager.hexagonalPixellate(ciImage: self) ?? self
        case .highlight_shadow:
            return FilterManager.highlightShadowAdjust(ciImage: self) ?? self
        case .pixellate:
            return FilterManager.pixellate(ciImage: self) ?? self
        case .pointillize:
            return FilterManager.pointillize(ciImage: self) ?? self
        case .cmyk_halftone:
            return FilterManager.cymkHalftone(ciImage: self) ?? self
        case .line_overlay:
            return FilterManager.lineOverlay(ciImage: self) ?? self
        case .posterize:
            return FilterManager.posterize(ciImage: self) ?? self
        default:
            return FilterManager.none(ciImage: self) ?? self
        }
    }
}

