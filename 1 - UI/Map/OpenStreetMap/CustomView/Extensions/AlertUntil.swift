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
    class func showAlertAskPermission(from viewController: UIViewController, with title: String, message: String, completionYes: (@escaping (UIAlertAction) -> Void), completionNo: (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Settings", style: .default, handler: completionYes)
            alert.addAction(doneAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: completionNo)
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
