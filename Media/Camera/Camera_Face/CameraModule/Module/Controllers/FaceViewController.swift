//
//  FaceViewController.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import UIKit

//MARK: - Outlet, Override
class FaceViewController: UIViewController {
    @IBOutlet weak var viewMain: UIView!
    
    var viewCamera: FaceDetectCameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewCamera.stopCapture()
    }
    
    @IBAction func btnCaptureTapped(_ sender: Any) {
        viewCamera.isCapture = true
    }
}

//MARK: - Các hàm khởi tạo
extension FaceViewController {
    private func initComponents() {
        initCameraView()
    }
    
    private func initCameraView() {
        viewCamera = FaceDetectCameraView(bufferQueue: DispatchQueue(label: "Camera"), onResults: { image, checkDetect, cameraError in
            guard let _ = image, cameraError == .none else {return}
            if !checkDetect {
                AlertUtil.showAlert(from: self, with: "Không có mặt trong bức ảnh", message: "") { _ in
                    self.viewCamera.startCapture()
                }
            } else {
                AlertUtil.showAlert(from: self, with: "Chụp thành công", message: "") { _ in
                    self.viewCamera.startCapture()
                }
            }
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

//MARK: - Customize
extension FaceViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension FaceViewController {
    
}

//MARK: - Các hàm chức năng
extension FaceViewController {
    
}
