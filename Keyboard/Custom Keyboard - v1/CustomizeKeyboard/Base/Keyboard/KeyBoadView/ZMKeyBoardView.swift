//
//  ZMKeyBoardView.swift
//  SwiftProject
//
//  Created by 牛新怀 on 2018/7/6.
//  Copyright © 2018年 牛新怀. All rights reserved.
//

import UIKit

// Chiều rộng của màn hình
private let KSCREEN_WIDTH:CGFloat  = UIScreen.main.bounds.width

// Tỷ lệ khung hình chính (bàn phím)
private let KEYRATIO:CGFloat = 86.0  / 63.0

// Chiều rộng của nút
private let BTN_WIDTH:CGFloat = KSCREEN_WIDTH / 10.0 - 6.0

// Chiều cao nút
private let BTN_HEIGHT:CGFloat = BTN_WIDTH * KEYRATIO

// chiều cao mục
private let ITEM_HEIGHT:CGFloat = BTN_HEIGHT + 10.0

// Chiều cao của vùng an toàn dưới cùng
private let SAFE_BOTTOM:CGFloat = (UIScreen.main.bounds.height == 812.0) ? 34.0 : 0.0

// Tổng chiều cao
private let TOTAL_HEIGHT:CGFloat = ITEM_HEIGHT * 4 + 10.0 + SAFE_BOTTOM

private let itemWidth: CGFloat = 75.0

// Màu nổi bật
private let highlightColor: String = "#9da4af"

// Màu tiêu đề được chọn
private let titleSelectColor: String = "#000107"


class ZMKeyBoardView: UIView {
    static let cellId = "keyBoardCellIdentifier"
    // Nguồn đầu vào, chẳng hạn như TextFied
    weak public var inputSource:UIView?
    var dataSource = ZMKeyBoardUtil.getDataSourceBy()
    
    // Kiểm tra xem nút 123 trên bàn phím có được chọn hay không
    var changedSelect = false
    
    init() {
        super.init(frame: .zero)
        self.frame = CGRect.init(x: 0, y: 0, width: KSCREEN_WIDTH, height: TOTAL_HEIGHT)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        backgroundColor = UIColor.hex(hexString: "#c8ccd3")
        collection.frame = CGRect.init(x: 0, y: 0, width: KSCREEN_WIDTH, height: 230)
        addSubview(collection)
        addSubview(capitalButton)
        addSubview(deleteButton)
        addSubview(changedButton)
        addSubview(kongButton)
        addSubview(confirmButton)
    }
    
    lazy var collection : UICollectionView = {
        let object = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        object.backgroundColor = UIColor.hex(hexString: "#c8ccd3")
        object.delegate = self
        object.dataSource = self
        object.register(ZMCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ZMKeyBoardView.cellId)
        return object
    }()

    lazy var layout : ZMCollectionLayout = {
        let object = ZMCollectionLayout()
        return object
    }()
    
    lazy var capitalButton : ZMKeyBoardButtonView = {
        let object = ZMKeyBoardButtonView.init(frame: CGRect.init(x: 3, y: BTN_HEIGHT * 2 + 10 * 3, width: 40, height: BTN_HEIGHT))
        object.setImage(imageNamed: "capitalNormal", state: .normal)
        object.setImage(imageNamed: "capitalSelect", state: .selected)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.white)!, state: .selected)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.hex(hexString: highlightColor))!, state: .normal)
        object.button.layer.masksToBounds = true
        object.delegate = self
        object.style = KeyBoardButtonStyle.keyBoardCapitalButtonStyle
        return object
    }()

    lazy var deleteButton : ZMKeyBoardButtonView = {
        let object = ZMKeyBoardButtonView.init(frame: CGRect.init(x: KSCREEN_WIDTH - 3 - 40, y: BTN_HEIGHT * 2 + 10 * 3, width: 40, height: BTN_HEIGHT))
        object.setImage(imageNamed: "keyNewDelete", state: .normal)
        object.setImage(imageNamed: "keyNewDelete", state: .highlighted)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.hex(hexString: highlightColor))!, state: .normal)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.white)!, state: .highlighted)
        object.button.layer.masksToBounds = true
        object.delegate = self
        object.style = KeyBoardButtonStyle.keyBoardDeleteButtonStyle
        return object
    }()
    
    lazy var changedButton : ZMKeyBoardButtonView = {
        let object = ZMKeyBoardButtonView.init(frame: CGRect.init(x: 3, y: capitalButton.frame.origin.y + capitalButton.frame.size.height + 10, width: itemWidth, height: BTN_HEIGHT))
        object.setTitle("123", state: .normal)
        object.setTitleColor(colorName: titleSelectColor, state: .normal)
        object.setBackgroundColor(color: UIColor.hex(hexString: highlightColor))
        object.delegate = self
        object.style = KeyBoardButtonStyle.keyBoardChangedButtonStyle
        return object
    }()

    lazy var kongButton : ZMKeyBoardButtonView = {
        let object = ZMKeyBoardButtonView.init(frame: CGRect.init(x: itemWidth + 9, y: changedButton.frame.origin.y, width: KSCREEN_WIDTH - itemWidth * 2 - 18, height: BTN_HEIGHT))
        object.setBackgroundImage(image: UIImage.image(color: UIColor.white)!, state: .normal)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.hex(hexString: highlightColor))!, state: .highlighted)
        object.setTitle("Space", state: .normal)
        object.button.layer.masksToBounds = true
        object.setTitleColor(colorName: "#000107", state: .normal)
        object.delegate = self
        object.style = KeyBoardButtonStyle.keyBoardKongButtonStyle
        return object
    }()

    lazy var confirmButton : ZMKeyBoardButtonView = {
        let object = ZMKeyBoardButtonView.init(frame: CGRect.init(x: kongButton.frame.origin.x + kongButton.frame.size.width + 6, y: changedButton.frame.origin.y, width: itemWidth, height: BTN_HEIGHT))
        object.setTitle("Done", state: .normal)
        object.setTitleColor(colorName: "#ffffff", state: .normal)
        object.setTitleColor(colorName: "#000000", state: .highlighted)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.hex(hexString: "#0960fe"))!, state: .normal)
        object.setBackgroundImage(image: UIImage.image(color: UIColor.white)!, state: .highlighted)
        object.button.layer.masksToBounds = true
        object.delegate = self
        object.style = KeyBoardButtonStyle.keyBoardConfirmButtonStyle
        return object
    }()

}

