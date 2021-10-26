//
//  ViewController.swift
//  Animated Cell
//
//  Created by Hoang Tung Lam on 1/26/21.
//

import UIKit

enum AnimeteType {
    case animate1
    case animate2
    case animate3
    case animate4
    case animate5
    case animate6
    case animate7
    case animate8
    case animate9
    case animate10
}

class ViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    
    let tipInCellAnimatorStartTransform: CATransform3D = {
        let rotationDegress: CGFloat = -15.0
        let rotationRadians: CGFloat = rotationDegress * (CGFloat(Double.pi) / 1)
        let offSet = CGPoint(x: -20, y: -20)
        var startTransform = CATransform3DIdentity
        startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0, 0, 1)
        startTransform = CATransform3DTranslate(startTransform, offSet.x, offSet.y, 0)
        return startTransform
    }()
    
    let listAmimate: [AnimeteType] = [.animate1, .animate2, .animate3, .animate4, .animate5, .animate6, .animate7, .animate8, .animate9, .animate10]
    var animate: AnimeteType = .animate1
    var reload = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
        navigationItem.title = "\(reload + 1)"
    }

    func initTableView() {
        tblTest.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
    }
    
    @IBAction func btnRefreshTapped(_ sender: Any) {
        reload += 1
        if reload > self.listAmimate.count - 1 {
            reload = 0
        }
        navigationItem.title = "\(reload + 1)"
        self.animate = listAmimate[reload]
        tblTest.reloadData()
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        tblTest.reloadData()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as? TestCell else {
            return UITableViewCell()
        }
        cell.lblTitle.text = "Row _ \(indexPath.row + 1)"
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch self.animate {
        case .animate1:
            cell.alpha = 0
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.alpha = 1
            }
        case .animate2:
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        case .animate3:
            cell.transform = CGAffineTransform(scaleX: 0, y: 1)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        case .animate4:
            cell.transform = CGAffineTransform(scaleX: 1, y: 0)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        case .animate5:
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            }
        case .animate6:
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row), options: [.curveEaseInOut]) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        case .animate7:
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            }
        case .animate8:
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row), options: [.curveEaseInOut]) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        case .animate9:
            // usingSpringWithDamping: Độ nảy của animation. Có giá trị bằng 1 để không có độ nảy và giá trị gần đến 0 để tăng độ dao động.
            // initialSpringVelocity: Giá trị khoảng cách di truyển của animation trong 1 giây, có giá trị tối đa bằng 1.
            // options - Các tùy chọn cho animation. Ta sử dụng .curveEaseInOut để animation khởi đầu chậm, tăng tốc khi đến giai đoạn giữa rồi lại chậm lại cho đến khi kết thúc.
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseIn]) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        case .animate10:
            let view = cell.contentView
            view.layer.transform = tipInCellAnimatorStartTransform
            view.layer.opacity = 0
            view.alpha = 0
            UIView.animate(withDuration: 1, delay: 0.5 * Double(indexPath.row)) {
                view.layer.transform = CATransform3DIdentity
                view.layer.opacity = 1
                view.alpha = 1
            }
        }
    }
}

