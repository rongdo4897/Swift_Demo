//
//  HorizontalProgressViewLayoutProvidable.swift
//  DemoChart
//
//  Created by Hoang Lam on 27/05/2022.
//

import UIKit

protocol HorizontalProgressViewLayoutProvidable {
    func trackFrame(_ progressView: HorizontalProgressView) -> CGRect
    func trackImageViewFrame(_ progressView: HorizontalProgressView) -> CGRect
    func cornerRadius(_ progressView: HorizontalProgressView) -> CGFloat
    func trackCornerRadius(_ progressView: HorizontalProgressView) -> CGFloat
    
    func sectionFrame(_ progressView: HorizontalProgressView, section: Int) -> CGRect
    func sectionImageViewFrame(_ section: HorizontalProgressViewSectionItem) -> CGRect
}

class HorizontalProgressViewLayoutProvider: HorizontalProgressViewLayoutProvidable {
    static let shared = HorizontalProgressViewLayoutProvider()
    
    func trackFrame(_ progressView: HorizontalProgressView) -> CGRect {
        return CGRect(x: progressView.trackInset,
                      y: progressView.trackInset,
                      width: progressView.progressView.frame.width - 2 * progressView.trackInset,
                      height: progressView.progressView.frame.height - 2 * progressView.trackInset)
    }
    
    func trackImageViewFrame(_ progressView: HorizontalProgressView) -> CGRect {
        return progressView.trackView.bounds
    }
    
    func cornerRadius(_ progressView: HorizontalProgressView) -> CGFloat {
        return 0
    }
    
    func trackCornerRadius(_ progressView: HorizontalProgressView) -> CGFloat {
        return 0
    }
    
    func sectionFrame(_ progressView: HorizontalProgressView, section: Int) -> CGRect {
        let trackBounds = progressView.trackView.bounds
        let width = trackBounds.width * CGFloat(progressView.progress(forSection: section))
        let size = CGSize(width: width, height: trackBounds.height)
        
        var origin: CGPoint = trackBounds.origin
        for (bar, index) in progressView.progressViewSections where index < section {
            origin.x += bar.frame.width
        }
        
        return CGRect(origin: origin, size: size)
    }
    
    func sectionImageViewFrame(_ section: HorizontalProgressViewSectionItem) -> CGRect {
        return section.bounds
    }
}
