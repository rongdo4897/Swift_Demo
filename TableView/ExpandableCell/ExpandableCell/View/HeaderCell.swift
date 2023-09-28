//
//  HeaderCell.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

protocol HeaderCellDelegate: class {
    func toggleSection(_ header: HeaderCell, section: Int)
}

class HeaderCell: UITableViewCell {
    @IBOutlet weak var lblSection: UILabel!
    
    weak var delegate: HeaderCellDelegate?
    var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.toggleSection(self, section: self.section)
    }
    
}
