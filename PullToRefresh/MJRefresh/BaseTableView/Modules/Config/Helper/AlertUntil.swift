//
//  AlertUntil.swift
//  IVM
//
//  Created by an.trantuan on 7/7/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
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
}
