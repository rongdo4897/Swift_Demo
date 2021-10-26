//
//  MusicCell.swift
//  TableView_StretchyHeaderEffect
//
//  Created by Hoang Tung Lam on 12/3/20.
//

import UIKit

class MusicCell: UITableViewCell {
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
