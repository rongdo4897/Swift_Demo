//
//  TestCell.swift
//  CustomizeHeaderTableView_Tiki
//
//  Created by Hoang Tung Lam on 1/14/21.
//

import UIKit

class TestCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
