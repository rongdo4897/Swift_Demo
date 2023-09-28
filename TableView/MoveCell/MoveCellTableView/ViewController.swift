//
//  ViewController.swift
//  MoveCellTableView
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnSort: UIBarButtonItem!
    @IBOutlet weak var tblTest: UITableView!
    
    var listDatas = ["One","Two","Three","Four"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    func initTableView() {
        tblTest.separatorInset.left = 0
        tblTest.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
    }

    @IBAction func btnSortTapped(_ sender: Any) {
        if tblTest.isEditing {
            tblTest.isEditing = false
        } else {
            tblTest.isEditing = true
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        listDatas.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

