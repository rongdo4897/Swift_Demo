//
//  CardCell.swift
//  Card_Slider
//
//  Created by Hoang Lam on 17/05/2021.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var viewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeComponents()
    }

}

extension CardCell {
    func customizeComponents() {
        viewColor.layer.cornerRadius = 20
    }
    
    func setUpData(color: UIColor) {
        viewColor.backgroundColor = color
    }
}
