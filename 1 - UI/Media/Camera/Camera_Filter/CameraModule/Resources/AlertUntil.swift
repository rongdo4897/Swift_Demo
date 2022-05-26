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
    class func showAlert(from viewController: UIViewController, with title: String, message: String,  completion : (@escaping (UIAlertAction) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
