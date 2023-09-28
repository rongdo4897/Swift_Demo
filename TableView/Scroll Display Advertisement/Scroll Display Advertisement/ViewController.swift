//
//  ViewController.swift
//  Scroll Display Advertisement
//
//  Created by Lam Hoang Tung on 9/19/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let bannerView = BannerView()
    
    private let identifier = "Identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initBannerView()
    }
    
    private func initTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    private func initBannerView() {
        let aspectRatio: CGFloat = 55 / 320
        
        bannerView.addTarget(self, action: #selector(didTapBanner(sender:)), for: .touchUpInside)
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: mainView.frame.width * aspectRatio)
        ])
    }
}

// MARK: Objc
extension ViewController {
    @objc private func didTapBanner(sender: BannerView) {
        guard let url = URL(string: "https://developer.apple.com/wwdc23/") else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: Action
extension ViewController {
    func showBanner() {
        bannerView.isUserInteractionEnabled = true
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1.0) {
            self.bannerView.transform = .identity
        }
        animator.startAnimation()
    }
    
    func hideBanner() {
        bannerView.isUserInteractionEnabled = false
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1.0) {
            self.bannerView.transform = .init(translationX: 0, y: self.bannerView.bounds.height)
        }
        animator.startAnimation()
    }
}

// MARK: TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) 
        cell.textLabel?.text = "Line \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case tableView:
            if scrollView.contentOffset.y > 0 {
                hideBanner()
            } else {
                showBanner()
            }
        default:
            ()
        }
    }
}
