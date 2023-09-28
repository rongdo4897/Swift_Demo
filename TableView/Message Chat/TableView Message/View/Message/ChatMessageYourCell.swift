//
//  ChatMessageYourCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit

class ChatMessageYourCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponent()
    }
    
    func initComponent() {
        viewBackground.layer.cornerRadius = 10
        viewBackground.backgroundColor = .white
    }
}

extension ChatMessageYourCell {
    func setUpData(chatMessage: ChatMessage) {
        // set text label
        lblMessage.text = chatMessage.text
        lblMessage.textColor = .black
    }
}
