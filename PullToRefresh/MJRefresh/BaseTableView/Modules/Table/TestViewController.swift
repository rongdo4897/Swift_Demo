//
//  TestViewController.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import UIKit
import MJRefresh

//MARK: - Outlet, Override
class TestViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension TestViewController {
    private func initComponents() {
        initTableView()
    }
    
    private func initTableView() {
        TestCell.registerCellByNib(tblTest)
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.separatorStyle = .none
        tblTest.showsVerticalScrollIndicator = true
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.width, height: 0))
        
        let header = NSRefreshHeader(refreshingTarget: self, refreshingAction:  #selector(refreshHeader))
        tblTest.mj_header = header
        
        let footer = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(refreshFooter))
        footer.setImages([UIImage(named: "ic_capture")!, UIImage(named: "ic_check")!], duration: 0.5, for: .refreshing)
        footer.isRefreshingTitleHidden = true
        tblTest.mj_footer = footer
    }
}

//MARK: - Customize
extension TestViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension TestViewController {
    
}

//MARK: - Các hàm chức năng
extension TestViewController {
    @objc private func refreshHeader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(1)
            self.tblTest.mj_header?.endRefreshing()
        }
    }
    
    @objc private func refreshFooter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(1)
            self.tblTest.mj_footer?.endRefreshing()
        }
    }
}

//MARK: - TableView
extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TestCell.loadCell(tableView) as? TestCell else {return UITableViewCell()}
        cell.setupData(text: "Đây là cell thứ \(indexPath.row + 1)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
