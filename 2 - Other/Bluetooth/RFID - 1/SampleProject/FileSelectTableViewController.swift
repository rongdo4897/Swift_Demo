//
//  FileSelectTableViewController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//
//  ファイル選択画面

import UIKit

/** フォルダから検索する拡張子*/
let SEARCH_EXT=".setting"

class FileSelectTableViewController: UITableViewController {
    private var fileList:Array<String> = []

    @IBOutlet var fileTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        fileList = []
        takeFileList()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -内部メソッド
    /** 保存されている設定ファイル一覧を表示する */
    func takeFileList() {
        print("takeFileList")
        // ドキュメントフォルダのパス文字列を取得
        // ドキュメントパス
        let aDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        // ファイルマネージャを作成
        var list: [String]
        do {
            list = try FileManager.default.contentsOfDirectory(atPath: aDirectory)
        } catch {
            list = []
        }
        fileList.removeAll()
        
        // ファイルやディレクトリの一覧を表示する
        for path in list {
            if path.hasSuffix(SEARCH_EXT) {
                print("\(path)" )
                fileList.append(path)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    /** セルの行数 */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    /** セルのテキストを追加 */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "FileSelectTableViewCell")
        cell.textLabel?.text = fileList[indexPath.row]
        return cell
    }
    
    /**
     テーブルビューのセクション数を返すメソッド
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     セクション毎のタイトルをヘッダーに表示
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        SharedData.sharedManager.setData(anObject: fileList[indexPath.row], aKey: "SelectedFileName")
        self.navigationController?.popViewController(animated: true)
    }
}


