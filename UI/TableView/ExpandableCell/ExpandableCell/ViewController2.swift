//
//  ViewController2.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import UIKit

class ViewController2: UIViewController {
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
        tblTest.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        tblTest.register(UINib(nibName: "DataCell", bundle: nil), forCellReuseIdentifier: "DataCell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
    }
}

extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSession.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = listSession[section]
        if section.isOpen {
            return section.options.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataCell else {return UITableViewCell()}
        cell.lblData.text = listSession[indexPath.section].options[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell else {return UITableViewCell()}
        cell.lblSection.text = listSession[section].title
        cell.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.section = section
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension ViewController2: HeaderCellDelegate {
    func toggleSection(_ header: HeaderCell, section: Int) {
        listSession[section].isOpen = !listSession[section].isOpen
        tblTest.reloadSections([section], with: .none)
        tblTest.reloadData()
    }
}
