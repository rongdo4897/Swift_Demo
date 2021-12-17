//
//  ChatImageMeCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit

class ChatImageMeCell: UITableViewCell {
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
    
    func setUpData(imgString: String) {
        self.imageUrl = imgString
        loadImageWithUrl(urlStr: imgString)
    }
}
