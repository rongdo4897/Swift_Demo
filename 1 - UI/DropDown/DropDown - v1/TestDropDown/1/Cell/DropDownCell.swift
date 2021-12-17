//
//  MyCell.swift
//  TestDropDown
//
//  Created by Hoang Tung Lam on 12/29/20.
//

import DropDown
import UIKit

class MyCell: DropDownCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpdata(imgName: String, title: String) {
        lblTitle.text = title
        imgImage.image = UIImage(systemName: imgName)
    }

}
