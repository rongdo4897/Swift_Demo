//
//  Alert2ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/13/20.
//

import SCLAlertView
import UIKit

class Alert2ViewController: UIViewController {

    
    private let tblTest = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tblTest)
        tblTest.frame = view.bounds
        tblTest.delegate = self
        tblTest.dataSource = self
        // Do any additional setup after loading the view.
    }
}

extension Alert2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Tap for alert"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            SCLAlertView().showSuccess("Success", subTitle: "Some long title goes here")
        } else if indexPath.row == 1 {
            SCLAlertView().showError("Error", subTitle: "Some long title goes here")
        } else if indexPath.row == 2 {
            SCLAlertView().showInfo("Info", subTitle: "Some long title goes here")
        } else if indexPath.row == 3 {
            SCLAlertView().showEdit("Edit", subTitle: "Some long title goes here")
        } else if indexPath.row == 4 {
            SCLAlertView().showWarning("Warning", subTitle: "Some long title goes here")
        } else if indexPath.row == 5 {
            SCLAlertView().showNotice("Notice", subTitle: "Some long title goes here")
        }
    }
}
