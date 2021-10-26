//
//  KVFlowLayout.swift
//  Cappo
//
//  Created by Khac VU on 3/27/21.
//  Copyright © 2021 vuvankhac.official. All rights reserved.
//

import UIKit

class KVFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let currentCollectionView = collectionView else { return .zero }
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (currentCollectionView.bounds.width / 2.0)
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: currentCollectionView.bounds.size.width, height: currentCollectionView.bounds.size.height)
        guard let attributes = super.layoutAttributesForElements(in: targetRect) as [UICollectionViewLayoutAttributes]? else { return .zero }
        for attribute in attributes {
            let itemHorizontalCenter = attribute.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let currentCollectionView = collectionView else { return nil }
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var visibleRect = CGRect()
        visibleRect.origin = currentCollectionView.contentOffset
        visibleRect.size = currentCollectionView.bounds.size
        for attribute in attributes {
            let distance = visibleRect.midX - attribute.center.x
            let normalizedDistance = distance / UIScreen.main.bounds.width
            let zoom = 1 - 0.25 * (abs(normalizedDistance))
            let alpha = 1 - abs(normalizedDistance)
            attribute.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0)
            attribute.alpha = alpha
            attribute.zIndex = 1
        }
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
