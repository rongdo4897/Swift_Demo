//
//  AlertUntil.swift
//  AddContact
//
//  Created by Huong Nguyen on 3/3/21.
//

import Foundation
import UIKit

class AlertUtil {
    class func showAlertSave(from viewController: UIViewController, with title: String, message: String, completionYes: (@escaping (UIAlertAction) -> Void), completionNo: (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "YES", style: .default, handler: completionYes)
            alert.addAction(doneAction)
            let cancelAction = UIAlertAction(title: "NO", style: .default, handler: completionNo)
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showAlert(from viewController: UIViewController, with title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showAlert(from viewController: UIViewController, with title: String, message: String,  completion : (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showAlertConfirm(from viewController: UIViewController, with title: String, message: String,  completion : (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "YES", style: .default, handler: completion)
            alert.addAction(doneAction)
            let cancelAction = UIAlertAction(title: "NO", style: .destructive, handler: nil)
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func logout(from viewController: UIViewController, with title: String, message: String,  completion : (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .default, handler: completion)
            alert.addAction(doneAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showImagePicker(from viewController: UIViewController, with title: String, message: String, completionCamera: (@escaping (UIAlertAction) -> Void), completionPicture: (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let presentCamera = UIAlertAction(title: "Lưu vào thư viện ảnh", style: .default, handler: completionCamera)
            alert.addAction(presentCamera)
            let presentPicture = UIAlertAction(title: "Xóa", style: .default, handler: completionPicture)
            alert.addAction(presentPicture)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func deleteContact(from viewController: UIViewController, completion: (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete Contact", style: .destructive, handler: completion)
            alert.addAction(delete)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
