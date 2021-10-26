//
//  ViewController.swift
//  MultiplyTableView
//
//  Created by Hoang Tung Lam on 1/6/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentTest: UISegmentedControl!
    @IBOutlet weak var tbl1: UITableView!
    @IBOutlet weak var tbl2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Test1Cell.registerCellByNib(tbl1)
        tbl1.dataSource = self
        tbl1.delegate = self
        tbl1.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbl1.frame.width, height: 0))
        tbl1.tableFooterView?.backgroundColor = UIColor.white
        Test2Cell.registerCellByNib(tbl2)
        tbl2.dataSource = self
        tbl2.delegate = self
        tbl2.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbl2.frame.width, height: 0))
        tbl2.tableFooterView?.backgroundColor = UIColor.white
        tbl1.isHidden = false
        tbl2.isHidden = true
    }

    @IBAction func segmentTestValueChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tbl1.isHidden = false
            tbl2.isHidden = true
        } else {
            tbl1.isHidden = true
            tbl2.isHidden = false
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tbl1:
            return 30
        case tbl2:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tbl1:
            guard let cell = Test1Cell.loadCell(tableView) as? Test1Cell else{
                return UITableViewCell()
            }
            cell.lblTitle.text = "aaaaa \(indexPath.row)"
            return cell
        case tbl2:
            guard let cell = Test2Cell.loadCell(tableView) as? Test2Cell else{
                return UITableViewCell()
            }
            cell.lblTitle.text = "bbbbb \(indexPath.row)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tbl1:
            return 40
        case tbl2:
            return 40
        default:
            return 0
        }
    }
}
