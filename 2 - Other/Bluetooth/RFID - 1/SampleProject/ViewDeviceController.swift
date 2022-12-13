//
//  ViewDeviceController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
import ExternalAccessory

class ViewDeviceController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var deviceTableView: UITableView!
    /** 選択Index */
    private var selectedItemIndex:NSInteger = 0
    /** 端末リスト */
    private var deviceList:NSMutableArray = []
    /** クルクルアイコン */
    private var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    /** 機種種別 */
    private var deviceType = ""
    /** 機種切替 */
    @IBOutlet weak var deviceMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        let userDefaults = UserDefaults.standard
        if let type = userDefaults.string(forKey: DEVICE_TYPE_KEY) {
            self.deviceType = type
            if self.deviceType == DEVICE_TYPE_UF3000 {
                self.deviceMode.selectedSegmentIndex = DeviceMode.UF3000Device.rawValue
                SharedRfidSupervision.sharedManager.getRfidSuite().startScanDeviceBLE()
            }
        }
        
        deviceList = []
        selectedItemIndex = -1
        
        //クルクルアイコン生成
        indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
        
        //ペアリング済みデバイスリストを取り込み、リストに展開する
        self.takeDeviceList()
        
        if deviceList.count > 0 {
            //保存済みのデバイスがを取り出し、デバイスリストと一致すれば、選択済みを変更する
            self.searchSavedDevice()
        } else {
            if self.deviceType == DEVICE_TYPE_UF3000 {
                ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
                    //BLEリストの検出待ち時間
                    Thread.sleep(forTimeInterval: 1.0)
                    
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        //再度取得してみる
                        self.takeDeviceList()
                        if self.deviceList.count > 0 {
                            //デバイスが１件以上取得できたのならば、とりあえず、一番先頭のデバイスを選択状態とする
                            self.selectedItemIndex = 0
                            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                                self.deviceTableView.reloadData()
                            })
                        }
                    })
                })
                return
            }
            //ペアリングされたリストが無ければ、ここで、未ペアリングのデバイスリストを画面に表示してみる
            EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: {(error) -> Void in
                if let err:NSError = error as NSError? {
                    print("showBluetoothAccessoryPicker error=\(err.localizedDescription)")
                    return
                }
                //再度取得してみる
                self.takeDeviceList()
                if self.deviceList.count > 0 {
                    //デバイスが１件以上取得できたのならば、とりあえず、一番先頭のデバイスを選択状態とする
                    self.selectedItemIndex = 0
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        self.deviceTableView.reloadData()
                    })
                }
            })
        }
        //リスト更新
        self.deviceTableView.reloadData()
    }
    
    /** Viewが表示されなくなる直前に呼ばれるメソッド */
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        if self.deviceType == DEVICE_TYPE_UF3000 {
            SharedRfidSupervision.sharedManager.getRfidSuite().stopScanDeviceBLE()
        }
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: -内部メソッド
    /** デバイスリストをSDKから取り込む*/
    func takeDeviceList(){
        print("takeDeviceList")
        ToolCommon.synchronized(obj:self) {
            deviceList.removeAllObjects()
            selectedItemIndex = -1
            SharedRfidSupervision.sharedManager.getRfidSuite().getBluetoothList(deviceList)
        }
    }
    
    /** 保存済みのデバイスがを取り出し、デバイスリストと一致すれば、選択済みを変更する*/
    func searchSavedDevice(){
        print("searchSavedDevice")
        
        //デバイスリストがないのならそもそもの処理を続行する必要が無い
        if deviceList.count == 0 {
            return
        }
        
        let ud = UserDefaults.standard
        //保存されているBlootoothアドレスを取り込む
        if let blueAdress = ud.string(forKey: CFG_BD_ADRESS) {
            print("Saved device information=\(blueAdress)")
            // 配列から要素を検索する
            selectedItemIndex = 0//無ければ先頭を選択
            for i in 0..<deviceList.count {
                if let device:String =  deviceList.object(at: i) as? String {
                    if device.hasPrefix(blueAdress) {//全テキストではなく、先頭だけ比較
                        print("searchSavedDevice 該当あり data=\(device)")
                        selectedItemIndex = i//見つかったものにチェックを入れる
                        break
                    }
                }
            }
        }
    }
    
    /** 現在選択されているデバイスを設定ファイルへ保存する*/
    func saveSelectedDevice(targetDevice:String){
        print("saveSelectedDevice")
        var devide = targetDevice
        if self.deviceType == DEVICE_TYPE_UF3000 && SharedRfidSupervision.sharedManager.getRfidSuite().communicationMode == Int32(CommunicationMode.USB.rawValue){
            devide = "USB"
        }
        print("保存対象のデバイス=\(devide)")
        let ud = UserDefaults.standard
        ud.set(devide, forKey: CFG_BD_ADRESS) //保存
        ud.synchronize()// NSUserDefaultsに即時反映させる（即時で無くてもよい場合は不要）
    }
    
    /** アラートを表示する */
    func showAlert(title:String,message:String) {
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            //アニメーション停止
            self.indicatorView.stopAnimating()
            //画面操作有効
            self.navigationController?.view.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
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
    
    // MARK: - UI Event
    /** リスト更新ボタンタップイベント*/
    @IBAction func updateDeviceList(_ sender: Any) {
        takeDeviceList()
        searchSavedDevice()
         self.deviceTableView.reloadData()
    }
    
    /**機種切り替えイベント(UF-2200/UF-3000)*/
    @IBAction func deviceChangeEvent(_ sender: Any){//TODO:IBつなぐ
        //ローディング開始
        indicatorView.startAnimating()
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        
        if let mode:UISegmentedControl = sender as? UISegmentedControl {
            if mode.selectedSegmentIndex == DeviceMode.UF3000Device.rawValue {
                self.deviceType = DEVICE_TYPE_UF3000;
            }
            else {
                self.deviceType = DEVICE_TYPE_UF2200
            }
        }
        
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            //接続中ならばまず切断する
            if SharedRfidSupervision.sharedManager.getRfidSuite().claimed {
                SharedRfidSupervision.sharedManager.getRfidSuite().releaseDevice()
                Thread.sleep(forTimeInterval: 0.5)//切断待ち
                //ReleaseDevice時は、自分で切断を通知する
                SharedData.sharedManager.setData(anObject: CNS_OFF, aKey: CONNECT_STATE)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIF_DeviceOfflineNotification), object: self, userInfo: nil)
            }
            
            //オープンデバイス切替
            SharedRfidSupervision.sharedManager.getRfidSuite().close()
            SharedRfidSupervision.sharedManager.getRfidSuite().open(self.deviceType)
            let options=[KOP_LOG_LEVEL:ToolCommon.getLogLevel(),KOP_LOG_OUTPUT:ToolCommon.getLogOutput(),KOP_ZERO_FIRE:1]
            SharedRfidSupervision.sharedManager.getRfidSuite().setOptions(options)
            
            //機種設定保存
            let ud = UserDefaults.standard
            ud.set(self.deviceType, forKey: DEVICE_TYPE_KEY)
            ud.synchronize()
            
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                //再度取得してみる
                self.takeDeviceList()
                if self.deviceList.count > 0 {
                    self.selectedItemIndex = 0
                }
                self.deviceTableView.reloadData()
                //ローディング停止
                self.indicatorView.stopAnimating()
                self.navigationController?.view.isUserInteractionEnabled = true
                self.view.isUserInteractionEnabled = true
            })
        })
    }
    
    
    /** デバイス接続ボタンタップイベント*/
    @IBAction func clickConnect(_ sender: Any) {
        print("clickConnect")
        
        //デバイスリストが一件も無いのであれば接続できない。
        if selectedItemIndex<0 && self.deviceType == DEVICE_TYPE_UF2200 {
            return
        }
        
        var targetDevice:String = "USB"
        if selectedItemIndex>=0 {
            if let device:String =  deviceList.object(at: selectedItemIndex) as? String {
                if self.deviceType == DEVICE_TYPE_UF2200 {
                    targetDevice = String(device.prefix(BT_MAC_ADRESS_LEN))//先頭12バイトがMACアドレスである。
                }
                else {
                    targetDevice = device
                }
            }
        }
        
        print("接続対象のデバイス=\(targetDevice)")
        
        //クルクルアイコン　アニメーション開始
        indicatorView.startAnimating()
        
        //画面操作無効
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            var retVal:Int32 = 0
            
            //接続前に、既に接続中であれば切断する処理を入れる
            if SharedRfidSupervision.sharedManager.getRfidSuite().claimed {
                SharedRfidSupervision.sharedManager.getRfidSuite().releaseDevice()
                Thread.sleep(forTimeInterval: 0.5)//切断後、間髪入れずに接続ではなく、少し待つ
            }
            
            //接続処理
            let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
            retVal = SharedRfidSupervision.sharedManager.getRfidSuite().claimDevice(targetDevice, callback: {state in
                print("ConnectState Callback state=\(state.rawValue)")
                //デバイス切断時、メニュー側で処理させたいので、通知機能を利用
                if (state.rawValue) == ConnectState.offline.rawValue {
                    //デバイス切断通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIF_DeviceOfflineNotification), object: self, userInfo: nil)
                }else if (state.rawValue) == ConnectState.online.rawValue {
                    print("Connection successful.")
                    SharedData.sharedManager.setData(anObject: CNS_ON, aKey: CONNECT_STATE)
                    semaphore.signal()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIF_DeviceOnlineNotification), object: self, userInfo: nil)
                }
                
            })
            
            if retVal != OPOS_SUCCESS {
                print("Connect Failed.　errorCode＝\(retVal)")
                SharedData.sharedManager.setData(anObject: CNS_OFF, aKey: CONNECT_STATE)
                semaphore.signal()
            }
            
            if semaphore.wait(timeout:.now() + 6.000) == .timedOut {
                print("Connect Failed.")
                SharedData.sharedManager.setData(anObject: CNS_OFF, aKey: CONNECT_STATE)
            }
            
            let connectState:String = SharedData.sharedManager.getDataForKey(aKey: CONNECT_STATE)
            if (Int(connectState) == Int(CNS_OFF)) {
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.showAlert(title: "エラー", message: "接続に失敗しました")
                })
                return
            }
            
            //接続完了
            SharedRfidSupervision.sharedManager.getRfidSuite().deviceEnabled = true
            //選択デバイスを保存
            self.saveSelectedDevice(targetDevice: targetDevice)
            
            var ret:Int32 = 0
            ret = SharedRfidSupervision.sharedManager.getRfidSuite().enableModelCheckProperty({(resultCode,resultCodeExtended) -> Void in
                if resultCode != OPOS_SUCCESS {
                    self.showAlert(title: "エラー", message: "機種判定に失敗しました。")
                }
                else {
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        //アニメーション停止
                        self.indicatorView.stopAnimating()
                        //画面操作有効
                        self.navigationController?.view.isUserInteractionEnabled = true
                        self.view.isUserInteractionEnabled = true
                        //接続が発生して、元の画面に戻る時は、バージョン取り込みし直す為にフラグを立てる
                        SharedData.sharedManager.setData(anObject: RECONNECT_ON, aKey: "DevSelConnect")
                        
                        //元の画面に戻る
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            if ret != OPOS_SUCCESS {
                self.showAlert(title: "エラー", message: "機種判定に失敗しました。")
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    /** Table Viewの行数を返す*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    /** テーブルビュー表示の際にコールバックされるメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "indentifierDeviceTable")
        if let device:String =  deviceList.object(at: indexPath.row) as? String {
            tvcell.textLabel?.text = device
            //Table Viewの各行の情報を、UITableViewCellのオブジェクトとして返す
            if self.deviceType == DEVICE_TYPE_UF3000 && (device.count < BT_MAC_ADRESS_LEN || !ToolCommon.isMatchInputRule(target: device, expression: REGEX_HEX_NOLIMIT)) {
                tvcell.textLabel?.text = device
            }
            else {
              tvcell.textLabel?.text = ToolCommon.BTAdressEasyToSee(adress:device)
            }
        }
        
        tvcell.selectionStyle = .none
        //チェックマークを付ける
        if indexPath.row == selectedItemIndex {
            tvcell.accessoryType = .checkmark
        }
        else {
            tvcell.accessoryType = .none
        }
        tvcell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        return tvcell
    }
    
    /**バックグラウンドカラーの変更*/
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor(red: 104.0/255.0, green: 126.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
    
    // MARK: - UITableViewDelegate
    /**テーブル内でタップされた行にチェックを入れる*/
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("Row Index= \(indexPath.row)")

        selectedItemIndex=indexPath.row
        //一旦、全てのチェックを解除する
        for j in 0..<Int(tableView.numberOfSections) {
            for i in 0..<tableView.numberOfRows(inSection: j) {
                let index:IndexPath = IndexPath.init(row: i, section: j)
                if let cell:UITableViewCell = tableView.cellForRow(at:index) {
                    cell.accessoryType = .none
                }
            }
        }
        //新たにチェクを付ける
        if let cell:UITableViewCell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }

    
}

