//
//  ZMCollectionViewCell.swift
//  SwiftProject
//
//  Created by 牛新怀 on 2018/7/6.
//  Copyright © 2018年 牛新怀. All rights reserved.
//

import UIKit

// Tác nhân của bàn phím
protocol KeyBoardCellDelegate: NSObjectProtocol {
    // Tác nhân được nhấp (click)
    func KeyBoardCellBtnClick(model: ZMKeyBoadModel)
}

class ZMCollectionViewCell: UICollectionViewCell {
    weak var delegate: KeyBoardCellDelegate?
    
    var cellModel: ZMKeyBoadModel! {
        didSet{
            if cellModel.isCapital! {
                keyBoardButton.setTitle(cellModel.keyBoadString, for: .normal)
            } else {
                keyBoardButton.setTitle(cellModel.keyBoadString?.lowercased(), for: .normal)
            }
            tipImageView.model = cellModel
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        contentView.addSubview(keyBoardButton)
    }
    
    lazy var keyBoardButton : UIButton = {
        let object = UIButton()
        // Đặt các thuộc tính liên quan
        object.setTitleColor(UIColor.darkGray, for: .normal)
        object.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 23)
        object.backgroundColor = UIColor.white
        
        // Đặt hiệu ứng
        object.layer.cornerRadius = 5
        object.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        object.layer.shadowOpacity = 0.4
        object.layer.shadowRadius = 3
        object.layer.shadowColor = UIColor.hex(hexString: "#888b8d").cgColor//#dfe1e6
        object.frame = self.contentView.bounds
        
        // Đặt sự kiện
        object.addTarget(self, action: #selector(KeyboardBtnClick(button:)), for: .touchUpInside)
        object.addTarget(self, action: #selector(KeyboardBtnTouchDown(button:)), for: .touchDown)
        object.addTarget(self, action: #selector(KeyboardBtnTouchUpOutside(button:)), for: .touchUpOutside)
        return object
    }()

    lazy var tipImageView : KeyBoardTipImageView = {
        let object = KeyBoardTipImageView()
        return object
    }()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        guard let window = newWindow else {
            return
        }
        window.addSubview(tipImageView)
        tipImageView.isHidden = true
    }

    
    
}

extension ZMCollectionViewCell {
    
    /// Thả ngón tay của bạn sau khi nút được nhấp
    ///
    /// - Parameter button: Nút
    @objc private func KeyboardBtnClick(button:UIButton){
        // Thực hiện sự kiện nhấp vào nút
        delegate?.KeyBoardCellBtnClick(model: cellModel)
        
        // Chế độ xem lời nhắc hủy bị hoãn
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
            DispatchQueue.main.sync {
                self.tipImageView.isHidden = true
            }
        }
    }
    
    /// Sự kiện khi nút được nhấn và chế độ xem lời nhắc được hiển thị khi nhấn nút
    ///
    /// - Parameter button: Nút
    @objc private func KeyboardBtnTouchDown(button:UIButton){
        tipImageView.isHidden = false
        var btnCenter = button.center
        btnCenter.y = self.bounds.height
        let center = self.convert(btnCenter, to: self.window)
        
        tipImageView.center = center
    }
    
    /// Khi nhấn nút, sự kiện sẽ được giải phóng bên ngoài nút và chế độ xem lời nhắc sẽ bị ẩn sau khi nhấn nút
    ///
    /// - Parameter button: Nút
    @objc private func KeyboardBtnTouchUpOutside(button:UIButton){
        tipImageView.isHidden = true
    }
}
