//
//  ReadBarcodeTableViewCell.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/27.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit

class ReadBarcodeTableViewCell:UITableViewCell {
    /** バーコードデータ用ラベル */
    @IBOutlet weak var barcodeLabel: UILabel!
    /** バーコードHEX用ラベル */
    @IBOutlet weak var barcodeHexLabel: UILabel!
    /** バーコード種別用ラベル */
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
