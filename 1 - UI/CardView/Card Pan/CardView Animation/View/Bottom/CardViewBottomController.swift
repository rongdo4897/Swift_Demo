//
//  CardViewController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 2/26/21.
//

import UIKit

protocol CardViewControllerDelegate: class {
    func didSelectCell(location: String)
}

class CardViewBottomController: UIViewController {
    @IBOutlet weak var viewHandleArea: UIView!
    @IBOutlet weak var viewLineHeader: UIView!
    @IBOutlet weak var tblLocation: UITableView!
    
    var listLocation: [String] = [String]()
    
    weak var delegate: CardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
    }
    
    func initComponent() {
        initData()
        initTableView()
        customizeLayout()
    }
    
    func initData() {
        listLocation.append("California")
        listLocation.append("Texas")
        listLocation.append("New York")
        listLocation.append("Florida")
        listLocation.append("Illinois")
        listLocation.append("Pennsylvania")
        listLocation.append("New Jersey")
        listLocation.append("Ohio")
        listLocation.append("Virginia")
        listLocation.append("Bắc Carolina")
        listLocation.append("Georgia")
        listLocation.append("Massachusetts")
        listLocation.append("Michigan")
        listLocation.append("Washington")
        listLocation.append("Maryland")
        listLocation.append("Indiana")
        listLocation.append("Minnesota")
        listLocation.append("Arizona")
        listLocation.append("Colorado")
        listLocation.append("Wisconsin")
        listLocation.append("Tennessee")
        listLocation.append("Missouri")
        listLocation.append("Connecticut")
        listLocation.append("Louisiana")
        listLocation.append("Alabama")
        listLocation.append("Oregon")
        listLocation.append("Nam Carolina")
        listLocation.append("Kentucky")
        listLocation.append("Oklahoma")
        listLocation.append("Iowa")
        listLocation.append("Kansas")
        listLocation.append("Nevada")
        listLocation.append("Utah")
        listLocation.append("Arkansas")
        listLocation.append("Washington, D.C.")
        listLocation.append("Mississippi")
        listLocation.append("Nebraska")
        listLocation.append("New Mexico")
        listLocation.append("Hawaii")
        listLocation.append("Tây Virginia")
        listLocation.append("Delaware")
        listLocation.append("New Hampshire")
        listLocation.append("Idaho")
        listLocation.append("Maine")
        listLocation.append("Rhode Island")
        listLocation.append("Alaska")
        listLocation.append("Nam Dakota")
        listLocation.append("Wyoming")
        listLocation.append("Montana")
        listLocation.append("Bắc Dakota")
        listLocation.append("Vermont")
    }
    
    func initTableView() {
        tblLocation.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        tblLocation.dataSource = self
        tblLocation.delegate = self
        tblLocation.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblLocation.bounds.width, height: 0))
    }
    
    func customizeLayout() {
        viewLineHeader.layer.cornerRadius = viewLineHeader.bounds.height / 2
    }
}

extension CardViewBottomController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCell(location: listLocation[indexPath.row])
    }
}
