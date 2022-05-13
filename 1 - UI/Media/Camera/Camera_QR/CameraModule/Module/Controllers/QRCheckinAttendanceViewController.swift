//
//  QRViewController.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import UIKit

// MARK: - Outlet, Override
class QRViewController: UIViewController {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblCheckin: UILabel!

    var viewCamera: QRDetectCameraView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCameraView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewCamera.stopCapture()
    }
}

// MARK: - Các hàm khởi tạo
extension QRViewController {
    private func initComponents() {
        
    }

    private func initCameraView() {
        viewCamera = QRDetectCameraView(bufferQueue: DispatchQueue(label: "CameraQR"), onResults: { text, cameraError in
            guard cameraError == .none else {return}
            self.lblCheckin.text = text
        })

        viewMain.addSubview(viewCamera)
        viewCamera.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            viewCamera.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor, constant: 0),
            viewCamera.centerYAnchor.constraint(equalTo: viewMain.centerYAnchor, constant: 0),
            viewCamera.widthAnchor.constraint(equalTo: viewMain.widthAnchor, constant: 0),
            viewCamera.heightAnchor.constraint(equalTo: viewMain.heightAnchor, constant: 0)
        ])

        viewCamera.startCapture()
    }
}

// MARK: - Customize
extension QRViewController {
    private func customizeComponents() {
        
    }
}

// MARK: - Action - Obj
extension QRViewController {

}

// MARK: - Các hàm chức năng
extension QRViewController {
    
}
