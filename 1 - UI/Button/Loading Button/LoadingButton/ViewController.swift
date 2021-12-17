//
//  ViewController.swift
//  LoadingButton
//
//  Created by Hoang Lam on 16/12/2021.
//

import UIKit

//MARK: - Outlet, Override
class ViewController: UIViewController {
    @IBOutlet weak var btnLoading: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
    
    @IBAction func btnLoadingTapped(_ sender: Any) {
        btnLoading.isBusy = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.btnLoading.isBusy = false
        }
    }
}

//MARK: - Các hàm khởi tạo
extension ViewController {
    private func initComponents() {
        initLoadingButton()
    }
    
    private func initLoadingButton() {
        btnLoading.busyIndicator.tintColor = .white
        btnLoading.busyIndicator.backgroundColor = .blue
        btnLoading.busyIndicator.clipsToBounds = true
        btnLoading.busyIndicator.layer.cornerRadius = 30
        let image = UIImage(named: "ic_arrowLeft")
        btnLoading.setImage(image, for: .normal)
        btnLoading.backgroundColor = .blue
        btnLoading.clipsToBounds = true
        btnLoading.layer.cornerRadius = 30
    }
}

//MARK: - Customize
extension ViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension ViewController {
    
}

//MARK: - Các hàm chức năng
extension ViewController {
    
}
