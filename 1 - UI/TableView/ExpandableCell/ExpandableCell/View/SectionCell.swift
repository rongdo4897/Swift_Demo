//
//  SectionCell.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

class SectionCell: UITableViewCell {
    @IBOutlet weak var lblSection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
