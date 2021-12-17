//
//  ViewController.swift
//  CustomizeKeyboard
//
//  Created by Hoang Lam on 15/12/2021.
//

import UIKit

//MARK: - Outlet, Override
class ViewController: UIViewController {
    @IBOutlet weak var tfTest: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo
extension ViewController {
    private func initComponents() {
        initKeyboard()
    }
    
    private func initKeyboard() {
        let keyboard = ZMKeyBoardView()
        tfTest.inputView = keyboard
        keyboard.inputSource = tfTest
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
