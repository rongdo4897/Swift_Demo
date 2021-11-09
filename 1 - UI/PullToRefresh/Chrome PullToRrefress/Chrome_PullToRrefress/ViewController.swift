//
//  ViewController.swift
//  Chrome_PullToRrefress
//
//  Created by Hoang Tung Lam on 4/12/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    @IBOutlet weak var topView: UIView!
    
    fileprivate var pullToRefresh: ADChromePullToRefresh!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponents()
        tblTest.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
//        navigationController?.navigationBar.isHidden = true
        self.addPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
        self.pullToRefresh.setUpConstraints()
    }
    
    func triggerPullToRefresh() -> Void {
        print("center action handled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.pullToRefresh.completePullToRefresh()
        }
    }
    
    func triggerLeftAction() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("left action handled")
        }
    }
    
    func triggerRightAction() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("right action handled")
        }
    }
    
    func addPullToRefresh() {
        self.pullToRefresh = ADChromePullToRefresh(view: self.topView, forScrollView: self.tblTest, scrollViewOriginalOffsetY: 0, delegate: self)
    }
    
    func initComponents() {
        initTableView()
    }
    
    func initTableView() {
        tblTest.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.separatorStyle = .none
    }

}

//MARK: - Table view
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "row_\(indexPath.row + 1)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y < 0 && y > -100 {
            navigationController?.navigationBar.layer.opacity = Float(1 - ( -y / 100))
        }
    }
}

//MARK: - Pull to refresh delegate
extension ViewController: ADChromePullToRefreshDelegate {
    func chromePullToRefresh(_ pullToRefresh: ADChromePullToRefresh, viewWithType: ADChromePullToRefreshActionViewType) -> ADChromePullToRefreshActionView {
        switch viewWithType {
        case .center:
            return ADChromePullToRefreshCenterActionView.centerActionView()
        case .left:
            return ADChromePullToRefreshLeftActionView.leftActionView()
        case .right:
            return ADChromePullToRefreshRightActionView.rightActionView()
        }
    }
    
    func chromePullToRefresh(_ pullToRefresh: ADChromePullToRefresh, actionForViewWithType: ADChromePullToRefreshActionViewType) -> ADChromePullToRefreshAction? {
        
        let centerAction: ADChromePullToRefreshAction = {() -> Void in
            self.triggerPullToRefresh()
        }
        
        let leftAction: ADChromePullToRefreshAction = { () -> Void in
            self.triggerLeftAction()
        }
        
        let rightAction: ADChromePullToRefreshAction = { () -> Void in
            self.triggerRightAction()
        }
        
        switch actionForViewWithType {
        case .center:
            return centerAction
        case .left:
            return leftAction
        case .right:
            return rightAction
        }
    }
}
