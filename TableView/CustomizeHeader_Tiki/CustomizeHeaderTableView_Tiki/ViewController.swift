//
//  ViewController.swift
//  CustomizeHeaderTableView_Tiki
//
//  Created by Hoang Tung Lam on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblTest: UITableView!
    @IBOutlet weak var headerHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var trainingTextField: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgChat: UIImageView!
    
    let maxHeaderHeight: CGFloat = 90.0
    let minHeaderHeight: CGFloat = 45.0
    
    //previousScrollOffset:  nhỏ hơn 0 thì có nghĩa là scroll view đang scroll lên, còn nếu nhỏ hơn 0 thì đang scroll xuống.
    private var previousScrollOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    // set tối đa chiều cao của header mỗi khi màn hình đc gọi đến
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightContraint.constant = maxHeaderHeight
    }
    
    func initTableView() {
        tblTest.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        tblTest.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblTest.frame.width, height: 0))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        // Điểm giới hạn trên cùng của scroll view
        let absoluteTop: CGFloat = 0.0
        // Điểm giới hạn dưới cùng của scroll view
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        // Implement logic để animate header
        previousScrollOffset = scrollView.contentOffset.y
        
        var newHeight = headerHeightContraint.constant
        if isScrollingDown {
            newHeight = max(minHeaderHeight, headerHeightContraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(maxHeaderHeight, headerHeightContraint.constant + abs(scrollDiff))
        }
        
        if newHeight != headerHeightContraint.constant {
            headerHeightContraint.constant = newHeight
            updateHeader()
            setScrollPosition(previousScrollOffset)
        }
        
        // Trong một số trường hợp, khi mà table view chỉ có một vài cell và content size của scroll view nhỏ hơn height của screen, chúng ta sẽ không cần collapse header. Vì trong trường hợp này, tính cả header và content của table view, vẫn còn đủ không gian trong màn hình. Vì vậy, để ngăn header collapse trong trường hợp ngoại lệ này, chúng ta cần check xem có còn không gian để scroll không ngay cả khi header bị collapse lại.
        guard canAnimateHeader(scrollView) else {
            return
        }
        
        if newHeight != self.headerHeightContraint.constant {
            headerHeightContraint.constant = newHeight
            setScrollPosition(previousScrollOffset)
        }
    }
    
    // scrollViewDidEndDecelerating() cho chúng ta biết khi nào thì scroll view dừng scroll sau quá trình "di chuyển" và "giảm tốc".
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Kết thúc scroll
        scrollViewDidStopScrolling()
    }
    
    // scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) thì cho biết khi nào scroll view dừng scroll sau khi user nhấc ngón tay lên.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // Kết thúc scroll
            if !decelerate {
                scrollViewDidStopScrolling()
            }
        }
    }
    
    private func setScrollPosition(_ position: CGFloat) {
        tblTest.contentOffset = CGPoint(x: tblTest.contentOffset.x, y: position)
    }
    
    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate height của scroll view khi header view bị collapse đến min height
        let scrollViewMaxHeight = scrollView.frame.height + headerHeightContraint.constant - minHeaderHeight
        // Đảm bảo khi header bị collapse đến min height thì scroll view vẫn scroll được
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func scrollViewDidStopScrolling() {
        let range = maxHeaderHeight - minHeaderHeight
        let midPoint = minHeaderHeight + range / 2
        
        if headerHeightContraint.constant > midPoint {
            // Expand header
            expandHeader()
        } else {
            // Collapse header
            collapseHeader()
        }
    }
    
    private func collapseHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightContraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightContraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    private func updateHeader() {
        // Tính khoảng cách giữa 2 value max và min height
        let range = maxHeaderHeight - minHeaderHeight
        // Tính khoảng offset hiện tại với min height
        let openAmount = headerHeightContraint.constant - minHeaderHeight
        // Tính tỉ lệ phần trăm để animate, thay đổi UI element
        let percentage = openAmount / range
        // Tính constant của trailing constraint cần thay đổi
        let trailingRange = view.frame.width - imgChat.frame.minX
        
        // Animate UI theo tỉ lệ tính được
        trainingTextField.constant = trailingRange * (1.0 - percentage) + 10
        imgLogo.alpha = percentage
    }
}
