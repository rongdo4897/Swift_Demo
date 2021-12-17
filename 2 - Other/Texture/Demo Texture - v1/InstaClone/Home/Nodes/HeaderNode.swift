//
//  HeaderNode.swift
//  InstaClone
//
//  Created by Philip Martin on 13/12/2019.
//  Copyright © 2019 Phil Martin. All rights reserved.
//

import AsyncDisplayKit

// Phần header có chữ Baby Mario và dấu ba chấm
class HeaderNode: BaseNode{
    
    var profileImageNode = ASNetworkImageNode()
    var nameNode = ASTextNode()
    var extraButton = ASButtonNode()
    var elipseNode = ASImageNode()
    
    override init() {
        super.init()
        setup()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let leftPadding = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 8,
                                 left: 16,
                                 bottom: 8,
                                 right: 0),
            child: profileImageNode)
        
        let iconSpec = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .end,
            alignItems: .end,
            children: [extraButton])
        
        let rightPadding = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0,
                                 left: 0,
                                 bottom: 0,
                                 right: 16),
            child: iconSpec)
        rightPadding.style.flexGrow = 1
        
        let layoutSpec = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10, justifyContent: .start,
            alignItems: .center,
            children:
            [
                leftPadding,
                nameNode,
                rightPadding]
        )
        return layoutSpec
    }
    
    override func asyncTraitCollectionDidChange(withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection) {
        super.asyncTraitCollectionDidChange(withPreviousTraitCollection: previousTraitCollection)
        dynamicColour()
    }
    
    //MARK:- Private Fucntions
    
    private func setup(){
        let cornerRadius: CGFloat = 35.0
        profileImageNode.cornerRoundingType = .precomposited
        profileImageNode.cornerRadius = cornerRadius/2
        profileImageNode.style.preferredSize = CGSize(width: 35, height: 35)
        dynamicColour()
        extraButton.style.preferredSize = CGSize(width: 10, height: 10)
    }
    
    private func dynamicColour() {
        if let colour = iconColour{
            let image = ASImageNodeTintColorModificationBlock(colour)(UIImage(named:"elipse")!, ASPrimitiveTraitCollectionMakeDefault())
            extraButton.setImage(image, for: .normal)
        }
    }

    func populate(feed: NewsFeed?) {
        nameNode.attributedText = NSAttributedString(string: feed?.user?.username ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label,  NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        profileImageNode.url = URL(string: feed?.user?.profileIcon ?? "")
    }
    
}
