//
//  ViewController.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var tblMessage: UITableView!
    
    let listChat = [
        [
            ChatMessage(text: "Ϲhỉ là nỗi nhớ mãi đứng sau cuộc tình đã lỡ, Ϲhỉ là cơn mơ cuốn theo cả một trời thương nhớ", image: nil, isIncoming: true, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: nil, image: "https://previews.123rf.com/images/novazaigen/novazaigen1705/novazaigen170500006/77529164-chinese-dragon-tattoo-design.jpg", isIncoming: false, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: "Ϲhỉ là nỗi đau thổn thức, chỉ là nhói thêm một chút, Ϲhỉ là nước mắt cứ rưng rưng", isIncoming: false, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: nil, image: "https://www.discoverdogs.org.uk/wp-content/uploads/2019/11/dog-hero.jpg", isIncoming: true, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: nil, image: nil, video: nil, link: "https://www.youtube.com/watch?v=OLI_-W7Qoq4", isIncoming: true, date: Date.dateFormCustomString(customString: "01/23/2021"))
        ],
        [
            ChatMessage(text: "Tìm về kí ức cố xoá đi đoạn tình ban sơ, Rồi lại chơ vơ đứng giữa nơi đại lộ tan vỡ, Mãi chìm đắm trong lầm lỡ", isIncoming: false, date: Date.dateFormCustomString(customString: "01/25/2021")),
            ChatMessage(text: "Ϲhỉ là nỗi nhớ mãi đứng sau cuộc tình đã lỡ, Ϲhỉ là cơn mơ cuốn theo cả một trời thương nhớ", image: "https://i.guim.co.uk/img/media/20098ae982d6b3ba4d70ede3ef9b8f79ab1205ce/0_0_969_581/master/969.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=a368f449b1cc1f37412c07a1bd901fb5", isIncoming: false, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: nil, image: nil, video: nil, link: "https://ncov.moh.gov.vn/", isIncoming: true, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: nil, image: nil, video: nil, link: "https://vietgiaitri.com/pubg-mobile-cap-nhat-set-do-doi-nhan-dip-valentine-nam-nay-20190214i3773323/", isIncoming: false, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: "Trái tim vẫn không ngừng nhớ, Đợi chờ em đến hoá ngu ngơ", isIncoming: false, date: Date.dateFormCustomString(customString: "01/25/2021")),
            ChatMessage(text: "Tình уêu đã phai mờ như hoa nở không màu", isIncoming: true, date: Date.dateFormCustomString(customString: "01/25/2021"))
        ],
        [
            ChatMessage(text: "Ϲàng níu kéo nhưng lại càng xa cách nhau", isIncoming: false, date: Date.dateFormCustomString(customString: "01/27/2021")),
            ChatMessage(text: "Đành ôm nỗi đau nàу chết lặng giữa trời mâу, Hằn lại sâu trong trái tim hao gầу", isIncoming: true, date: Date.dateFormCustomString(customString: "01/27/2021")),
            ChatMessage(text: nil, image: nil, video: nil, link: "https://www.youtube.com/watch?v=2VhZSbRAL_8", isIncoming: false, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: "Ϲhỉ là nỗi nhớ mãi đứng sau cuộc tình đã lỡ, Ϲhỉ là cơn mơ cuốn theo cả một trời thương nhớ", image: "https://previews.123rf.com/images/novazaigen/novazaigen1705/novazaigen170500006/77529164-chinese-dragon-tattoo-design.jpg", isIncoming: true, date: Date.dateFormCustomString(customString: "01/23/2021")),
            ChatMessage(text: "Giờ đâу chúng ta là hai người dưng khác lạ", isIncoming: true, date: Date.dateFormCustomString(customString: "01/27/2021")),
            ChatMessage(text: "Buồn biết mấу nhưng lại chẳng thể nói ra, Ϲuộc đời lắm vô thường, sao cứ mãi vấn vương, Tự mình ôm lấу tổn thương riêng mình!", isIncoming: false, date: Date.dateFormCustomString(customString: "01/27/2021")),
            ChatMessage(text: "Chỉ là anh cố chấp luôn âm thầm, Bước về phía nắng ấm tìm em, Thế mà cơn mưa đêm xoá hết kỷ niệm, Chỉ còn lại xác xơ nỗi nhớ !", isIncoming: true, date: Date.dateFormCustomString(customString: "01/27/2021"))
        ],
        [
            ChatMessage(text: nil, image: nil, video: "https://storage.googleapis.com/coverr-main/mp4/Mt_Baker.mp4", link: nil, isIncoming: true, date: Date.dateFormCustomString(customString: "02/02/2021")),
            ChatMessage(text: nil, image: nil, video: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", link: nil, isIncoming: false, date: Date.dateFormCustomString(customString: "02/02/2021")),
            ChatMessage(text: nil, image: nil, video: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", link: nil, isIncoming: false, date: Date.dateFormCustomString(customString: "02/02/2021")),
            ChatMessage(text: nil, image: nil, video: nil, audio: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", link: nil, isIncoming: false, date: Date.dateFormCustomString(customString: "02/02/2021")),
            ChatMessage(text: nil, image: nil, video: nil, audio: "https://www.kozco.com/tech/piano2-CoolEdit.mp3", link: nil, isIncoming: true, date: Date.dateFormCustomString(customString: "02/02/2021"))
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponent()
    }
    
    func initComponent() {
        initNavigation()
        initTableView()
    }
    
    func initNavigation() {
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func initTableView() {
        tblMessage.separatorStyle = .none
        tblMessage.register(UINib(nibName: "SectionHeaderCell", bundle: nil), forCellReuseIdentifier: "SectionHeaderCell")
        tblMessage.register(UINib(nibName: "ChatMessageYourCell", bundle: nil), forCellReuseIdentifier: "ChatMessageYourCell")
        tblMessage.register(UINib(nibName: "ChatMessageMeCell", bundle: nil), forCellReuseIdentifier: "ChatMessageMeCell")
        tblMessage.register(UINib(nibName: "ChatImageYourCell", bundle: nil), forCellReuseIdentifier: "ChatImageYourCell")
        tblMessage.register(UINib(nibName: "ChatImageMeCell", bundle: nil), forCellReuseIdentifier: "ChatImageMeCell")
        tblMessage.register(UINib(nibName: "ChatMessageImageYourCell", bundle: nil), forCellReuseIdentifier: "ChatMessageImageYourCell")
        tblMessage.register(UINib(nibName: "ChatMessageImageMeCell", bundle: nil), forCellReuseIdentifier: "ChatMessageImageMeCell")
        tblMessage.register(UINib(nibName: "ChatLinkYourCell", bundle: nil), forCellReuseIdentifier: "ChatLinkYourCell")
        tblMessage.register(UINib(nibName: "ChatLinkMeCell", bundle: nil), forCellReuseIdentifier: "ChatLinkMeCell")
        tblMessage.register(UINib(nibName: "ChatVideoYourCell", bundle: nil), forCellReuseIdentifier: "ChatVideoYourCell")
        tblMessage.register(UINib(nibName: "ChatVideoMeCell", bundle: nil), forCellReuseIdentifier: "ChatVideoMeCell")
        tblMessage.register(UINib(nibName: "ChatAudioYourCell", bundle: nil), forCellReuseIdentifier: "ChatAudioYourCell")
        tblMessage.register(UINib(nibName: "ChatAudioMeCell", bundle: nil), forCellReuseIdentifier: "ChatAudioMeCell")
        tblMessage.dataSource = self
        tblMessage.delegate = self
        tblMessage.backgroundColor = .white
    }
    
    func presentImageController(imageUrl: String?) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.imageUrl = imageUrl
        present(vc, animated: true, completion: nil)
    }
    
    func presentWebController(link: String) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.link = link
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChat[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listChat[indexPath.section][indexPath.row].isIncoming { // Nếu = true -> Bạn
            if listChat[indexPath.section][indexPath.row].text != nil && listChat[indexPath.section][indexPath.row].image == nil {
                // Trường hợp tin nhắn chỉ có text
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageYourCell", for: indexPath) as? ChatMessageYourCell else {return UITableViewCell()}
                cell.setUpData(chatMessage: listChat[indexPath.section][indexPath.row])
                return cell
            } else if listChat[indexPath.section][indexPath.row].text == nil && listChat[indexPath.section][indexPath.row].image != nil {
                // trường hợp tin nhăn chỉ có hình ảnh
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageYourCell", for: indexPath) as? ChatImageYourCell else {return UITableViewCell()}
                cell.setUpData(imgString: listChat[indexPath.section][indexPath.row].image ?? "")
                cell.delegate = self
                return cell
            } else if listChat[indexPath.section][indexPath.row].text != nil && listChat[indexPath.section][indexPath.row].image != nil {
                // tin nhắn có cả text và hình ảnh
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageImageYourCell", for: indexPath) as? ChatMessageImageYourCell else {return UITableViewCell()}
                cell.setUpdata(model: listChat[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            } else {
                if listChat[indexPath.section][indexPath.row].link != nil {
                    // nếu chỉ chứa link
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLinkYourCell", for: indexPath) as? ChatLinkYourCell else {return UITableViewCell()}
                    cell.setUpData(link: listChat[indexPath.section][indexPath.row].link ?? "")
                    cell.delegate = self
                    return cell
                } else {
                    if listChat[indexPath.section][indexPath.row].video != nil {
                        // nếu chỉ có video
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoYourCell", for: indexPath) as? ChatVideoYourCell else {return UITableViewCell()}
                        cell.setUpData(video: listChat[indexPath.section][indexPath.row].video ?? "")
                        cell.delegate = self
                        return cell
                    } else {
                        // nếu chỉ có audio
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAudioYourCell", for: indexPath) as? ChatAudioYourCell else {return UITableViewCell()}
                        cell.setUpData(audio: listChat[indexPath.section][indexPath.row].audio ?? "")
                        return cell
                    }
                }
            }
        } else { // còn lại -> Tôi
            if listChat[indexPath.section][indexPath.row].text != nil && listChat[indexPath.section][indexPath.row].image == nil {
                // Trường hợp tin nhắn chỉ có text
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageMeCell", for: indexPath) as? ChatMessageMeCell else {return UITableViewCell()}
                cell.setUpData(chatMessage: listChat[indexPath.section][indexPath.row])
                return cell
            } else if listChat[indexPath.section][indexPath.row].text == nil && listChat[indexPath.section][indexPath.row].image != nil {
                // trường hợp tin nhăn chỉ có hình ảnh
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageMeCell", for: indexPath) as? ChatImageMeCell else {return UITableViewCell()}
                cell.setUpData(imgString: listChat[indexPath.section][indexPath.row].image ?? "")
                cell.delegate = self
                return cell
            } else if listChat[indexPath.section][indexPath.row].text != nil && listChat[indexPath.section][indexPath.row].image != nil {
                // tin nhắn có cả text và hình ảnh
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageImageMeCell", for: indexPath) as? ChatMessageImageMeCell else {return UITableViewCell()}
                cell.setUpdata(model: listChat[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            } else {
                if listChat[indexPath.section][indexPath.row].link != nil {
                    // nếu chỉ chứa link
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLinkMeCell", for: indexPath) as? ChatLinkMeCell else {return UITableViewCell()}
                    cell.setUpData(link: listChat[indexPath.section][indexPath.row].link ?? "")
                    cell.delegate = self
                    return cell
                } else {
                    if listChat[indexPath.section][indexPath.row].video != nil {
                        // nếu chỉ có video
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoMeCell", for: indexPath) as? ChatVideoMeCell else {return UITableViewCell()}
                        cell.setUpData(video: listChat[indexPath.section][indexPath.row].video ?? "")
                        cell.delegate = self
                        return cell
                    } else {
                        // nếu chỉ có audio
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAudioMeCell", for: indexPath) as? ChatAudioMeCell else {return UITableViewCell()}
                        cell.setUpData(audio: listChat[indexPath.section][indexPath.row].audio ?? "")
                        return cell
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listChat.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell") as? SectionHeaderCell else {
            return UITableViewCell()
        }
        if let firstMessageInSection = listChat[section].first {
            cell.setUpData(title: Date.stringFromCustomDate(date: firstMessageInSection.date))
        } else {
            cell.setUpData(title: Date.stringFromCustomDate(date: Date()))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension ViewController: ChatImageCellDelegate {
    func moveData(imageUrl: String?) {
        presentImageController(imageUrl: imageUrl)
    }
}

extension ViewController: ChatLinkDelegate {
    func moveData(link: String) {
        presentWebController(link: link)
    }
}

extension ViewController: ChatVideoDelegate {
    func moveData(video: String) {
        let videoURL = URL(string: video)!
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func receiveMessage(message: ChatMessage) {
//        listChat.append(message)
//        tblMessage.insertRows(at: [IndexPath()], with: .none)
    }
}
