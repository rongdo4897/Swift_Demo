//
//  CardViewRightController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 3/1/21.
//

import UIKit

class CardViewRightController: UIViewController {
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
        listLocation.append("安徽省")
        listLocation.append("福建省")
        listLocation.append("甘肃省")
        listLocation.append("广东省")
        listLocation.append("贵州省")
        listLocation.append("海南省")
        listLocation.append("河北省")
        listLocation.append("黑龙江省")
        listLocation.append("河南省")
        listLocation.append("湖北省")
        listLocation.append("湖南省")
        listLocation.append("江苏省")
        listLocation.append("江西省")
        listLocation.append("吉林省")
        listLocation.append("辽宁省")
        listLocation.append("青海省")
        listLocation.append("山东省")
        listLocation.append("山西省")
        listLocation.append("陕西省")
        listLocation.append("四川省")
        listLocation.append("云南省")
        listLocation.append("浙江省")
        listLocation.append("台湾省")
        listLocation.append("北京市")
        listLocation.append("重庆市")
        listLocation.append("上海市")
        listLocation.append("天津市")
        listLocation.append("广西壮族自治区")
        listLocation.append("内蒙古自治区")
        listLocation.append("宁夏回族自治区")
        listLocation.append("西藏自治区")
        listLocation.append("新疆维吾尔族自治区")
        listLocation.append("澳门特别行政 区")
        listLocation.append("香港 特别行政 区")
    }
    
    func initTableView() {
        tblLocation.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        tblLocation.dataSource = self
        tblLocation.delegate = self
        tblLocation.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblLocation.bounds.width, height: 0))
    }
    
    func customizeLayout() {
        viewLineHeader.layer.cornerRadius = viewLineHeader.bounds.width / 2
    }
}

extension CardViewRightController: UITableViewDataSource, UITableViewDelegate {
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
