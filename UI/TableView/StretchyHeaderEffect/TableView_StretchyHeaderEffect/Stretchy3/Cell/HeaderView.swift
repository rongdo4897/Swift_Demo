//
//  HeaderView.swift
//  TableView_StretchyHeaderEffect
//
//  Created by Hoang Tung Lam on 12/1/20.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet var albumimage: UIImageView!
    @IBOutlet var albumTitleView: UIView!
    @IBOutlet var albumButton: UIView!

    @IBOutlet var albumTopButton: UIView!
    @IBOutlet var btnAlbum: UIButton!
    @IBOutlet var btnMusic: UIButton!

    @IBOutlet var albumTop: NSLayoutConstraint!
    @IBOutlet var ButtonBottom: NSLayoutConstraint!

    override func awakeFromNib() {
        albumimage.layer.cornerRadius = 5
        btnAlbum.layer.cornerRadius = 3
    }

}
