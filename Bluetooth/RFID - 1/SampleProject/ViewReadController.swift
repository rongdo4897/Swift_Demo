//
//  ViewReadController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
let MAX_LIST_COUNT=99999

class ViewReadController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerValue: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSort: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var duplicateCheckBoxButton: UIButton!
    @IBOutlet weak var readTableView: UITableView!
    @IBOutlet weak var readNavigationItem: UINavigationItem!
    @IBOutlet weak var leftUnderView: UIView!
    @IBOutlet weak var tagCountLabel: UILabel!

    /** 読み取り中フラグ */
    private var stateReading = false
    /** 電波出力コマアニメ */
    private var readingAnimeImageView:UIImageView = UIImageView()
    /** タグリスト */
    private var tagArray:Array<String> = []
    /** クルクルアイコン */
    private var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    /** ThroughErrorList.plist */
    private var plistThroughErrorList:NSDictionary = [:]
    /** RWErrorInfo.plist */
    private var plistRWErrorInfo:NSDictionary = [:]
    
    private final var MAX_TIME_COUNT = 9999 //#102 ADD
    private final var MAX_READ_COUNT = 99999 //#102 ADD
    //#102 ADD START
    private var timer:Timer!
    private var timeCount:Int!
    private var tagCount:NSInteger!
    private var isUpdateTimeAndCount:Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //ThroughErrorList.plistの取り込み
        if let plistThroughErrorfilePath = Bundle.main.path(forResource: "ThroughErrorList.plist", ofType: nil) {
            if let dic = NSDictionary(contentsOfFile: plistThroughErrorfilePath) {
                plistThroughErrorList = dic
            }
        }
        //RWErrorInfo.plistの取り込み
        if let plistRWErrorInfofilePath = Bundle.main.path(forResource: "RWErrorInfo.plist", ofType: nil) {
            if let dic = NSDictionary(contentsOfFile: plistRWErrorInfofilePath) {
                plistRWErrorInfo = dic
            }
        }
        
        self.readTableView.estimatedRowHeight = 44
        self.readTableView.rowHeight = UITableViewAutomaticDimension

        stateReading = false
        tagArray = []

        // アニメーション用画像を配列にセット
        let imageList:NSMutableArray = []
        for i in 1..<4 {
            let imagePath = String(format:"ios-ico-rfid%d.png", i)
            if let img:UIImage = UIImage(named:imagePath) {
                imageList.add(img as Any)
            }
        }
        
        //イメージビューの生成
        readingAnimeImageView = UIImageView(image: (imageList[0] as? UIImage))
        readingAnimeImageView.isHidden = true

        // １ポイントあたりのピクセル数を取得
        let screenScale = UIScreen.main.scale

        //ピクセル情報からポイント情報に変換してサイズをセットする
        self.readingAnimeImageView.frame = CGRect(x:0,
                                             y:0,
                                             width:readingAnimeImageView.frame.size.width/screenScale,
                                             height:readingAnimeImageView.frame.size.height/screenScale)


        // アニメーション用画像をセット
        readingAnimeImageView.animationImages = (imageList as? [UIImage])

        // アニメーションの速度
        readingAnimeImageView.animationDuration = 1.8

        // アニメーションのリピート回数
        readingAnimeImageView.animationRepeatCount = 0


        //バーボタンアイテムにイメージビューを突っ込む
        let buttonItem:UIBarButtonItem = UIBarButtonItem.init(customView: readingAnimeImageView)

        //ナビゲーションアイテムに対して、ボーボタンを突っ込む
        self.readNavigationItem.rightBarButtonItem = buttonItem
        
        
        //クルクルアイコンを画面に割り付けておく
        indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
        
        
        //リスト更新
        self.readTableView.reloadData()
        
        self.tagCountLabel.text = "0"

        self.timeCount = 0
        self.isUpdateTimeAndCount = true
        self.timerValue.text = String(format: "%ds", timeCount)
    }

    func startStopCounting(isCount:Bool) {
        
        if (isCount) {
            if(timer != nil){
                timer.invalidate()
                timer = nil
            }
        } else {
            if(timer == nil) {
                timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(self.timerTick),
                                             userInfo: nil,
                                             repeats: true)
            }
        }
    }
    @objc func timerTick()  {
        let connectState:String = SharedData.sharedManager.getDataForKey(aKey: CONNECT_STATE)
        if (Int(connectState) == Int(CNS_ON)) {
            timeCount = timeCount + 1;
            if (timeCount == MAX_TIME_COUNT || isUpdateTimeAndCount == false) {
                timer.invalidate()
                isUpdateTimeAndCount = false;
            }
            self.timerValue.text = String(format: "%ds", timeCount)
        }
    }
    
    /** Viewが表示されなくなる直前に呼ばれるメソッド */
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewReadController viewWillDisappear")
        
        if stateReading {
            print("ViewReadController 他画面に遷移されそうになったが、継続リード中なので停止を行う")
            //現在リード中なら、停止する
            SharedRfidSupervision.sharedManager.getRfidSuite().stopReadTags({(resultCode,resultCodeExtended) -> Void in
                print("停止完了")
            })
        }
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: -内部メソッド
    /** 継続リードの停止を行う*/
    func myStopReadTags() {
        self.startFreeze()
        var ret:Int32 = 0
        ret = SharedRfidSupervision.sharedManager.getRfidSuite().stopReadTags({(resultCode,resultCodeExtended) -> Void in
            if resultCode != OPOS_SUCCESS {
                //エラー発生
                print("StopReadTagsコールバックで失敗している")
            }
            
            print("停止完了")
            self.stopFreeze()
            
            //ここで画面をイネーブル
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                //ボタンのキャプションを変更する "読取開始"
                if let img:UIImage = UIImage(named:"ios-btn-read_start-U.png") {
                    self.startStopButton.setImage(img, for: .normal)
                }
                
                //コマアニメ停止と非表示
                self.readingAnimeImageView.stopAnimating()
                self.readingAnimeImageView.isHidden = true
                
                self.stateReading = false
                
                //その他のボタンをイネーブルにする
                self.buttonClear.isEnabled = true
                self.buttonSort.isEnabled = true
                self.buttonSave.isEnabled = true
                
                //スリープを有効にする仕掛け
                UIApplication.shared.isIdleTimerDisabled = false
            })
        })
        if ret != OPOS_SUCCESS {
            //エラー発生
            print("StopReadTags実行失敗")
            self.stopFreeze()
        }
    }
    
    /**
     スルーしてもいいファームウェアのエラーコードか判断する
     @param fwErrorCode ファームウェアのエラーコード
     @return Bool スルーしてもいい場合はtrue
     */
    func judgeThroughCode(fwErrorCode:Int32) -> Bool {
        if plistThroughErrorList.object(forKey: String(format: "%d", fwErrorCode)) != nil {
            return true
        }
        return false
    }
    
    /** リストに表示されているタグを、ファイルに保存する */
    func saveTagListToFile(fileName:String) {
        print("saveTagListToFile fileName=\(fileName)")
        
        // ドキュメントフォルダのパス文字列を取得
        let aDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileFullPath:String = String(format:"%@/%@.data", aDirectory,fileName)
        print("fileFullPath=\(fileFullPath)")
        
        //書き込みデータ作成
        let taglist:NSMutableArray = []
        for tag in tagArray {
            taglist.add(tag)
        }
        
        startFreeze()
        var title = "エラー"
        var message = "保存に失敗しました"
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            if taglist.write(toFile: fileFullPath, atomically: true) {
                title = "情報"
                message = "保存に成功しました"
            }
            self.showAlert(title: title,message: message)
            self.stopFreeze()
        })
    }
    
    /** 排他処理 */
    public func synchronized(obj: AnyObject, closure: () -> Void) {
        objc_sync_enter(obj)
        closure()
        objc_sync_exit(obj)
    }
    
    // MARK: -表示処理
    /**
     ファームウェアのエラーコードから、エラーコードをメッセージに変換してアラート表示
     @param fwErrorCode ファームウェアのエラーコード
     */
    func dispFwErrorMessage(fwErrorCode:Int32) {
        //エラーコードを、メッセージに変換
        var fwErrorMsg = ""
        //変換できないときは、エラーコードをそのまま出力する
        if let massage = plistRWErrorInfo.object(forKey: String(format: "%d", fwErrorCode)) as? String {
            fwErrorMsg = massage
        }
        else {
            fwErrorMsg = String(format: "リーダーからのエラー受信 code=%d", fwErrorCode)
        }
        // アラートビューを表示
        self.showAlert(title: "エラー",message: fwErrorMsg)
    }
    
    /** 重複チェックチェックボックスの表示を反転する */
    func turnDuplicateCheckBox() {
        if stateReading {//リード最中は無効です
            return
        }
        
        //反転する
        self.duplicateCheckBoxButton.isSelected = !self.duplicateCheckBoxButton.isSelected
        
        if (self.duplicateCheckBoxButton.isSelected && tagArray.count != 0)  {
            //重複排除に変わった時は、重複を排除する
            var tagDupArray:Array<String> = []
            for tagID in tagArray {
                if tagDupArray.contains(tagID) == false {
                    tagDupArray.append(tagID)
                }
            }
            
            synchronized(obj: tagArray as AnyObject) {
                tagArray = tagDupArray
            }
            self.readTableView.reloadData()
            self.tagCountLabel.text = String(format: "%d", tagArray.count)
        }
    }
    
    /** アラートを表示する */
    func showAlert(title:String,message:String) {
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            let alert:UIAlertController = UIAlertController(title:title,
                                                            message: message,
                                                            preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                            style: UIAlertActionStyle.default,
                                                            handler:{
                                                                (action:UIAlertAction!) -> Void in
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    /** クルクルアイコン　アニメーション開始と、画面操作を無効とする */
    func startFreeze() {
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            //クルクルアイコン　アニメーション開始
            self.indicatorView.startAnimating()
            
            //画面操作無効
            self.navigationController?.view.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
        })
    }
    
    /** クルクルアイコンの停止と、画面操作を有効にする */
    func stopFreeze() {
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            //アニメーションの停止
            if self.indicatorView.isAnimating {
                self.indicatorView.stopAnimating()
            }
            
            //画面操作有効
            self.navigationController?.view.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - UITableViewDataSource
    /** Table Viewの行数を返す*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Table Viewの行数を返す
        var tagCountTmp = 0
        synchronized(obj: tagArray as AnyObject) {
            tagCountTmp = tagArray.count
        }
        return tagCountTmp
    }
    
    /** テーブルビュー表示の際にコールバックされるメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "indentifierReadTable")
        tvcell.selectionStyle = .none
        tvcell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Table Viewの各行の情報を、UITableViewCellのオブジェクトとして返す
        synchronized(obj: tagArray as AnyObject) {
            tvcell.textLabel?.text = tagArray[indexPath.row]
        }
        return tvcell
    }
    
    /**バックグラウンドカラーの変更*/
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor(red: 104.0/255.0, green: 126.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
    
    // MARK: - UI Event
    /** 読取開始 or 読取停止 ボタンクリックイベント
        一つのボタンではあるが、読み取り開始していない時は読み取り開始し、読み取り処理中であれば停止をする
     */
    @IBAction func clickStartStopButton(_ sender: Any) {
        
        self.startStopCounting(isCount: stateReading)

        var retVal:Int32 = 0
        if stateReading {
            //現在リード中なら、停止する
            myStopReadTags()
        }
        else {
            //リードしていないのなら、リード開始
            //継続リード動作インターバルを設定を、設定ファイルから取ってくる
            let readTimerInterval = UserDefaults.standard.integer(forKey: "ReadTimerInterval")
            print("設定ファイルから取り込み ReadTimerInterval=\(readTimerInterval)")
            SharedRfidSupervision.sharedManager.getRfidSuite().readTimerInterval = UInt32(readTimerInterval)
            
            SharedRfidSupervision.sharedManager.getRfidSuite().dataEventEnabled = true
            retVal = SharedRfidSupervision.sharedManager.getRfidSuite().startReadTags(nil, filtermask: nil, timeout: 10000, dataEvent: {(tagList) -> Void in
                //タグリストを自分の一時バッファに取り込む
                if let myBuffTmpTag:Dictionary = tagList {
                    //リスト更新とタグカウント更新
                    if myBuffTmpTag.count>0 {
                        print("Tag Count = \(myBuffTmpTag.count)")
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            var listAppended = false
                            self.synchronized(obj: self.tagArray as AnyObject) {
                                //追加した時に、最大をオーバーしないように、あらかじめ古いデータを消しておく
                                if (self.tagArray.count+myBuffTmpTag.count)>MAX_LIST_COUNT {
                                    self.tagArray.removeSubrange(0...(self.tagArray.count + myBuffTmpTag.count - MAX_LIST_COUNT))
                                }
                                //メンバ変数のタグリストに追加する
                                if self.duplicateCheckBoxButton.isSelected {
                                    //重複チェックあり
                                    for (key, _) in myBuffTmpTag {
                                        if let sKey = key as? String {
                                            if !self.tagArray.contains(sKey) {//無ければ追加
                                                self.tagArray.append(sKey)
                                                listAppended = true
                                            }
                                        }
                                    }
                                } else {
                                    for (key, _) in myBuffTmpTag {
                                        if let sKey = key as? String {
                                            self.tagArray.append(sKey)
                                        }
                                    }
                                    listAppended = true
                                }
                            }
                            
                            //タグカウント更新
                            self.tagCountLabel.text = String(format: "%d", self.tagArray.count)

                            //タグカウント更新
                            //#102 ADD start
                            if (self.tagArray.count >= self.MAX_READ_COUNT) {
                                self.isUpdateTimeAndCount = false
                                self.tagCountLabel.text = String(format: "%ld", self.MAX_READ_COUNT)
                                self.timer.invalidate()
                            } else if (self.isUpdateTimeAndCount == false) {
                                self.tagCountLabel.text = String(format: "%ld", self.tagCount)
                            } else {
                                self.tagCountLabel.text = String(format: "%ld", self.tagArray.count)
                                self.tagCount = self.tagArray.count
                            }
                            self.tagCountLabel.text = String(format: "%ld", self.tagCount)
                            
                            //リスト追加があった時は「音を鳴らす」「リストを一番下に移動する」
                            if listAppended {
                                //リストを一番下に移動
                                if self.tagArray.count>0 {
                                    let offset = self.readTableView.frame.origin.y + CGFloat(self.tagArray.count) * self.readTableView.estimatedRowHeight
                                    self.readTableView.setContentOffset(CGPoint(x:0, y:offset), animated: false)
                                }
                                //読み取り音吹鳴
                                SEManager.sharedManager.playSound(soundName: SOUND_READ)
                            }
                            
                            //リストの更新
                            self.readTableView.reloadData()
                        })
                    }
                }
                //コマアニメの開始および、その領域を表示する
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    if(!self.readingAnimeImageView.isAnimating){
                        print("コマアニメ開始")
                        self.readingAnimeImageView.startAnimating()
                        self.readingAnimeImageView.isHidden = false
                    }
                })
                //継続してイベントを上げたいのでYESにする
                SharedRfidSupervision.sharedManager.getRfidSuite().dataEventEnabled = true
            }, errorEvent: {(resultCode,resultCodeExtended) -> Void in
                if resultCode == OPOS_E_RES {
                    if resultCodeExtended == FW_RES_CODE_NOTRIG {
                        //トリガースイッチが押されていないことによるエラーイベント
                        //この時は、電波出力表示を停止する。
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            if self.readingAnimeImageView.isAnimating {
                                print("コマアニメ停止")
                                self.readingAnimeImageView.stopAnimating()
                                self.readingAnimeImageView.isHidden = true
                            }
                        })
                    }
                    else if self.judgeThroughCode(fwErrorCode: resultCodeExtended) {
                        //スルーしていいいので、スルーする
                        print("スルーしてOKのエラーコードなので、何もしない。")
                    }
                    else{
                        //スルーできないものは、エラーメッセージを表示し、継続リードを停止する
                        self.dispFwErrorMessage(fwErrorCode: resultCodeExtended)
                        self.myStopReadTags()
                        //時間更新を強制停止
                        self.startStopCounting(isCount: true);
                    }
                }
                else {
                    print("継続リードのエラーイベント　エラーコード＝\(resultCode) 拡張=\(resultCodeExtended)")
                }
            })
            if retVal == OPOS_SUCCESS {
                //ボタンのキャプションを変更する "読取停止"
                if let img:UIImage = UIImage(named:"ios-btn-read_stop-U.png") {
                    self.startStopButton.setImage(img, for: .normal)
                }
                
                //開始状態とする
                stateReading = true
                
                //その他のボタンをディセーブルにする
                self.buttonClear.isEnabled = false
                self.buttonSort.isEnabled = false
                self.buttonSave.isEnabled = false
                //スリープを無効にする仕掛け
                UIApplication.shared.isIdleTimerDisabled = true
            }
            else{
                print("継続リード開始に失敗　エラーコード＝\(retVal)")
                // アラートビューを表示
                showAlert(title: "エラー", message: String(format: "リード開始に失敗しました code=%d ext=%d", retVal,SharedRfidSupervision.sharedManager.getRfidSuite().resultCodeExtended))
            }
        }
    }
    
    /** クリアボタンタップイベント */
    @IBAction func clickClearButton(_ sender: Any) {
        tagArray.removeAll()
        //リスト更新
        self.readTableView.reloadData()
        
        //時間表示を0にする
        timeCount = 0;
        self.timerValue.text = String(format: "%ds", self.timeCount)
        self.tagCountLabel.text = "0"

        self.isUpdateTimeAndCount = true
    }
    
    /** ソートボタンタップイベント */
    @IBAction func clickSortButton(_ sender: Any) {
        if tagArray.count == 0 {
            return
        }
        let sortTemp:Array<String> = tagArray.sorted()
        synchronized(obj: tagArray as AnyObject) {
            tagArray = sortTemp
        }
        self.readTableView.reloadData()
    }
    
    /** 保存ボタンタップイベント */
    @IBAction func clickSaveButton(_ sender: Any) {
        //ファイルにタグリスト情報を保存する
        //リストにタグが無い場合はエラー
        if tagArray.count == 0 {
            self.showAlert(title: "エラー",message: "タグがありません")
            return
        }
        
        //ファイル名を指定させるダイアログを表示
        let alert:UIAlertController = UIAlertController(title:"新しいファイル名",
                                                        message: nil,
                                                        preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            if let textValue:Array<UITextField> =  alert.textFields {
                                                                if let fileName = textValue[0].text {
                                                                    if fileName.isEmpty {
                                                                        self.showAlert(title: "エラー",message: "ファイル名を入力してください")
                                                                        return
                                                                    }
                                                                    //リストをファイル化する関数を呼び出す
                                                                    self.saveTagListToFile(fileName: fileName)
                                                                }
                                                            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addTextField(configurationHandler: {(text:UITextField?) -> Void in
        })
        self.present(alert, animated: true, completion: nil)
        
    }

    /** チェックボックスの横にあるラベルもどきのボタン */
    @IBAction func clickDuplicateBtnLab(_ sender: Any) {
        turnDuplicateCheckBox()
    }
    
    /** チェックボックスの変更で呼ばれるメソッド */
    @IBAction func clickDuplicateCheckBox(_ sender: Any) {
        turnDuplicateCheckBox()
    }

}

