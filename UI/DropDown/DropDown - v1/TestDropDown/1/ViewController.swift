//
//  ViewController.swift
//  TestDropDown
//
//  Created by Hoang Tung Lam on 12/29/20.
//

import UIKit
import DropDown

class ViewController: UIViewController {

    @IBOutlet weak var viewContent: UIView!

    let menu: DropDown = {
        let menu = DropDown()
        let images = ["bookmark", "house", "gear", "ear", "book"]
        let titles = ["Item1", "Item2", "Item3", "Item4", "Item5"]
        menu.dataSource = titles
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = {index, _, cell in
            guard let cell = cell as? MyCell else {
                return
            }
            cell.imgImage.image = UIImage(systemName: images[index])
            cell.lblTitle.text = titles[index]
            cell.optionLabel.isHidden = true
            cell.imgImage.image = cell.imgImage.image?.withRenderingMode(.alwaysTemplate)
            
            if index == images.count - 1 {
                cell.imgImage.tintColor = UIColor.red
                cell.lblTitle.textColor = .red
            } else {
                cell.imgImage.tintColor = UIColor.blue
                cell.lblTitle.textColor = .blue
            }
        }
              
        menu.width = 120
        menu.cellHeight = 60
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        menu.anchorView = viewContent
        menu.bottomOffset = CGPoint(x: (menu.anchorView?.plainView.bounds.width)! / 2 - 60, y: 0)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)

        menu.selectionAction = { index, title in
            print("index: \(index) , title: \(title)")
        }
    }

    @objc func tapView() {
        menu.show()
    }
}
