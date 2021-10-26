//
//  CardViewTopViewController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 3/1/21.
//

import UIKit

class CardViewTopController: UIViewController {
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
        listLocation.append("An Giang")
        listLocation.append("Bà Rịa - Vũng Tàu")
        listLocation.append("Bạc Liêu")
        listLocation.append("Bắc Giang")
        listLocation.append("Bắc Kạn")
        listLocation.append("Bắc Ninh")
        listLocation.append("Bến Tre")
        listLocation.append("Bình Dương")
        listLocation.append("Bình Định")
        listLocation.append("Bình Phước")
        listLocation.append("Bình Thuận")
        listLocation.append("Cà Mau")
        listLocation.append("Cao Bằng")
        listLocation.append("Cần Thơ")
        listLocation.append("Đà Nẵng")
        listLocation.append("Đắk Lắk")
        listLocation.append("Đắk Nông")
        listLocation.append("Điện Biên")
        listLocation.append("Đồng Nai")
        listLocation.append("Đồng Tháp")
        listLocation.append("Gia Lai")
        listLocation.append("Hà Giang")
        listLocation.append("Hà Nam")
        listLocation.append("Hà Nội")
        listLocation.append("Hà Tĩnh")
        listLocation.append("Hải Dương")
        listLocation.append("Hải Phòng")
        listLocation.append("Hậu Giang")
        listLocation.append("Hòa Bình")
        listLocation.append("Thành phố Hồ Chí Minh")
        listLocation.append("Hưng Yên")
        listLocation.append("Khánh Hòa")
        listLocation.append("Kiên Giang")
        listLocation.append("Kon Tum")
        listLocation.append("Lai Châu")
        listLocation.append("Lạng Sơn")
        listLocation.append("Lào Cai")
        listLocation.append("Lâm Đồng")
        listLocation.append("Long An")
        listLocation.append("Nam Định")
        listLocation.append("Nghệ An")
        listLocation.append("Ninh Bình")
        listLocation.append("Ninh Thuận")
        listLocation.append("Phú Thọ")
        listLocation.append("Phú Yên")
        listLocation.append("Quảng Bình")
        listLocation.append("Quảng Nam")
        listLocation.append("Quảng Ngãi")
        listLocation.append("Quảng Ninh")
        listLocation.append("Quảng Trị")
        listLocation.append("Sóc Trăng")
        listLocation.append("Sơn La")
        listLocation.append("Tây Ninh")
        listLocation.append("Thái Bình")
        listLocation.append("Thái Nguyên")
        listLocation.append("Thanh Hóa")
        listLocation.append("Thừa Thiên Huế")
        listLocation.append("Tiền Giang")
        listLocation.append("Trà Vinh")
        listLocation.append("Tuyên Quang")
        listLocation.append("Vĩnh Long")
        listLocation.append("Vĩnh Phúc")
        listLocation.append("Yên Bái")
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

extension CardViewTopController: UITableViewDataSource, UITableViewDelegate {
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
