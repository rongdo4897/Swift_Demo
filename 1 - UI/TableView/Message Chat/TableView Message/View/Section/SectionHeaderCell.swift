//
//  SectionHeaderCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit

class SectionHeaderCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponent()
    }

    func initComponent() {
        lblTitle.textColor = .white
        lblTitle.layer.masksToBounds = true
        lblTitle.textAlignment = .center
        viewBackground.layer.cornerRadius = viewBackground.frame.height / 2
        viewBackground.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
}

extension SectionHeaderCell {
    func setUpData(title: String) {
        lblTitle.text = title
    }
}
