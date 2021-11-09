//
//  ImageViewController.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/28/21.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var btnDismiss: UIButton!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        setUpdata()
    }
    
    func initComponent() {
        btnDismiss.layer.cornerRadius = btnDismiss.frame.height / 2
        btnDismiss.layer.borderWidth = 1
        btnDismiss.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // scrollview
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
    }
    
    func setUpdata() {
        loadImageWithUrl(urlStr: imageUrl)
    }
    
    func loadImageWithUrl(urlStr: String?) {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            imgImage.kf.setImage(with: url)
        } else {
            imgImage.image = nil
        }
    }
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imgImage.image {
                let ratioW = imgImage.frame.width / image.size.width
                let ratioH = imgImage.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > imgImage.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imgImage.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight * scrollView.zoomScale > imgImage.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imgImage.frame.height :
                    (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
