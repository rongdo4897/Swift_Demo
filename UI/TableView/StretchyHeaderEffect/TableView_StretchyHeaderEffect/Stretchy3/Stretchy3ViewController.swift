//
//  Stretchy3ViewController.swift
//  TableView_StretchyHeaderEffect
//
//  Created by Hoang Tung Lam on 12/2/20.
//

import UIKit

class Stretchy3ViewController: UIViewController {
    @IBOutlet weak var tblTest: UITableView!

    let defaultSizeRect = CGRect(x: 0,
                                 y: 0,
                                 width: UIScreen.main.bounds.width, height: 200)

    var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "headerImage")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    var titleLable: UILabel = {
        let title = UILabel()
        title.text = "Music"
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.sizeToFit()
        title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTableView()
        styleHeaderView()
    }
}

extension Stretchy3ViewController {
    func styleTableView() {
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func styleHeaderView() {
        // add image to header
        imageView.frame = defaultSizeRect
        self.tblTest.stretchyHeader.view = imageView
        self.tblTest.stretchyHeader.minimumHeight = 50

        // add title to header
        imageView.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}

extension Stretchy3ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Chờ yêu thương về ngang đời ta\nChờ nắng lên vội vàng \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
