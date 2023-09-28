//
//  ImageViewController.swift
//  CameraModule
//
//  Created by Hoang Lam on 25/05/2022.
//

import UIKit

//MARK: - Outlet, Override
class ImageViewController: UIViewController {
    @IBOutlet weak var imgResult: UIImageView!
    
    var imageResult: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Init
extension ImageViewController {
    private func initComponents() {
        imgResult.image = imageResult
    }
}

//MARK: - Customize
extension ImageViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension ImageViewController {
    
}

//MARK: - Action
extension ImageViewController {
    
}
