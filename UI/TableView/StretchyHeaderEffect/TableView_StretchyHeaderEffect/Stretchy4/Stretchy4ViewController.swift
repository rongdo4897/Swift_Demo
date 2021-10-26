//
//  Stretchy4ViewController.swift
//  TableView_StretchyHeaderEffect
//
//  Created by Hoang Tung Lam on 12/3/20.
//

import UIKit

class Stretchy4ViewController: UIViewController {
    @IBOutlet weak var tblMusic: UITableView!

    let defaultHeaderSize = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 318)
    let headerCell = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTableView()
        styleHeaderView()
    }
}

extension Stretchy4ViewController {
    func styleTableView() {
        tblMusic.dataSource = self
        tblMusic.delegate = self
        tblMusic.register(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "MusicCell")
    }

    func styleHeaderView() {
        headerCell.frame = defaultHeaderSize
        self.tblMusic.stretchyHeader.view = headerCell
        self.tblMusic.stretchyHeader.minimumHeight = 60
        self.tblMusic.stretchyHeader.delegate = self
    }
}

extension Stretchy4ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? MusicCell else {
            return UITableViewCell()
        }
        cell.lblNumber.text = "\(indexPath.row + 1)"
        cell.lblName.text = "Lỗi tại ai _ \(indexPath)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension Stretchy4ViewController: MEStretchyHeaderDelegate {
    func willHeaderUpdateFrame(rec: CGRect) {

    }

    func didHeaderUpdateFrame(rec: CGRect) {
        let minH: CGFloat = 60.0
        let maxH: CGFloat = 400.0
        let newHeight = rec.height

//        let y = topViewSize - (scrollView.contentOffset.y + topViewSize)
        let newHeaderViewHeight = headerCell.frame.height - newHeight
//        print(y)
        if newHeight >= minH {
            if newHeight<=148 && newHeight >= minH {
                let percent: Float = (Float((148-newHeight) / newHeight))
                headerCell.albumTopButton.alpha = CGFloat(percent)
            } else {
                headerCell.albumTopButton.alpha = 0
            }
//
            headerCell.albumTopButton.frame.origin.y = newHeight
        } else {
            headerCell.albumTopButton.alpha = 1
            headerCell.albumTopButton.frame.origin.y = 100
        }

        let height = min(max(newHeight, minH), 800)
        headerCell.frame = CGRect(x: 0, y: minH, width: UIScreen.main.bounds.size.width, height: height)

        if newHeight >= 318 {
            headerCell.albumimage.transform = CGAffineTransform(scaleX: (newHeight/318), y: (newHeight/318))
            headerCell.albumTop.constant = 25
        } else {
            headerCell.albumTop.constant = (newHeight-(318-25))+((newHeight-318)*0.6)
        }

        if newHeight >= 318 {
            let final = ((450)-newHeight) / ((450) - 318)
            headerCell.albumButton.alpha = CGFloat(final)
        } else if newHeaderViewHeight > 318 {
            let alphavalue = (newHeaderViewHeight/318) - 1
            headerCell.albumButton.alpha = CGFloat(alphavalue)
        }
    }

    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: headerCell.btnAlbum.center.x - 2, y: headerCell.btnAlbum.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: headerCell.btnAlbum.center.x + 2, y: headerCell.btnAlbum.center.y))
        headerCell.btnAlbum.layer.add(animation, forKey: "position")

        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.duration = 0.1
        animation1.repeatCount = 1
        animation1.autoreverses = true
        animation1.fromValue = NSValue(cgPoint: CGPoint(x: headerCell.btnMusic.center.x - 2, y: headerCell.btnMusic.center.y))
        animation1.toValue = NSValue(cgPoint: CGPoint(x: headerCell.btnMusic.center.x + 2, y: headerCell.btnMusic.center.y))
        headerCell.btnMusic.layer.add(animation1, forKey: "position")
    }
}
