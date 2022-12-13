//
//  ViewBarcodeReadController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
/** バーコード読取最大数 */
let kMaxListCount = 99999
/** バーコード制御コード表示用キー */
let kBarcodeDisplayValue = "BarcodeDisplay"
/** バーコードHEX表示用キー */
let kBarcodeHexValue = "BarcodeHex"

class ViewBarcodeReadController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSort: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var barcodeCountLabel: UILabel!
    @IBOutlet weak var readTableView: UITableView!
    @IBOutlet weak var leftUnderView: UIView!
    @IBOutlet weak var readNavigationItem: UINavigationItem!
    
    /** バーコード読み取り状態 */
    private var _stateReading = false
    /** バーコード情報 */
    private var _barcodeArray:Array<Dictionary<String, Any>> = []
    /** クルクルアイコン */
    private var _indicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    /** ThroughErrorList.plist */
    private var _plistThroughErrorList:NSDictionary = [:]
    /** RWErrorInfo.plist */
    private var _plistRWErrorInfo:NSDictionary = [:]
    /** バーコードデータ変換用辞書*/
    private var _parseDataDict:Dictionary<String, Dictionary<String, String>> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        //カスタムセル
        self.readTableView.register(UINib(nibName: "ReadBarcodeTableViewCell", bundle: nil), forCellReuseIdentifier: "readBarcodeviewcell")
        
        // UIButtonを作成
        let backButton : UIButton = UIButton(type: UIButtonType.system)
        backButton.frame = CGRect(x:0,y:0,width:100,height:30)
        backButton.setTitle("＜メニュー", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        backButton.setTitleColor(UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        // ボタンタップ時のアクション設定
        backButton.addTarget(self, action:  #selector(doBack), for: UIControlEvents.touchUpInside)
        
        let backItem = UIBarButtonItem(customView: backButton)
        self.readNavigationItem.hidesBackButton = true
        self.readNavigationItem.leftBarButtonItem = backItem
        print("ViewBarcodeReadController first")
        
        //ThroughErrorList.plistの取り込み
        if let plistThroughErrorfilePath = Bundle.main.path(forResource: "ThroughErrorList.plist", ofType: nil) {
            if let dic = NSDictionary(contentsOfFile: plistThroughErrorfilePath) {
                _plistThroughErrorList = dic
            }
        }
        //RWErrorInfo.plistの取り込み
        if let plistRWErrorInfofilePath = Bundle.main.path(forResource: "RWErrorInfo.plist", ofType: nil) {
            if let dic = NSDictionary(contentsOfFile: plistRWErrorInfofilePath) {
                _plistRWErrorInfo = dic
            }
        }
        self.readTableView.estimatedRowHeight = 44
        self.readTableView.rowHeight = UITableViewAutomaticDimension
        _stateReading = false
        _barcodeArray = []
        _parseDataDict = [:]
        
        //バーボタンアイテムにイメージビューを突っ込む
        if let img:UIImage = UIImage(named:"ios-ico-barcode_header.png") {
            let barcodeIcon = UIImageView(image:img)
            let buttonItem:UIBarButtonItem = UIBarButtonItem.init(customView: barcodeIcon)
            //ナビゲーションアイテムに対して、ボーボタンを突っ込む
            self.readNavigationItem.rightBarButtonItem = buttonItem
        }
        //クルクルアイコンを画面に割り付けておく
        _indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
        
        //リスト更新
        self.readTableView.reloadData()

        self.barcodeCountLabel.text = "0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -内部メソッド
    /**
     バーコード継続リードの停止を行う
     */
    func myStopReadBarcode() {
        self.startFreeze()
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            var ret:Int32 = 0
            ret = SharedRfidSupervision.sharedManager.getRfidSuite().stopReadBarcode({(resultCode,resultCodeExtended) -> Void in
                if resultCode != OPOS_SUCCESS && resultCode != OPOS_E_NOHARDWARE {
                    //エラー発生
                    print("stopReadBarcodeコールバックで失敗している resultCode=\(resultCode) resultCodeExtended=\(resultCodeExtended)");
                    self.showDialog(title: "エラー", message: String(format: "stopReadBarcodeコールバックで失敗している resultCode=%d resultCodeExtended=%d", resultCode,resultCodeExtended))
                }
                else {
                    print("停止完了")
                    //ここで画面をイネーブル
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        //ボタンのキャプションを変更する "読取開始"
                        if let img:UIImage = UIImage(named:"ios-btn-read_start-U.png") {
                            self.startStopButton.setImage(img, for: .normal)
                        }
                        self._stateReading = false
                        
                        //その他のボタンをイネーブルにする
                        self.buttonClear.isEnabled = true
                        self.buttonSort.isEnabled = true
                        self.buttonSave.isEnabled = true
                        
                        //スリープを有効にする仕掛け
                        UIApplication.shared.isIdleTimerDisabled = false
                    })
                }
                self.stopFreeze()
            })
            if ret != OPOS_SUCCESS {
                //エラー発生
                print("stopReadBarcode実行失敗")
                self.stopFreeze()
            }
        })
    }
    
    /**
     スルーしてもいいファームウェアのエラーコードか判断する
     @param fwErrorCode ファームウェアのエラーコード
     @return Bool スルーしてもいい場合はtrue
     */
    func judgeThroughCode(fwErrorCode:Int32) -> Bool {
        if _plistThroughErrorList.object(forKey: String(format: "%d", fwErrorCode)) != nil {
            return true
        }
        return false
    }
    
    /**
     リストに表示されているバーコードを、ファイルに保存する
     @param fileName 保存するファイル名
     */
    func saveBarcodeListToFile(fileName:String) {
        print("saveBarcodeListToFile fileName=\(fileName)")
        
        // ドキュメントフォルダのパス文字列を取得
        let aDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileFullPath:String = String(format:"%@/%@.txt", aDirectory,fileName)
        print("fileFullPath=\(fileFullPath)")
        
        startFreeze()
        //1行に出力する内容を生成
        var fulllline = ""
        for barcodePack in _barcodeArray {
            if let barcodeData:String = barcodePack[KBP_BARCODE_VALUE] as? String {
                if _parseDataDict[barcodeData] != nil {
                    if let dict:Dictionary<String,String> = _parseDataDict[barcodeData] {
                        if let barcodeDisp:String = dict[kBarcodeDisplayValue] {
                            fulllline.append(barcodeDisp)
                            fulllline.append(",")
                        }
                        if let barcodeHex:String = dict[kBarcodeHexValue] {
                            fulllline.append(barcodeHex)
                            fulllline.append(",")
                        }
                        if let barcodeType:String = barcodePack[KBP_BARCODE_TYPE] as? String {
                            fulllline.append(barcodeType)
                            fulllline.append("\n")
                        }
                    }
                }
                else {
                    self.showDialog(title: "エラー",message: "保存に失敗しました")
                    self.stopFreeze()
                    return
                }
            }
        }
        var title = "エラー"
        var message = "保存に失敗しました"
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            do {
                try fulllline.write(toFile: fileFullPath, atomically: true, encoding: String.Encoding.utf8)
                title = "情報"
                message = "保存に成功しました"
            } catch {
                print("failed to write: \(error)")
            }
            self.showDialog(title: title,message: message)
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
        if let massage = _plistRWErrorInfo.object(forKey: String(format: "%d", fwErrorCode)) as? String {
            fwErrorMsg = massage
        }
        else {
            fwErrorMsg = String(format: "リーダーからのエラー受信 code=%d", fwErrorCode)
        }
        // アラートビューを表示
        self.showDialog(title: "エラー",message: fwErrorMsg)
    }
    
    /**
     ダイアログ表示
     @param title タイトル
     @param message メッセージ
     */
    func showDialog(title:String,message:String) {
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
            self._indicatorView.startAnimating()
            
            //画面操作無効
            self.navigationController?.view.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
        })
    }
    
    /** クルクルアイコンの停止と、画面操作を有効にする */
    func stopFreeze() {
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            //アニメーションの停止
            if self._indicatorView.isAnimating {
                self._indicatorView.stopAnimating()
            }
            
            //画面操作有効
            self.navigationController?.view.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
        })
    }
    
    /**
     画面回転検知
     */
    @objc func onOrientationChange(notification: NSNotification){
        //クルクルアイコン更新
        self._indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
    }
    
    // MARK: - UI Event
    @IBAction func clickStartStopButton(_ sender: Any) {
        var retVal:Int32 = 0
        if _stateReading {
            //現在バーコードリード中なら、停止する
            myStopReadBarcode()
        }
        else {
            ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
                //リードしていないのなら、リード開始
                retVal = SharedRfidSupervision.sharedManager.getRfidSuite().startReadBarcode({(barcodePack,resultCode,resultCodeExtended) -> Void in
                    //リスト更新とバーコードカウント更新
                    if resultCode == OPOS_SUCCESS {
                        if let myBuffTmpBarcodePack:Dictionary<String,Any> = barcodePack as? Dictionary<String, Any> {
                            //追加されたタグの数
                            self.synchronized(obj: self._barcodeArray as AnyObject) {
                                //追加した時に、最大をオーバーしないように、あらかじめ古いデータを消しておく
                                if (self._barcodeArray.count+1) > kMaxListCount {
                                    self._barcodeArray.removeSubrange(0...(self._barcodeArray.count + 1 - kMaxListCount))
                                }
                                
                                //メンバ変数のタグリストに追加する
                                self._barcodeArray.append(myBuffTmpBarcodePack)
                            }
                            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                                //自動スクロール
                                if self._barcodeArray.count>0 {
                                    let offset = self.readTableView.frame.origin.y + CGFloat(self._barcodeArray.count) * self.readTableView.estimatedRowHeight
                                    self.readTableView.setContentOffset(CGPoint(x:0, y:offset), animated: false)
                                }
                                //リストの更新
                                self.readTableView.reloadData()
                                
                                //バーコードカウント更新
                                self.barcodeCountLabel.text = String(format: "%d", self._barcodeArray.count)
                            })
                        }
                    }
                    else if resultCode == OPOS_E_RES {
                        if resultCodeExtended == FW_RES_CODE_NOTRIG {
                            //トリガースイッチが押されていないことによるエラーイベント
                            //この時は、電波出力表示を停止する。
                        }
                        else if self.judgeThroughCode(fwErrorCode:resultCodeExtended){
                            //スルーしていいいので、スルーする
                            print("スルーしてOKのエラーコードなので、何もしない。")
                        }
                        else{
                            //スルーできないものは、エラーメッセージを表示し、継続リードを停止する
                            self.dispFwErrorMessage(fwErrorCode:resultCodeExtended)
                            self.myStopReadBarcode()
                        }
                    }
                    else {
                        print("バーコード継続リードのエラーイベント　エラーコード＝\(resultCode) 拡張=\(resultCodeExtended)")
                    }
                })
                if retVal == OPOS_SUCCESS {
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        //ボタンのキャプションを変更する "読取停止"
                        if let img:UIImage = UIImage(named:"ios-btn-read_stop-U.png") {
                            self.startStopButton.setImage(img, for: .normal)
                        }
                        
                        //開始状態とする
                        self._stateReading = true
                        
                        //その他のボタンをディセーブルにする
                        self.buttonClear.isEnabled = false
                        self.buttonSort.isEnabled = false
                        self.buttonSave.isEnabled = false
                        //スリープを無効にする仕掛け
                        UIApplication.shared.isIdleTimerDisabled = true
                    })
                }
                else {
                    print("バーコード継続リード開始に失敗　エラーコード＝\(retVal)")
                    self.showDialog(title: "エラー", message: String(format: "リード開始に失敗しました code=%d ext=%d", retVal,SharedRfidSupervision.sharedManager.getRfidSuite().resultCodeExtended))
                }
            })
        }
    }
    
    /**
     戻るボタンタップ
     */
    @objc func doBack(_ sender: Any) {
        if _stateReading {
            showDialog(title: "エラー", message: "バーコード読取中です\n読取停止ボタンを押して読取を停止してください。")
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     クリアボタンタップ
     */
    @IBAction func clickClearButton(_ sender: Any) {
        _barcodeArray.removeAll()
        //リスト更新
        self.readTableView.reloadData()
        self.barcodeCountLabel.text = "0"
    }
    
    /**
     ソートボタンタップ
     */
    @IBAction func clickSortButton(_ sender: Any) {
        synchronized(obj: _barcodeArray as AnyObject) {
            var barcodelist:Array<String> = []
            var tmpWork:Array<Dictionary<String, Any>> = []
            var sortWork:Array<Dictionary<String, Any>> = []
            for i in 0..<_barcodeArray.count {
                let barcodePack = _barcodeArray[i]
                tmpWork.append(barcodePack)
                if let barcode:String = barcodePack[KBP_BARCODE_VALUE] as? String {
                    barcodelist.append(barcode)
                }
            }
            //バーコードのソート
            let sortTemp:Array<String> = barcodelist.sorted()
            for i in 0..<sortTemp.count {
                let barcodeTemp:String = sortTemp[i]
                for j in 0..<tmpWork.count {
                    let barcodePack = tmpWork[j]
                    if let barcode:String = barcodePack[KBP_BARCODE_VALUE] as? String {
                        if barcode == barcodeTemp {
                            //一致したバーコード情報を格納
                            sortWork.append(barcodePack)
                            //格納したバーコード情報を削除
                            tmpWork.remove(at:j)
                            break
                        }
                    }
                }
            }
            _barcodeArray = sortWork
        }
        self.readTableView.reloadData()
    }
    
    /**
     保存ボタンタップ
     */
    @IBAction func clickSaveButton(_ sender: Any) {
        //リストにバーコードが無い場合はエラー
        if _barcodeArray.count == 0 {
            showDialog(title: "エラー", message: "バーコードがありません")
            return
        }
        //ファイル名を指定させるダイアログを表示
        // NsDate => NSString 変換用のフォーマッタを作成。
        let nsDateFormatter = DateFormatter()
        nsDateFormatter.locale = Locale(identifier: "ja_JP")// Locale の指定。
        nsDateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        
        // 日付 (NSDate) => 文字列 (NSString) に変換。
        let dateTimeNow = Date()
        let strDateTimeNow = nsDateFormatter.string(from: dateTimeNow)

        // デフォルトのファイル名を設定。
        let textValue = String(format: "%@%@", "ReadBarcode",strDateTimeNow)
        let alert:UIAlertController = UIAlertController(title:"新しいファイル名",
                                                        message: nil,
                                                        preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル",
                                                       style: UIAlertActionStyle.default,
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
                                                                        self.showDialog(title: "エラー",message: "ファイル名を入力してください")
                                                                        return
                                                                    }
                                                                    //リストをファイル化する関数を呼び出す
                                                                    self.saveBarcodeListToFile(fileName: fileName)
                                                                }
                                                            }
        })
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {(text:UITextField?) -> Void in
            text?.text = textValue
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    /** Table Viewの行数を返す*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Table Viewの行数を返す
        var tagCountTmp = 0
        synchronized(obj: _barcodeArray as AnyObject) {
            tagCountTmp = _barcodeArray.count
        }
        return tagCountTmp
    }
    
    /** テーブルビュー表示の際にコールバックされるメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = tableView.dequeueReusableCell(withIdentifier: "readBarcodeviewcell", for: indexPath) as? ReadBarcodeTableViewCell
        // ラベルテキスト設定
        synchronized(obj: _barcodeArray as AnyObject) {
            let barcodePack = self._barcodeArray[indexPath.row]
            var isChange = false
            if let barcode = barcodePack[KBP_BARCODE_VALUE] as? String {
                let barcodeData:String = barcode
                var dict:Dictionary<String, String>
                if let barcodeDict = _parseDataDict[barcodeData] {
                    dict = barcodeDict
                }
                else {
                    dict = [:]
                }
                if let hexval = dict[kBarcodeHexValue] {
                    tvcell?.barcodeHexLabel.text = hexval
                }
                else {
                    //16進数変換
                    var tmpStr = ""
                    var barcodeHex = ""
                    for i in 0..<barcodeData.count {
                        tmpStr = String(format: "%02X",(barcodeData as NSString).character(at: i))
                        barcodeHex = String(format: "%@%@",barcodeHex,tmpStr)
                    }
                    dict[kBarcodeHexValue] = barcodeHex
                    isChange = true
                    tvcell?.barcodeHexLabel.text = barcodeHex
                }
                if let disp = dict[kBarcodeDisplayValue] {
                    tvcell?.barcodeLabel.text = disp
                }
                else {
                    //制御コードは・に変換して表示
                    var barcodeDisp = ""
                    var tmpStr = ""
                    for i in 0..<barcodeData.count {
                        let ch = (barcodeData as NSString).character(at: i)
                        if ch<0x1f || ch == 0x7f {
                            tmpStr = "･"
                        }
                        else {
                            tmpStr = String(format: "%c", ch)
                        }
                        barcodeDisp = String(format: "%@%@",barcodeDisp,tmpStr)
                    }
                    dict[kBarcodeDisplayValue] = barcodeDisp
                    tvcell?.barcodeLabel.text = barcodeDisp
                    isChange = true
                }
                if isChange {
                    _parseDataDict[barcodeData] = dict
                }
            }
            if let typeData = barcodePack[KBP_BARCODE_TYPE] as? String {
               tvcell?.typeLabel.text = typeData
            }
        }
        
        //セル選択時に色なしに設定
        tvcell?.selectionStyle = .none
        return tvcell!
    }
    
    /**バックグラウンドカラーの変更*/
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor(red: 104.0/255.0, green: 126.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
}

