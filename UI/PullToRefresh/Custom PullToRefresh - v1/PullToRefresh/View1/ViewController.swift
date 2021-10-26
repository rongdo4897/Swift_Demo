//
//  ViewController.swift
//  PullToRefresh
//
//  Created by Hoang Tung Lam on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!
    
    var customView: UIView!
    private var refreshControl = UIRefreshControl()
    
    var labelArrays: [UILabel] = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
        loadCustomRefreshContent()
    }

    func initTableView() {
        tblTest.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        tblTest.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tblTest.separatorInset.left = 0
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
        if #available(iOS 10.0, *) {
            tblTest.refreshControl = refreshControl
        } else {
            tblTest.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
    }
    
    func loadCustomRefreshContent() {
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        
        // lấy class quản trị cho RefreshContents.xib
        let refreshContent = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        customView = refreshContent![0] as? UIView
        customView.frame = refreshControl.bounds // kích cỡ customView = refreshControl
        
        // lấy toàn bộ label trong view
        for i in 0..<customView.subviews.count {
            labelArrays.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        // add customview into refreshControl
        refreshControl.addSubview(customView)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        print("refresh")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as? TestCell else {
            return UITableViewCell()
        }
        cell.lblTitle.text = "Test _ \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing { // neu refresh = true
            if !isAnimating { // neu chua load
                self.doSomeThing()
                animateRefreshStep1()
            }
        }
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
            // Chỉ định biến đổi được áp dụng cho chế độ xem, liên quan đến tâm của các giới hạn của nó.
            self.labelArrays[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi / 4))
            self.labelArrays[self.currentLabelIndex].textColor = self.getNextColor()
        } completion: { (_) in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear) {
                self.labelArrays[self.currentLabelIndex].transform = CGAffineTransform.identity
                self.labelArrays[self.currentLabelIndex].textColor = .black
            } completion: { (_) in
                self.currentLabelIndex += 1
                
                if self.currentLabelIndex < self.labelArrays.count {
                    self.animateRefreshStep1()
                } else {
                    self.animateRefreshStep2()
                }
            }
        }
    }
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveLinear) {
            for index in 0..<self.labelArrays.count {
                self.labelArrays[index].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        } completion: { (_) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
                for index in 0..<self.labelArrays.count {
                    self.labelArrays[index].transform = CGAffineTransform.identity
                }
            } completion: { (_) in
                if self.refreshControl.isRefreshing {
                    self.currentLabelIndex = 0
                    self.animateRefreshStep1()
                } else {
                    self.isAnimating = false
                    self.currentLabelIndex = 0
                    for index in 0..<self.labelArrays.count {
                        self.labelArrays[index].textColor = .black
                        self.labelArrays[index].transform = CGAffineTransform.identity
                    }
                }
            }

        }

    }
    
    func getNextColor() -> UIColor {
        let colorsArray: Array<UIColor> = [UIColor.magenta, UIColor.brown, UIColor.yellow, UIColor.red, UIColor.green, UIColor.blue, UIColor.orange]
        
        if currentColorIndex == colorsArray.count - 1 {
            currentColorIndex = 0
        }
        
        currentColorIndex += 1
        
        return colorsArray[currentColorIndex]
    }
    
    func doSomeThing() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(endOfWork), userInfo: nil, repeats: true)
    }
    
    @objc func endOfWork() {
        refreshControl.endRefreshing()
        timer.invalidate()
        timer = nil
    }
}
