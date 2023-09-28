//
//  TestCell.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import UIKit

class TestCell: BaseTBCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewPan: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension TestCell {
    private func initComponents() {
        initViews()
    }
    
    private func initViews() {
    }
}

//MARK: - Customize
extension TestCell {
    private func customizeComponents() {
        customizeViews()
    }
    
    private func customizeViews() {
        viewPan.addShadow()
    }
}

//MARK: - Action - Obj
extension TestCell {
    
}

//MARK: - Các hàm chức năng
extension TestCell {
    func setupData(text: String) {
        lblTitle.text = text
    }
}
