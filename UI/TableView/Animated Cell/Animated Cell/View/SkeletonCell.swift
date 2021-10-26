//
//  SkeletonCell.swift
//  Animated Cell
//
//  Created by Hoang Tung Lam on 1/26/21.
//

import UIKit

class SkeletonCell: UITableViewCell {
    @IBOutlet weak var imgTest: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
