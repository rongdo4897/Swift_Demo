//
//  ViewController.swift
//  DemoChart
//
//  Created by Hoang Lam on 27/05/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var progressView: HorizontalProgressView!
    @IBOutlet weak var progressView2: HorizontalProgressView!
    
    let listColor1: [(Float, UIColor)] = [
        (0.25, UIColor.colorFromHexString(hex: "0082D1")),
        (0.25, UIColor.colorFromHexString(hex: "FFBF2E")),
        (0.15, UIColor.colorFromHexString(hex: "E24F3E")),
    ]
    
    let listColor2: [(Float, UIColor)] = [
        (0.64, UIColor.colorFromHexString(hex: "0082D1"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initProgressView()
    }
    
    func initProgressView() {
        // Progress View 1
        progressView.trackBackgroundColor = UIColor.colorFromHexString(hex: "EFEFEF")
        progressView.dataSource = self
        progressView.delegate = self
        progressView.setTextTopLabel(text: "予定 900 万円")
        progressView.setTextBottomLabel(text: "現在の残高 1,050 万円")
        progressView.dashedLineColor = UIColor.colorFromHexString(hex: "D5D5D5")
        
        for (index, dColor) in listColor1.enumerated() {
            self.progressView.setProgress(section: index, to: dColor.0)
        }
        
        // Progress View 2
        progressView2.trackBackgroundColor = UIColor.colorFromHexString(hex: "0082D1").withAlphaComponent(0.2)
        progressView2.dataSource = self
        progressView2.delegate = self
        progressView2.setTextTopLabel(text: "手元予備資金 300 万円")
        progressView2.setTextBottomLabel(text: "現在の残高 500 万円")
        progressView2.dashedLineColor = UIColor.colorFromHexString(hex: "D5D5D5")
        
        for (index, dColor) in listColor2.enumerated() {
            self.progressView2.setProgress(section: index, to: dColor.0)
        }
    }
}

extension ViewController: HorizontalProgressViewDataSource, HorizontalProgressViewDelegate {
    func numberOfSections(in progressView: HorizontalProgressView) -> Int {
        switch progressView {
        case self.progressView:
            return listColor1.count
        case progressView2:
            return listColor2.count
        default:
            return 0
        }
    }
    
    func progressView(_ progressView: HorizontalProgressView, viewForSection section: Int) -> HorizontalProgressViewSectionItem {
        switch progressView {
        case self.progressView:
            let bar = HorizontalProgressViewSectionItem()
            bar.updateBackgroundColor(with: listColor1[section].1)
            return bar
        case progressView2:
            let bar = HorizontalProgressViewSectionItem()
            bar.updateBackgroundColor(with: listColor2[section].1)
            return bar
        default:
            return HorizontalProgressViewSectionItem()
        }
    }
    
    func progressView(_ progressView: HorizontalProgressView, didTapSectionAt index: Int) {
        print(index)
    }
}
