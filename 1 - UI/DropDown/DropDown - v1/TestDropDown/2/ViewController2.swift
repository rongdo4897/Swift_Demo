//
//  ViewController2.swift
//  TestDropDown
//
//  Created by Hoang Tung Lam on 12/29/20.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var btnSelectFruit: UIButton!
    @IBOutlet var btnFruit: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelectFruit.layer.cornerRadius = btnSelectFruit.frame.height / 2
        btnFruit.forEach { (btn) in
            btn.layer.cornerRadius = btn.frame.height / 2
            btn.isHidden = true
            btn.alpha = 0
        }
    }

    @IBAction func btnSelectFruitTapped(_ sender: UIButton) {
        btnFruit.forEach { (btn) in
            UIView.animate(withDuration: 1) {
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
            }
        }
    }
    @IBAction func btnFruitTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else {
            return
        }
        print(title)
    }
}
