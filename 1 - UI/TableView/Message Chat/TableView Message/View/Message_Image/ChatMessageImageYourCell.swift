//
//  ChatMessageImageYourCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit
import Kingfisher

class ChatMessageImageYourCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    
    weak var delegate: ChatImageCellDelegate?
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponent()
    }
    
    func initComponent() {
        imgImage.layer.cornerRadius = 10
        imgImage.layer.borderWidth = 0.5
        imgImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imgImage.layer.masksToBounds = true
        imgImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        imgImage.isUserInteractionEnabled = true
        imgImage.layer.opacity = 0.6
        viewBackground.layer.cornerRadius = 10
        viewBackground.backgroundColor = .systemGray6
    }
    
    @objc func tapImage() {
        delegate?.moveData(imageUrl: self.imageUrl)
    }
    
    func loadImageWithUrl(urlStr: String?) {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            imgImage.kf.setImage(with: url)
        } else {
            imgImage.image = nil
        }
    }
    
    func setUpdata(model: ChatMessage) {
        self.imageUrl = model.image
        loadImageWithUrl(urlStr: model.image)
        lblMessage.text = model.text
        lblMessage.textColor = .black
    }
}
