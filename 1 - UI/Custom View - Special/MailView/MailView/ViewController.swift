//
//  ViewController.swift
//  MailView
//
//  Created by Lam Hoang Tung on 7/31/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    let mailIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadow()
        setupImageView()
    }

    private func addShadow() {
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowRadius = 12
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOffset = CGSize(width: 2, height: 0)
    }
    
    private func setupImageView() {
        mainView.addSubview(mailIcon)
        mailIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let size: CGFloat = 40
        
        NSLayoutConstraint.activate([
            mailIcon.widthAnchor.constraint(equalToConstant: size),
            mailIcon.heightAnchor.constraint(equalToConstant: size),
            mailIcon.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            mailIcon.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
        mailIcon.image = UIImage.mailBadgeImage(boundSize: CGSize(width: size, height: size), inset: 3, cornerRadius: 14.5)
        mailIcon.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
    }
}