extension ZMKeyBoardView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZMKeyBoardView.cellId, for: indexPath) as! ZMCollectionViewCell
        cell.cellModel = dataSource[indexPath.section][indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}

// Phương pháp nhấp vào nút ô bàn phím
extension ZMKeyBoardView: KeyBoardCellDelegate {
    func KeyBoardCellBtnClick(model: ZMKeyBoadModel) {
        var textFieldText = ""
        print(textFieldText)
        if changedSelect {
            print("Phím hiện tại được chọn là: \(model.keyBoadString!)")
            textFieldText = model.keyBoadString!
        } else {
            if model.isCapital! {
                print("Văn bản hiện được chọn là chữ hoa: \(model.keyBoadString!)")
                textFieldText = model.keyBoadString!
            } else {
                print("Văn bản hiện được chọn là chữ thường: \(model.keyBoadString!.lowercased())")
                textFieldText = model.keyBoadString!.lowercased()
            }
        }
        inputString(textFieldText)
        
    }
    
    
}
 // Cách bấm vào các nút ở cuối bàn phím
extension ZMKeyBoardView: ZMKeyBoardButtonViewDelegate {
    func didSelectButtonClick(view: ZMKeyBoardButtonView, buttonStyle: KeyBoardButtonStyle, sender: UIButton) {
        switch buttonStyle {
        case .keyBoardCapitalButtonStyle: do {// Công tắc trường hợp
            sender.isSelected = !sender.isSelected
            if changedSelect {
                if sender.isSelected {
                    self.dataSource = ZMKeyBoardUtil.getThirdDataSourceBy()
                } else {
                    self.dataSource = ZMKeyBoardUtil.getSecondDataSourceBy()
                }
            } else {
                for i in 0...self.dataSource.count - 1 {
                    let models = self.dataSource[i]
                    if models.count != 0 {
                        for m in 0...models.count - 1 {
                            let source = models[m]
                            source.isCapital = !source.isCapital!
                        }
                        self.dataSource[i] = models
                    }
                }
            }
            collection.reloadData()
            break
        }
        case .keyBoardDeleteButtonStyle: do { // Nút xóa
            ClearBtnClick()
            break
        }
        case .keyBoardChangedButtonStyle: do { // Chuyển đổi bàn phím 123
            sender.isSelected = !sender.isSelected
            changedSelect = sender.isSelected
            sender.isSelected ? sender.setTitle("ABC", for: .normal) : sender.setTitle("123", for: .normal)
            if sender.isSelected {
                self.dataSource = ZMKeyBoardUtil.getSecondDataSourceBy()
            } else {
                self.dataSource = ZMKeyBoardUtil.getDataSourceBy()
            }
            changedCapitalButton()
            collection.reloadData()
            break
        }
        case .keyBoardKongButtonStyle: do { // Khoảng trắng
            inputString(" ")
            break
        }
        case .keyBoardConfirmButtonStyle: do { // Nút xác nhận
            guard let inputSource = self.inputSource else {
                return
            }
            inputSource.endEditing(true)
            break
        }
        }
    }
    
