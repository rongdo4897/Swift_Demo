//
//  BusyButton.swift
//  LoadingButton
//
//  Created by Hoang Lam on 16/12/2021.
//

import Foundation
import UIKit

class LoadingButton: UIButton {
    
    let busyIndicator = ActivityIndicatorView()

    private var normalTitleColor: UIColor?

    var isBusy = false {
        didSet {
            if isBusy {
                isUserInteractionEnabled = false
                setTitleColor(.clear, for: .normal)
                busyIndicator.startAnimating()
            } else {
                isUserInteractionEnabled = true
                setTitleColor(normalTitleColor, for: .normal)
                busyIndicator.stopAnimating()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        busyIndicator.frame = bounds
        bringSubviewToFront(busyIndicator)
    }
    
    private func prepare() {
        busyIndicator.tintColor = .red
        busyIndicator.backgroundColor = .clear
        busyIndicator.hidesWhenStopped = true
        busyIndicator.stopAnimating()
        addSubview(busyIndicator)

        normalTitleColor = titleColor(for: .normal)
    }
    
}
