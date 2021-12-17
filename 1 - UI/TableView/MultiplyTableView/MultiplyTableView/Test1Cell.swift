//
//  Test1Cell.swift
//  MultiplyTableView
//
//  Created by Hoang Tung Lam on 1/6/21.
//

import UIKit

class Test1Cell: BaseTBCell {
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
