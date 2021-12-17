//
//  SkeletonViewController.swift
//  Animated Cell
//
//  Created by Hoang Tung Lam on 1/26/21.
//

import UIKit
import SkeletonView

class SkeletonViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTest.estimatedRowHeight = 100
        initTableView()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblTest.isSkeletonable = true
        tblTest.showAnimatedSkeleton(usingColor: .link, animation: nil, transition: .crossDissolve(0.25))
    }
    
    func initTableView() {
        tblTest.register(UINib(nibName: "SkeletonCell", bundle: nil), forCellReuseIdentifier: "SkeletonCell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
    }
    
    func initData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for _ in 0..<30 {
                self.data.append("Some Text")
            }
            self.tblTest.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.tblTest.reloadData()
        }
    }
}

extension SkeletonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkeletonCell", for: indexPath) as? SkeletonCell else {
            return UITableViewCell()
        }
        if !data.isEmpty {
            cell.lbl1.text = data[indexPath.row]
            cell.lbl2.text = data[indexPath.row]
            cell.imgTest.image = UIImage(systemName: "star")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SkeletonViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeletonCell"
    }
}
