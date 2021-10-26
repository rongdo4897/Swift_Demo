//
//  DataCell.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

class DataCell: UITableViewCell {
    @IBOutlet weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
