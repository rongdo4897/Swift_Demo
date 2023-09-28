//
//  CardViewLeftController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 3/1/21.
//

import UIKit

class CardViewLeftController: UIViewController {
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
        listLocation.append("Moskva")
        listLocation.append("Belgorod")
        listLocation.append("Bryansk")
        listLocation.append("Ivanovo")
        listLocation.append("Kaluga")
        listLocation.append("Kostroma")
        listLocation.append("Kursk")
        listLocation.append("Lipetsk")
        listLocation.append("Moskva")
        listLocation.append("Oryol")
        listLocation.append("Ryazan")
        listLocation.append("Smolensk")
        listLocation.append("Tambov")
        listLocation.append("Tver")
        listLocation.append("Tula")
        listLocation.append("Vladimir")
        listLocation.append("Voronezh")
        listLocation.append("Yaroslavl")
        listLocation.append("Astrakhan")
        listLocation.append("Rostov")
        listLocation.append("Volgograd")
        listLocation.append("Krasnodar")
        listLocation.append("Adygea")
        listLocation.append("Kalmykia")
        listLocation.append("Dagestan")
        listLocation.append("Ingushetia")
        listLocation.append("Kabardino-Balkaria")
        listLocation.append("Karachay-Cherkessia")
        listLocation.append("Bắc Ossetia-Alania")
        listLocation.append("Stavropol")
        listLocation.append("Chechnya")
        listLocation.append("Sankt-Peterburg")
        listLocation.append("Arkhangelsk")
        listLocation.append("Nenetsia")
        listLocation.append("Kaliningrad")
        listLocation.append("Leningrad")
        listLocation.append("Murmansk")
        listLocation.append("Novgorod")
        listLocation.append("Pskov")
        listLocation.append("Vologda")
        listLocation.append("Cộng hòa Karelia")
        listLocation.append("Cộng hòa Komi")
        listLocation.append("Amur")
        listLocation.append("Magadan")
        listLocation.append("Sakhalin")
        listLocation.append("Tỉnh tự trị Do Thái")
        listLocation.append("Kamchatka")
        listLocation.append("Khabarovsk")
        listLocation.append("Primorsky")
        listLocation.append("Cộng hòa Sakha")
        listLocation.append("Chukotka")
        listLocation.append("Irkutsk")
        listLocation.append("Kemerovo")
        listLocation.append("Novosibirsk")
        listLocation.append("Omsk")
        listLocation.append("Tomsk")
        listLocation.append("Altai")
        listLocation.append("Krasnoyarsk")
        listLocation.append("Zabaykalsky")
        listLocation.append("Altai")
        listLocation.append("Buryatia")
        listLocation.append("Khakassia")
        listLocation.append("Tuva")
        listLocation.append("Chelyabinsk")
        listLocation.append("Kurgan")
        listLocation.append("Sverdlovsk")
        listLocation.append("Tyumen")
        listLocation.append("Khantia-Mansia")
        listLocation.append("Yamalo-Nenets")
        listLocation.append("Kirov")
        listLocation.append("Nizhny Novgorod")
        listLocation.append("Orenburg")
        listLocation.append("Penza")
        listLocation.append("Samara")
        listLocation.append("Saratov")
        listLocation.append("Ulyanovsk")
        listLocation.append("Perm")
        listLocation.append("Nước cộng hòa Bashkortostan")
        listLocation.append("Nước cộng hòa Chuvashia")
        listLocation.append("Nước cộng hòa Mari El")
        listLocation.append("Nước cộng hòa Mordovia")
        listLocation.append("Nước cộng hòa Tatarstan")
        listLocation.append("Nước cộng hòa Udmurtia")
        listLocation.append("Sevastopol")
        listLocation.append("Nước cộng hòa Krym")
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

extension CardViewLeftController: UITableViewDataSource, UITableViewDelegate {
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
