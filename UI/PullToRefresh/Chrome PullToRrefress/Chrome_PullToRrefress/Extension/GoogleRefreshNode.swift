//
//  GoogleRefreshNode.swift
//  Chrome_PullToRrefress
//
//  Created by Hoang Tung Lam on 4/12/21.
//

import Foundation
import AsyncDisplayKit

class GoogleRefreshNode: ASDisplayNode {
    
    enum Position {
        case close
        case refresh
        case back
    }
    
    struct Const {
        static let insets: UIEdgeInsets = .init(top: 30.0, left: 0.0, bottom: 30.0, right: 0.0)
        static let indicatorSize: CGSize = .init(width: 50.0, height: 50.0)
        static let keyPath = "transform.rotation"
    }
    
    let indicatorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor =
            UIColor.init(red: 251 / 255, green: 41 / 255, blue: 66 / 255, alpha: 1.0)
        node.style.preferredSize = Const.indicatorSize
        node.cornerRadius = Const.indicatorSize.height / 2.0
        node.clipsToBounds = true
        node.isHidden = true
        return node
    }()
    
    let closeButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(UIImage(named: "icClose"), for: .normal)
        node.setImage(UIImage(named: "icClose")?.newColor(with: .white), for: .selected)
        node.imageNode.style.preferredSize = .init(width: 24.0, height: 24.0)
        node.backgroundColor = .clear
        return node
    }()
    
    let refreshNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(UIImage(named: "icReload"), for: .normal)
        node.setImage(UIImage(named: "icReload")?.newColor(with: .white), for: .selected)
        node.imageNode.style.preferredSize = .init(width: 24.0, height: 24.0)
        node.backgroundColor = .clear
        return node
    }()
    
    let plusNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(UIImage(named: "icPlus"), for: .normal)
        node.setImage(UIImage(named: "icPlus")?.newColor(with: .white), for: .selected)
        node.imageNode.style.preferredSize = .init(width: 24.0, height: 24.0)
        node.backgroundColor = .clear
        return node
    }()
    
    private var targetPosition: Position? = nil
    
    // refresh property
    private var rotateAnimation: CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: Const.keyPath)
        rotation.fromValue = 0.0
        rotation.toValue = CGFloat(2.0 * Float.pi)
        rotation.duration = 0.5
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.isAdditive = true
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = .infinity
        return rotation
    }
    private var isAnimating: Bool = false
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .clear
    }
    
    func startRefresh() {
        self.isAnimating = true
        self.refreshNode.layer.removeAllAnimations()
        self.refreshNode.layer.add(self.rotateAnimation, forKey: Const.keyPath)
        closeButtonNode.isHidden = true
        plusNode.isHidden = true
        
        // auto end refresh after 2.0 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.endRefresh()
        })
    }
    
    func endRefresh() {
        guard self.targetPosition == .refresh else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }, completion: { fin in
            guard fin else { return }
            self.isAnimating = false
            self.refreshNode.layer.removeAllAnimations()
            self.closeButtonNode.isHidden = false
            self.plusNode.isHidden = false
        })
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        guard let targetPosition = self.targetPosition else { return }
        
        var pos: CGPoint
        self.updateSelectionStyleIfNeeds()
        
        switch targetPosition {
        case .close:
            pos = closeButtonNode.frame.origin
        case .refresh:
            pos = refreshNode.frame.origin
        case .back:
            pos = plusNode.frame.origin
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            pos.x -= Const.indicatorSize.width / 4.0
            pos.y -= Const.indicatorSize.height / 4.0
            self.indicatorNode.frame.origin = pos
        }, completion: { fin in
            context.completeTransition(fin)
        })
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let elements: [ASLayoutElement] = [closeButtonNode, refreshNode, plusNode]
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 20.0,
                                            justifyContent: .spaceAround,
                                            alignItems: .start,
                                            children: elements)
        let insetLayout = ASInsetLayoutSpec(insets: Const.insets, child: stackLayout)
        
        let indicatorLayout = ASAbsoluteLayoutSpec(sizing: .sizeToFit, children: [indicatorNode])
        return ASWrapperLayoutSpec(layoutElements: [indicatorLayout, insetLayout])
    }
    
    func refreshAreaHeight(_ constrainedSize: ASSizeRange) -> CGFloat {
        return self.calculateLayoutThatFits(constrainedSize).size.height
    }
    
    private func updateSelectionStyleIfNeeds() {
        guard let targetPosition = self.targetPosition else { return }
        
        switch targetPosition {
        case .close:
            closeButtonNode.isSelected = true
            refreshNode.isSelected = false
            plusNode.isSelected = false
        case .refresh:
            closeButtonNode.isSelected = false
            refreshNode.isSelected = true
            plusNode.isSelected = false
        case .back:
            closeButtonNode.isSelected = false
            refreshNode.isSelected = false
            plusNode.isSelected = true
        }
    }
    
    func updatePosition(scrollView: UIScrollView) {
        // Block context during refresh animating.
        guard !isAnimating else { return }
        
        guard scrollView.contentOffset.y < 0 else {
            // hide area
            self.isHidden = true
            self.alpha = 0.0
            return
        }
        
        if scrollView.panGestureRecognizer.numberOfTouches == 0,
            self.alpha >= 1.0,
            self.targetPosition == .refresh  {
            self.startRefresh()
            return
        }
        
        // show area
        self.isHidden = false
        
        // update alpha
        let location =  scrollView.panGestureRecognizer.location(in: scrollView)
        let sizeRange = ASSizeRangeMake(.zero, scrollView.bounds.size)
        let refreshAreaHeight = self.refreshAreaHeight(sizeRange)
        self.alpha = abs(scrollView.contentOffset.y) / refreshAreaHeight
        
        
        if self.alpha >= 1.0 {
            indicatorNode.isHidden = false
            // update previous selection status
            self.updateSelectionStyleIfNeeds()
        } else {
            // reset selection status
            indicatorNode.isHidden = true
            closeButtonNode.isSelected = false
            refreshNode.isSelected = false
            plusNode.isSelected = false
        }
        
        // update target positin *dragging only
        guard scrollView.isDragging, self.alpha >= 1.0 else { return }
        let screenWidth = scrollView.frame.width
    
        if location.x < screenWidth / 3 {
            guard self.targetPosition != .close else { return }
            self.targetPosition = .close
        } else if location.x > screenWidth * (2 / 3) {
            guard self.targetPosition != .back else { return }
            self.targetPosition = .back
        } else {
            guard self.targetPosition != .refresh else { return }
            self.targetPosition = .refresh
        }
        
        // Do animate
        self.transitionLayout(withAnimation: true,
                              shouldMeasureAsync: false,
                              measurementCompletion: nil)
    }
}
