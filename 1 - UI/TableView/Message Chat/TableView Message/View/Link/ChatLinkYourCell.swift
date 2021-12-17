//
//  ChatLinkYourCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/29/21.
//

import UIKit
import WebKit
import LinkPresentation

protocol ChatLinkDelegate: class {
    func moveData(link: String)
}

class ChatLinkYourCell: UITableViewCell {
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var viewHyperLink: UIView!
    @IBOutlet weak var viewBackground: UIView!

    private var linkView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
    
    weak var delegate: ChatLinkDelegate?
    var linkString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponent()
    }
    
    func initComponent() {
        initLinkView()
        customizeLayout()
        actionComponent()
    }
    
    func actionComponent() {
        viewBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    
    func initLinkView() {
        self.linkView.frame = self.viewHyperLink.bounds
        self.viewHyperLink.addSubview(self.linkView)
        self.linkView.isUserInteractionEnabled = false
    }
    
    func customizeLayout() {
        viewBackground.backgroundColor = .white
        viewBackground.layer.cornerRadius = 10
        viewBackground.layer.borderWidth = 0.5
        viewBackground.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @objc func tapView() {
        delegate?.moveData(link: self.linkString)
    }
}

extension ChatLinkYourCell {
    private func fetchPreview(link: String) {
        let url = URL(string: link)!
        
        let metadataProvider = LPMetadataProvider()
        metadataProvider.startFetchingMetadata(for: url) { (metaData, _) in
            guard let metaData = metaData else {return}
            
            DispatchQueue.main.async {
                self.linkView.metadata = metaData
            }
        }
    }
    
    private func attributedLinkLabel(link: String) {
        let attributedString = NSMutableAttributedString.init(string: link)
        attributedString.addAttribute(.link, value: 1, range: NSRange(location: 0, length: attributedString.length))
        lblLink.attributedText = attributedString
    }
    
    func setUpData(link: String) {
        self.linkString = link
        fetchPreview(link: link)
        attributedLinkLabel(link: link)
    }
}
