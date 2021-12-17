//
//  ChatMessageMeCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit

class ChatMessageMeCell: UITableViewCell {
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
        viewBackground.backgroundColor = #colorLiteral(red: 0.2282610679, green: 0.8309208439, blue: 0.7371570425, alpha: 1)
    }
}

extension ChatMessageMeCell {
    func setUpData(chatMessage: ChatMessage) {
        // set text label
        lblMessage.text = chatMessage.text
        lblMessage.textColor = .white
    }
}
