//
//  FilterCell.swift
//  CameraModule
//
//  Created by Hoang Lam on 25/05/2022.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var imgFilter: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(_ type: FilterType) {
        let image = UIImage(named: "image")!
        let ciImage = CIImage(image: image)
        imgFilter.image = UIImage(ciImage: ciImage!.applyFilter(in: type))
    }

}
