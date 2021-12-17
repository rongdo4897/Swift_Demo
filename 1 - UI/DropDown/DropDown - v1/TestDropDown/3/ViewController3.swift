//
//  ViewController3.swift
//  TestDropDown
//
//  Created by Hoang Tung Lam on 12/29/20.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet weak var txtCountry: UITextField!

    var selectedCountry: String?
    var listCountrys = ["Vietnam",
                        "Korea",
                        "Japan",
                        "England",
                        "ThaiLand",
                        "India",
                        "Singapore",
                        "China",
                        "Japan",
                        "Combodia",
                        "Cuba",
                        "France",
                        "America",
                        "Canada",
                        "Russia",
                        "Australia",
                        "Greece",
                        "Denmark",
                        "Spain",
                        "Sweden",
                        "Switzerland",
                        "Turkey",
                        "Germany",
                        "Mexico",
                        "Brazil",
                        "Italy",
                        "Portugal",
                        "Poland"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
    }

    func createAndSetupPickerView() {
        let pickerview = UIPickerView()
        pickerview.dataSource = self
        pickerview.delegate = self
        self.txtCountry.inputView = pickerview
    }

    func dismissAndClosePickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.dismissAction))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        // Chế độ xem phụ kiện tùy chỉnh để hiển thị khi trường văn bản trở thành phản hồi đầu tiên.
        self.txtCountry.inputAccessoryView = toolbar
    }

    @objc func dismissAction() {
        self.view.endEditing(true)
    }
}

extension ViewController3: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listCountrys.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listCountrys[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = self.listCountrys[row]
        self.txtCountry.text = self.selectedCountry
    }
}
