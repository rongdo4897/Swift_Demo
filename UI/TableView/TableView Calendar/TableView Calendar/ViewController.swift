//
//  ViewController.swift
//  TableView Calendar
//
//  Created by Hoang Tung Lam on 1/25/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tblCalendar: UITableView!
    
    var shouldCollapse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }

    func initTableView() {
        tblCalendar.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
        tblCalendar.register(UINib(nibName: "ListRequestCell", bundle: nil), forCellReuseIdentifier: "ListRequestCell")
        tblCalendar.register(UINib(nibName: "HeaderListRequestCell", bundle: nil), forCellReuseIdentifier: "HeaderListRequestCell")
        tblCalendar.dataSource = self
        tblCalendar.delegate = self
        tblCalendar.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblCalendar.frame.width, height: 0))
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
                return UITableViewCell()
            }
            cell.setUpCell()
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListRequestCell", for: indexPath) as? ListRequestCell else {
                return UITableViewCell()
            }
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderListRequestCell") as? HeaderListRequestCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if !shouldCollapse {
                return 80
            } else {
                return 320
            }
        default:
            return 255
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
}

extension ViewController: CaledarCellDelegate {
    func clickFilter() {
        
    }
    
    func collapsedCalendar() {
        self.shouldCollapse = !self.shouldCollapse
        tblCalendar.reloadData()
    }
}
