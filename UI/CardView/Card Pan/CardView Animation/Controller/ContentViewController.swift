//
//  ContentViewController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 3/2/21.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var tblLocation: UITableView!
    
    var listLocation = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
    
    func initComponents() {
        initData()
        initTableView()
    }
    
    func initData() {
        listLocation.append("New York City")
        listLocation.append("Florida")
        listLocation.append("London")
        listLocation.append("LA")
        listLocation.append("Dallas")
        listLocation.append("Japan")
        listLocation.append("Rome")
        listLocation.append("Viet Nam")
    }
    
    func initTableView() {
        tblLocation.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        tblLocation.dataSource = self
        tblLocation.delegate = self
        tblLocation.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblLocation.bounds.width, height: 0))
        tblLocation.separatorInset.left = 0
    }
}

extension ContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        cell.setUpdata(location: listLocation[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
