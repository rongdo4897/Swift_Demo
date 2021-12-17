//
//  VideoViewController.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/28/21.
//

import UIKit
import WebKit
import LinkPresentation

class WebViewController: UIViewController {
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var viewVideo: UIView!
    
    var link: String = ""
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private var linkView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
     
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        viewVideo.addSubview(webView)
        webView.load(URLRequest(url: URL(string: self.link)!))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = viewVideo.bounds
    }
    
    func initComponent() {
        btnDismiss.layer.cornerRadius = btnDismiss.frame.height / 2
        btnDismiss.layer.borderWidth = 1
        btnDismiss.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