    func changedCapitalButton() {
        capitalButton.button.isSelected = false
        if changedSelect {
            capitalButton.setImage(imageNamed: "", state: .normal)
            capitalButton.setImage(imageNamed: "", state: .selected)
            capitalButton.setBackgroundColor(color: UIColor.hex(hexString: highlightColor))
            capitalButton.setBackgroundImage(image: UIImage.image(color: UIColor.clear)!, state: .normal)
            capitalButton.setBackgroundImage(image: UIImage.image(color: UIColor.clear)!, state: .selected)
            capitalButton.setTitle("#+=", state: .normal)
            capitalButton.setTitle("123", state: .selected)
            capitalButton.setTitleColor(colorName: titleSelectColor, state: .normal)
        } else {
            capitalButton.setTitle("", state: .normal)
            capitalButton.setTitle("", state: .selected)
            capitalButton.setImage(imageNamed: "capitalNormal", state: .normal)
            capitalButton.setImage(imageNamed: "capitalSelect", state: .selected)
            capitalButton.setBackgroundImage(image: UIImage.image(color: UIColor.white)!, state: .normal)
            capitalButton.setBackgroundImage(image: UIImage.image(color: UIColor.hex(hexString: highlightColor))!, state: .selected)
            
        }
    }
}

// Phương pháp xử lý văn bản
extension ZMKeyBoardView {
    
    /// Nhập văn bản vào hộp nhập liệu
    ///
    /// - Parameter string: Ký tự nhập
    private func inputString(_ string:String){
        guard let inputSource = self.inputSource else {
            return
        }
        
        // UITextField
        if(inputSource.isKind(of: UITextField.self)){
            // Nhận kiểm soát đầu vào trống
            let tmp = inputSource as! UITextField
            
            // Xác định xem proxy có được triển khai hay không, proxy shouldChangeCharactersIn có được triển khai hay không
            if(tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false)){
                
                // Phạm vi lựa chọn của hộp nhập hiện tại, kết thúc được nhập theo mặc định
                var range = NSRange.init(location: tmp.text?.count ?? 0, length: 0)
                
                // Nó có thể không phải là phần cuối của đầu vào và một vài ký tự đã được chọn
                if let rag = tmp.selectedTextRange {
                    // Độ lệch con trỏ, nghĩa là, vị trí bắt đầu của vùng chọn
                    let currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                    // Chọn vị trí kết thúc
                    let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                    // Độ dài ký tự đã chọn
                    let length = endOffset - currentOffset
                    // Dải ô đã chọn
                    range = NSRange.init(location: currentOffset, length:length)
                }
                
                // Liệu tác nhân có cho phép nhập các ký tự hay không
                let ret = tmp.delegate?.textField?(tmp, shouldChangeCharactersIn: range, replacementString: string) ?? false
                
                // Khi các ký tự được cho phép, hãy nhập các ký tự
                if(ret){
                    tmp.insertText(string)
                }
            }else{
                // Nhập các ký tự trực tiếp
                tmp.insertText(string)
            }
            
        }
    }
    
    /// Xóa văn bản
    ///
    /// - Parameter button: Nút xóa
    @objc private func ClearBtnClick(){
        guard let inputSource = self.inputSource else {
            return
        }
        
        // UITextField và UITextView
        if(inputSource.isKind(of: UITextField.self)){
            let tmp = inputSource as! UITextField
            
            var currentOffset = (tmp.text?.count ?? 0)
            var length = 1
            // Nó có thể không phải là phần cuối của đầu vào và một vài ký tự đã được chọn
            if let rag = tmp.selectedTextRange {
                // Độ lệch con trỏ, nghĩa là, vị trí bắt đầu của vùng chọn
                currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                // Chọn vị trí kết thúc
                let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                // Độ dài ký tự đã chọn
                length = endOffset - currentOffset
            }
            
            // Xác định xem proxy có được triển khai hay không, proxy shouldChangeCharactersIn có được triển khai hay không
            if(!(currentOffset == 0 && length == 0 ) && (tmp.text?.count ?? 0) > 0 && tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false)){
                
                if(length == 0 && currentOffset > 0){
                    currentOffset -= 1
                }
                
                // Xóa ít nhất một ký tự
                if(length == 0){
                    length = 1
                }
                
                // Xóa vị trí
                let range = NSRange.init(location:currentOffset, length: length)
                
                // Liệu tác nhân có cho phép nhập các ký tự hay không
                let ret = tmp.delegate?.textField?(tmp, shouldChangeCharactersIn: range, replacementString: "") ?? false
                
                // Khi các ký tự được cho phép, hãy xóa chúng trực tiếp
                if(ret){
                    tmp.deleteBackward()
                }
            }else{
                // Xóa trực tiếp
                tmp.deleteBackward()
            } 
        }
    }
}
