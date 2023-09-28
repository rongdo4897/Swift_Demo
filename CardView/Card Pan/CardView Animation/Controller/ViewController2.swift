//
//  ViewController2.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 3/2/21.
//

import UIKit
import FloatingPanel

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let floatingController = FloatingPanelController()
        floatingController.delegate = self
        floatingController.contentMode = .fitToBounds
        
        // contentController
        guard let contentVC = storyboard?.instantiateViewController(identifier: "ContentViewController") as? ContentViewController else {
            return
        }
        floatingController.set(contentViewController: contentVC)
        floatingController.addPanel(toParent: self)
    }
}

extension ViewController2: FloatingPanelControllerDelegate {
    
}
