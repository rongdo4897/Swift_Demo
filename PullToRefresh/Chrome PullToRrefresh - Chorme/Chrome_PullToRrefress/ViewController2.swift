//
//  ViewController2.swift
//  Chrome_PullToRrefress
//
//  Created by Hoang Lam on 05/05/2021.
//

import UIKit
import AsyncDisplayKit

class ViewController2: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    var googleNode = GoogleRefreshNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        
    }
}

//MARK: - Các hàm khởi tạo, setup
extension ViewController2 {
    func initComponent() {
        initTableView()
    }
    
    func initTableView() {
        tblTest.separatorInset.left = 0
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblTest.tableFooterView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tblTest.frame.width, height: 0)))
    }
}

//MARK: - Các hàm chức năng
extension ViewController2 {
    
}

extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
