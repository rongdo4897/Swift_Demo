//
//  ViewController.swift
//  TestRealm
//
//  Created by Hoang Tung Lam on 11/26/20.
//

import UIKit
import RealmSwift

class Test1ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tblPeople: UITableView!

    var listPeople: Results<ExampleData>? // kết quả trả về
    let realm = try! Realm() // tạo ra để sử dụng realm

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblPeople.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tblPeople.dataSource = self
        tblPeople.delegate = self
        tblPeople.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblPeople.frame.width, height: 0))
        loadPeopleDatabase()
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        self.tblPeople.addGestureRecognizer(longPressGesture)
    }

    func loadPeopleDatabase() {
        listPeople = realm.objects(ExampleData.self)
        tblPeople.reloadData()
    }

    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {

            let touchPoint = longPressGestureRecognizer.location(in: self.tblPeople)
            if let indexPath = tblPeople.indexPathForRow(at: touchPoint) {
                let mainAlert = UIAlertController(title: listPeople?[indexPath.row].name, message: "", preferredStyle: .actionSheet)
                let updateAction = UIAlertAction(title: "Update People", style: .default) { (_) in
                    var textField = UITextField()
                    let alert = UIAlertController(title: "Update People", message: "", preferredStyle: .alert)
                    alert.addTextField { (alertTextField) in
                        alertTextField.placeholder = "Enter Name You Want To Update"
                        textField = alertTextField
                    }

                    let action = UIAlertAction(title: "Update People", style: .default) { (_) in
                        if let name = self.listPeople?[indexPath.row] {
                            do {
                                try self.realm.write({
                                    name.name = textField.text ?? ""
                                    self.loadPeopleDatabase()
                                })
                            } catch {
                                print("error")
                            }
                        }
                    }

                    alert.addAction(action)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                mainAlert.addAction(updateAction)

                let deleteAction = UIAlertAction(title: "Delete People", style: .default) { (_) in
                    let alert = UIAlertController(title: "Delete People", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        if let name = self.listPeople?[indexPath.row] {
                            do {
                                try self.realm.write({
                                    self.realm.delete(name)
                                    self.loadPeopleDatabase()
                                })
                            } catch {
                                print("error")
                            }
                        }
                    }
                    okAction.setValue(UIColor.red, forKey: "titleTextColor")
                    alert.addAction(okAction)

                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
                mainAlert.addAction(deleteAction)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                mainAlert.addAction(cancelAction)

                present(mainAlert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func btnAddTapped() {
        let newName = ExampleData()
        newName.name = txtName.text ?? ""
        do {
            try! realm.write({ // tạo 1 yêu cầu database
                realm.add(newName)
            })
            loadPeopleDatabase()
            txtName.text = ""
        } catch {
            print("Error add data")
        }
    }
}

extension Test1ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPeople?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = listPeople?[indexPath.row].name ?? "no name added yet"
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: self.listPeople?[indexPath.row].name,
                                      message: "",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
