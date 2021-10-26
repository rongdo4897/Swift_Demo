//
//  ItemCell.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 2/26/21.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setUpdata(location: String) {
        lblLocation.text = location
    }
}
