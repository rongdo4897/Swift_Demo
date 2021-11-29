//
//  TestViewController.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import UIKit

//MARK: - Outlet, Override
class TestViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    var viewScreen: UIView!
    var viewFake: UIView!
    var viewPan: PanDynamicView!
    var viewDelete: UIView!
    var imageViewDelete: UIImageView!
    
    var indexPath: IndexPath!
    
    var datas: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    // Kiểm tra xem view delete lên đặt ở vị trí nào (top, bottom)
    var checkViewDeleteToBottomScreen = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension TestViewController {
    private func initComponents() {
        initTableView()
    }
    
    private func initTableView() {
        TestCell.registerCellByNib(tblTest)
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.separatorStyle = .none
        tblTest.showsVerticalScrollIndicator = true
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.width, height: 0))
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1
        self.tblTest.addGestureRecognizer(longPressGesture)
    }
    
    private func initFakeView(rect: CGRect, image: UIImage) {
        // View Screen
        initViewScreen()
        // View Delete
        initViewDelete(rect: rect)
        // View Span
        initSpanView(rect: rect, image: image)
    }
    
    private func initViewScreen() {
        viewScreen = UIView(frame: view.bounds)
        viewScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewScreen)))
        viewScreen.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(viewScreen)
    }
    
    private func initViewDelete(rect: CGRect) {
        // view
        viewDelete = UIView()
        viewScreen.addSubview(viewDelete)
        
        viewDelete.translatesAutoresizingMaskIntoConstraints = false
        if (rect.origin.y + rect.height) > (UIScreen.main.bounds.height / 2) {
            checkViewDeleteToBottomScreen = false
            
            NSLayoutConstraint.activate([
                viewDelete.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
                viewDelete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                viewDelete.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                viewDelete.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            checkViewDeleteToBottomScreen = true
            
            NSLayoutConstraint.activate([
                viewDelete.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
                viewDelete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                viewDelete.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                viewDelete.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        // imageview
        imageViewDelete = UIImageView()
        imageViewDelete.contentMode = .scaleAspectFit
        imageViewDelete.image = UIImage(systemName: "trash.fill")
        viewDelete.addSubview(imageViewDelete)
        
        imageViewDelete.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewDelete.widthAnchor.constraint(equalToConstant: 40),
            imageViewDelete.heightAnchor.constraint(equalToConstant: 40),
            imageViewDelete.centerXAnchor.constraint(equalTo: viewDelete.centerXAnchor),
            imageViewDelete.centerYAnchor.constraint(equalTo: viewDelete.centerYAnchor)
        ])
        
        // set color
        setColorViewDelete(isDelete: false)
    }
    
    private func initSpanView(rect: CGRect, image: UIImage) {
        viewFake = UIView(frame: rect)
        viewScreen.addSubview(viewFake)

        viewPan = PanDynamicView()
        viewFake.addSubview(viewPan)
        viewPan.translatesAutoresizingMaskIntoConstraints = false
        viewPan.addShadow()
        viewPan.layer.cornerRadius = 5
        viewPan.signleDragable(view: viewScreen)
        viewPan.delegate = self

        NSLayoutConstraint.activate([
            viewPan.topAnchor.constraint(equalTo: viewFake.topAnchor, constant: 10),
            viewPan.bottomAnchor.constraint(equalTo: viewFake.bottomAnchor, constant: -10),
            viewPan.leftAnchor.constraint(equalTo: viewFake.leftAnchor, constant: 10),
            viewPan.trailingAnchor.constraint(equalTo: viewFake.trailingAnchor, constant: -10),
        ])

        let imageView = UIImageView()
        viewPan.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: viewPan.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: viewPan.bottomAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: viewPan.leftAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: viewPan.trailingAnchor, constant: 0),
        ])
    }
    
    private func setColorViewDelete(isDelete: Bool) {
        imageViewDelete.image = imageViewDelete.image?.withRenderingMode(.alwaysTemplate)
        if isDelete {
            viewDelete.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            imageViewDelete.tintColor = .red
        } else {
            viewDelete.backgroundColor = .clear
            imageViewDelete.tintColor = .white
        }
    }
}

//MARK: - Customize
extension TestViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension TestViewController {
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {

            let touchPoint = longPressGestureRecognizer.location(in: self.tblTest)
            if let indexPath = tblTest.indexPathForRow(at: touchPoint) {
                guard let cell = tblTest.cellForRow(at: indexPath) as? TestCell else {return}
                self.indexPath = indexPath
                tblTest.scrollToRow(at: indexPath, at: .none, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    cell.contentView.isHidden = true
                    self.tblTest.isUserInteractionEnabled = false
                    
                    let rect = self.tblTest.rectForRow(at: indexPath)
                    let rectInScreen = self.tblTest.convert(rect, to: self.view)
                    let image = cell.viewPan.takeScreenshot()
                    
                    self.initFakeView(rect: rectInScreen, image: image)
                }
            }
        }
    }
    
    @objc private func tapViewScreen() {
        viewScreen.removeFromSuperview()
        guard let cell = tblTest.cellForRow(at: self.indexPath) as? TestCell else {return}
        cell.contentView.isHidden = false
        tblTest.isUserInteractionEnabled = true
    }
}

//MARK: - Các hàm chức năng
extension TestViewController {
    func confirmRemoveRow() {
        AlertUtil.showAlertConfirm(from: self, with: "Bạn có muốn xóa hàng này không", message: "") { _ in
            DispatchQueue.main.async {
                guard let cell = self.tblTest.cellForRow(at: self.indexPath) as? TestCell else {return}
                cell.contentView.isHidden = false
                self.datas.remove(at: self.indexPath.row)
                self.tblTest.beginUpdates()
                self.tblTest.deleteRows(at: [self.indexPath], with: .fade)
                self.tblTest.endUpdates()
                self.viewScreen.removeFromSuperview()
                self.tblTest.isUserInteractionEnabled = true
            }
        }
    }
}

//MARK: - TableView
extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TestCell.loadCell(tableView) as? TestCell else {return UITableViewCell()}
        cell.setupData(text: "Đây là cell thứ \(datas[indexPath.row])")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

//MARK: - PanDynamicViewDelegate
extension TestViewController: PanDynamicViewDelegate {
    func getLocation(location: CGPoint) {
        if checkViewDeleteToBottomScreen {
            if location.y >= viewDelete.origin.y {
                setColorViewDelete(isDelete: true)
                confirmRemoveRow()
            } else {
                setColorViewDelete(isDelete: false)
            }
        } else {
            if location.y <= (viewDelete.origin.y + viewDelete.height) {
                setColorViewDelete(isDelete: true)
                confirmRemoveRow()
            } else {
                setColorViewDelete(isDelete: false)
            }
        }
    }
}
