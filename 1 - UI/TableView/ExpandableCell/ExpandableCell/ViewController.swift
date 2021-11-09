//
//  ViewController.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

struct Section {
    let title: String
    let options: [String]
    var isOpen = false
}

class ViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    private var listSession: [Section] = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        initTableView()
    }
    
    func initData() {
        listSession = [Section(title: "Session 1", options: [1,2,3].compactMap({return "Cell \($0)"})),
                       Section(title: "Session 2", options: [1,2,3,4].compactMap({return "Cell \($0)"})),
                       Section(title: "Session 3", options: [1,2,3,4,5].compactMap({return "Cell \($0)"})),
                       Section(title: "Session 4", options: [1,2,3,4,5,6].compactMap({return "Cell \($0)"})),
                       Section(title: "Session 5", options: [1,2,3,4,5,6,7].compactMap({return "Cell \($0)"})),
                       Section(title: "Session 6", options: [1,2,3,4,5,6,7,8].compactMap({return "Cell \($0)"}))]
    }
    
    func initTableView() {
        tblTest.separatorInset.left = 0
        tblTest.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        tblTest.register(UINib(nibName: "DataCell", bundle: nil), forCellReuseIdentifier: "DataCell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSession.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = listSession[section]
        if section.isOpen {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // row = 0 la section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as? SectionCell else {return UITableViewCell()}
            cell.lblSection.text = listSession[indexPath.section].title
            cell.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return cell
        } else { // row >= 1 la data
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataCell else {return UITableViewCell()}
            cell.lblData.text = listSession[indexPath.section].options[indexPath.row - 1]
            cell.backgroundColor = .random()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            listSession[indexPath.section].isOpen = !listSession[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("tap sub cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 100
        }
    }
}

