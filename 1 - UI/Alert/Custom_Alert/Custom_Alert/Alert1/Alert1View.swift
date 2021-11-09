//
//  Alert1View.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/13/20.
//

import Foundation
import UIKit

class Alert1View: UIView {
    
    static let instance = Alert1View()
    
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("Alert1View", owner: self, options: nil)
        setUpLayoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayoutUI() {
        imgStatus.layer.cornerRadius = imgStatus.frame.width / 2
        imgStatus.layer.borderWidth = 2
        imgStatus.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.viewContent.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.viewParent.backgroundColor = UIColor(white: 1, alpha: 0.5)
        viewAlert.layer.cornerRadius = 10
        viewParent.frame = CGRect(x: 0,
                                  y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        viewParent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum Alert1Type {
        case success
        case failure
    }
    
    func showAlert(title: String, mesage: String, alertType: Alert1Type) {
        lblTitle.text = title
        lblMessage.text = mesage
        switch alertType {
        case .success:
            imgStatus.image = UIImage(named: "ok")
            btnStatus.backgroundColor = #colorLiteral(red: 0.1595838495, green: 0.6034065673, blue: 0.2309266178, alpha: 1)
            
        case .failure:
            imgStatus.image = UIImage(named: "cancel")
            btnStatus.backgroundColor = #colorLiteral(red: 1, green: 0.0603580784, blue: 0, alpha: 1)
        }
        
        UIApplication.shared.keyWindow?.addSubview(viewParent)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        viewParent.removeFromSuperview()
    }
    
}
