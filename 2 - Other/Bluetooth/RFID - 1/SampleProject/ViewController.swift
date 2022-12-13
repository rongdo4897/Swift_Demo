//
//  ViewController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
import ExternalAccessory

 /** バッテリー表示部分の幅 */
let BATTERY_WIDTH=70

class ViewController: UIViewController {
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var deviceAdressTextField: UITextField!
    @IBOutlet weak var firmVerTextField: UITextField!
    @IBOutlet weak var batteryLevelView: UIView!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    @IBOutlet weak var constraintbatteryHeight: NSLayoutConstraint!

    /** クルクルアイコン */
    private var indicatorView = UIActivityIndicatorView()
    /** バッテリーレベルリフレッシュ用タイマー */
    private var timerBattery = Timer()
    /** バッテリーレベルリフレッシュ用直列キュー */
    private var dispatchQueueBattery:DispatchQueue!
    /** バッテリーレベルリフレッシュ用直列キュー管理 */
    private var dispatchGroupBattery = DispatchGroup()
    /** 本画面が表示されているか */
    private var isMineDisp = false
    /** 起動時、バージョンの取得に失敗している */
    private var verGetFailure = false
    /** 切断されたメッセージ */
    private var alertDeviceDisconnect:UIAlertController!
    /** 機種種別 */
    private var deviceType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewController viewDidLoad")
        
        alertDeviceDisconnect = UIAlertController(title:"切断イベント",
                                                  message: "デバイスが切断されました",
                                                  preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
        })
        alertDeviceDisconnect.addAction(defaultAction)
        
        buttonsEnable(enabled: false)
        verGetFailure=false
        isMineDisp=false
        timerBattery = Timer()
        dispatchQueueBattery = DispatchQueue(label: "jp.tec.UF-2000Tool.dispatchQueueBattery", attributes: .concurrent)
        dispatchGroupBattery = DispatchGroup()
        
        self.firmVerTextField.text = ""
        self.batteryLevelLabel.text = ""
        self.deviceAdressTextField.text = ""
        
        //デバイス切断通知の受け口（デバイス接続画面から）
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(_deviceOfflineNotification(notification:)), name: Notification.Name(rawValue:NOTIF_DeviceOfflineNotification), object: nil)
        
        //デバイスが再接続された時の通知の受け口（デバイス接続画面から）
        nc.addObserver(self, selector: #selector(_deviceOnlineNotification(notification:)), name: Notification.Name(rawValue:NOTIF_DeviceOnlineNotification), object: nil)
        
        //設定ファイル(plist)関連処理
        //Settings.bundle(Root.plist)の情報に、NSUserDefaultsの未設定デフォルトを合わせ込む
        ToolCommon.registerDefaultsFromSettingsBundle(plist: "Root.plist")
        
        //クルクルアイコンを画面に割り付けておく
        indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
        
        //RFIDライブラリのオープン
        let userDefaults = UserDefaults.standard
        if let device = userDefaults.string(forKey: DEVICE_TYPE_KEY) {
            self.deviceType = device
        }
        else {
            UserDefaults.standard.set(DEVICE_TYPE_UF2200,forKey: DEVICE_TYPE_KEY)
            UserDefaults.standard.synchronize()
            self.deviceType = DEVICE_TYPE_UF2200
        }
        SharedRfidSupervision.sharedManager.getRfidSuite().open(self.deviceType)
        let options=[KOP_LOG_LEVEL:getLogLevel(),KOP_LOG_OUTPUT:getLogOutput(),KOP_ZERO_FIRE:1]
        SharedRfidSupervision.sharedManager.getRfidSuite().setOptions(options)
        
        //保存されているBlootoothアドレスを取り込む
        if let blueAdress = userDefaults.string(forKey: CFG_BD_ADRESS) {
            print("Saved device information=\(blueAdress)")
            
            if self.deviceType == DEVICE_TYPE_UF3000 {
                //接続の実施（前回接続実績がある場合のみ）
                if blueAdress.count>0 {
                    ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
                        //BLEリストの検出待ち時間
                        Thread.sleep(forTimeInterval: 1.0)
                        
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            self.connectDevice(targetDevice: blueAdress)
                        })
                    })
                }
                return;
            }
            
            //接続の実施（前回接続実績がある場合のみ）
            if blueAdress.count>0 {
                connectDevice(targetDevice: blueAdress)
            }
        }
    }
    
    /** View が表示される直前に呼ばれるメソッド
     ロード後、viewDidLoadの後に呼ばれる
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isMineDisp=true
        //  通知受信の設定
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(applicationDidEnterBackground), name: Notification.Name(rawValue:NOTIF_applicationDidEnterBackground), object: nil)
        nc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: Notification.Name(rawValue:NOTIF_applicationWillEnterForeground), object: nil)
        print("ViewController viewWillAppear")
    }
    
    /** viewWillAppearの後に呼ばれる */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ViewController viewDidLayoutSubviews")
    }
    
    /** viewDidLayoutSubviewsの後に呼ばれる */
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController viewDidAppear")
        //初期表示用の画面オブジェクトサイズ指定（初期はレベル0にしておく)
        self.batteryLevelView.frame = CGRect(x:self.batteryLevelView.frame.origin.x,
                                             y:self.batteryLevelView.frame.origin.y,
                                             width:0,
                                             height:self.batteryLevelView.frame.size.height)
        showBatteryLevel()
        
        
        //ここから以下は、デバイス接続画面で更新された内容を画面に反映する為の処理
        if let device = UserDefaults.standard.string(forKey: DEVICE_TYPE_KEY) {
            self.deviceType = device
        }
        
        // 共有データから現在のデバイス接続状態を取得
        let connectState:String = SharedData.sharedManager.getDataForKey(aKey: CONNECT_STATE)
        if (Int(connectState) == Int(CNS_ON)) {
            print("connectState=\(connectState)" )
            //接続に成功している
            
            //保存されているBlootoothアドレスを取り込む（接続画面にて、設定ファイルへ保存される）
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                let userDefaults = UserDefaults.standard
                if let blueAdress = userDefaults.string(forKey: CFG_BD_ADRESS) {
                    if self.deviceType == DEVICE_TYPE_UF2200 || (self.deviceType == DEVICE_TYPE_UF3000 && blueAdress.count == BT_MAC_ADRESS_LEN && ToolCommon.isMatchInputRule(target: blueAdress, expression: REGEX_HEX_NOLIMIT)) {
                        self.deviceAdressTextField.text = ToolCommon.BTAdressEasyToSee(adress: blueAdress)
                    }
                    else {
                        self.deviceAdressTextField.text = blueAdress
                    }
                }
            })

            //デバイス選択画面で再接続したか、フラグを確認する
            //もし再接続していたら、バージョンの取り込みを行う
            if SharedData.sharedManager.getDataForKey(aKey: "DevSelConnect") == RECONNECT_ON {
                print("デバイス選択画面で、接続されたので、再度バージョンを取り込みます")
                SharedData.sharedManager.removeDataForKey(aKey: "DevSelConnect")
                SharedData.sharedManager.setData(anObject: "", aKey: FW_VER)
                self.firmVerTextField.text = ""
                
                updateFirmVer(callback: {(_resultCode)-> Void in
                    if _resultCode != OPOS_SUCCESS {
                        self.showAlert(title: "エラー",message: "バージョン取得に失敗しました")
                    }
                })
            }
            
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                //画面上のボタンは有効にする
                self.buttonsEnable(enabled: true)
            })
            
            //バッテリー更新タイマーを開始する
            startBatteryTimer()
        } else{
            //接続に失敗しているので、画面上のボタンはディセーブル状態にする
            buttonsEnable(enabled: false)
        }
        
        super.viewDidAppear(animated)
    }

    /** Viewが表示されなくなる直前に呼ばれるメソッド
     ※ちなみにホームボタンでバックグラウンドにいった時はコールされない
     */
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController viewWillDisappear")
        
        //バッテリー更新タイマーを停止する(動いていたら）
        if timerBattery.isValid {
            print("バッテリー更新タイマーを停止する")
            //タイマーの停止
            timerBattery.invalidate()
        }
        
        //バッテリー表示をクリアする（これしないと、画面が他画面から戻ってきたときに、古い情報が残ったままになる為）
        hiddenBatteryLevel()
        isMineDisp=false
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -通知関連
    /** デバイス切断通知を受ける場所（外部より） */
    @objc func _deviceOfflineNotification(notification:NSNotification) {
        print("_deviceOfflineNotification")
        deviceTurnOffline()
    }
    
    /** デバイスが再接続された通知を受ける場所（外部より）*/
    @objc func _deviceOnlineNotification(notification:NSNotification) {
        print("_deviceOnlineNotification")
        deviceTurnOnline()
    }
    
    /** デバイスが切断状態になった時に動かす処理 */
    func deviceTurnOffline() {
        SharedData.sharedManager.setData(anObject: CNS_OFF, aKey: CONNECT_STATE)
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            
            //ボタンを押せないようにする
            self.buttonsEnable(enabled: false)
            //バッテリー更新タイマーを停止する(動いていたら）
            if self.timerBattery.isValid  {
                print("バッテリー更新タイマーを停止する")
                //タイマーの停止
                self.timerBattery.invalidate()
                ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
                    print("バッテリー処理キュー終了待ち start")
                    _ = self.dispatchGroupBattery.wait(timeout: .distantFuture)
                    print("バッテリー処理キュー終了待ち end")
                    ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                        self.hiddenBatteryLevel()//バッテリー表示をクリアする
                    })
                })
            }else {
                //バッテリー表示をクリアする
                self.hiddenBatteryLevel()
            }
            //アラート表示
            self.present(self.alertDeviceDisconnect, animated: true, completion: nil)
        })
        
    }
    
    /** デバイスが切断状態から復帰した際に呼び出される */
    func deviceTurnOnline() {
        
        SharedData.sharedManager.setData(anObject: CNS_ON, aKey: CONNECT_STATE)
        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
            
            //切断アラートをしまう
            self.alertDeviceDisconnect.dismiss(animated: false, completion: nil)
            //ボタンを押せるようにする
            self.buttonsEnable(enabled: true)
            //もし、接続再開のタイミングで、バージョンが取り込まれていなかったら、取り込み処理を行う
            if self.verGetFailure {
                self.updateFirmVer(callback: {(_resultCode)-> Void in
                    if _resultCode == OPOS_SUCCESS {
                        self.verGetFailure=false
                    }
                })
            }
            
            //バッテリー更新タイマーを開始する
            if self.isMineDisp && SharedRfidSupervision.sharedManager.getRfidSuite().deviceEnabled {
                self.startBatteryTimer()
                //バッテリーレベル領域の表示
                self.showBatteryLevel()
            }
        })
    }
    
    /** アプリが非アクティブになりバックグラウンド実行になった際に呼び出される*/
    @objc func applicationDidEnterBackground() {
        print("ViewController applicationDidEnterBackground")
    }
    
    /** 2回目以降のフォアグラウンド実行になった際に呼び出される(Backgroundにアプリがある場合)*/
    @objc func applicationWillEnterForeground() {
        print("ViewController applicationWillEnterForeground")
    }
    
    // MARK: -表示処理
    /** バッテリーレベルを非表示にする
     対象は、グラフとラベル
     */
    func hiddenBatteryLevel() {
        //コントロールの非表示
        self.batteryLevelView.isHidden=true
        self.batteryLevelLabel.isHidden=true
        
        //次、ハイドが解除された時、ゴミデータが残らないようにレベルとキャプションをきれいにしておく
        //レベル0
        self.batteryLevelView.frame = CGRect(x: self.batteryLevelView.frame.origin.x, y: self.batteryLevelView.frame.origin.y, width: 0, height: self.batteryLevelView.frame.size.height)
        //パーセンテージキャプションを削除
        self.batteryLevelLabel.text = ""
    }
    
    /** バッテリーレベルを表示する*/
    func showBatteryLevel() {
        //コントロール類の表示
        self.batteryLevelView.isHidden=false
        self.batteryLevelLabel.isHidden=false
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
    
     // MARK: -内部メソッド
    /** バッテリー更新処理を開始させる */
    func startBatteryTimer() {
        //既にタイマー開始中なら何もやることは無い
        if timerBattery.isValid {
            return
        }
        print("バッテリー更新タイマーを開始する")

        //タイマーって、最初の一発目が、インターバル後からfireされるので、最初の一発目だけは手動でキックをかける
        kickBatteryQueue()
        
        //タイマーを開始させる
        timerBattery = Timer.scheduledTimer(timeInterval: TimeInterval(getBatteryTimerInterval()), target: self, selector: #selector(timeupBattery), userInfo: nil, repeats: true)
    }
    
    /** バッテリー表示更新タイマータイムアップ */
    @objc func timeupBattery(timer:Timer) {
        print("timeupBattery")
        kickBatteryQueue()
    }
    
    /** バッテリーの更新処理を、直列キューに入れる */
    func kickBatteryQueue() {
        //既にキューが走っているのでやる必要なし
        if dispatchGroupBattery.wait(wallTimeout: .now()) != DispatchTimeoutResult.success {
            return
        }
            print("キューに無いので、処理を開始する")
        dispatchGroupBattery.enter()
        dispatchQueueBattery.async(group: dispatchGroupBattery) {
            print("dispatchQueueBattery async start")
            
            //バッテリーレベルの取り込み
            let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
            if SharedRfidSupervision.sharedManager.getRfidSuite().getBatteryLevel({(level,resultCode,resultCodeExtended) -> Void in
                semaphore.signal()
                
                if resultCode != OPOS_SUCCESS {
                    print("GetBatteryLevelコールバックで失敗 resultCode=\(resultCode) resultCodeExtended=\(resultCodeExtended)")
                    return
                }
                
                //画面更新処理
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //バッテリーレベルグラフ
                    let batteryLevel:CGFloat = CGFloat((Int(level)*BATTERY_WIDTH)/100)
                    UIView.animate(withDuration: 0.4, animations: { () -> Void in
                        if #available(iOS 13.0, *) {
                            self.constraintbatteryHeight.constant = batteryLevel
                            self.view.layoutIfNeeded()
                        }
                        else {
                            self.batteryLevelView.frame = CGRect(x:self.batteryLevelView.frame.origin.x,
                                                                 y:self.batteryLevelView.frame.origin.y,
                                                                 width:batteryLevel,
                                                                 height:self.batteryLevelView.frame.size.height)
                        }
                    })
                    
                    //バッテリーレベルパーセンテージラベルの更新
                    UIView.animate(withDuration: 0.2, animations: {
                        //だんだん薄くする
                        self.batteryLevelLabel.alpha = 0.0
                    }, completion: { finished in
                        //薄くなったタイミングで、ラベル更新
                        self.batteryLevelLabel.text = String(format:"%d%%", level)
                        //ラベルの透過度をだんだん高くしてゆく
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            self.batteryLevelLabel.alpha = 1.0
                        })
                    })
                })
                
            }) != OPOS_SUCCESS {
                print("GetBatteryLevel実行で失敗")
                return
            }
            print("GetBatteryLevelのコールバック待ち start")
            if (semaphore.wait(timeout:.distantFuture) == .success) {
                print("待機解除")
            }
            print("GetBatteryLevelのコールバック待ち end")
            self.dispatchGroupBattery.leave()
            print("dispatchQueueBattery async end")
        }
    }

    /** デバイス接続。成功時、バージョン取得もやって、完了。 */
    func connectDevice(targetDevice:String) {
        //クルクルアイコン　アニメーション開始
        indicatorView.startAnimating()

        //画面操作無効
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        //接続とバージョン取得を行うメソッドを呼び出す
        connectDeviceAndVerRead(targetDevice: targetDevice as String, callback: {(_resultCode)-> Void in
            //接続と、バージョン取得
            if _resultCode == OPOS_SUCCESS {//全成功
                //アニメーションの停止と画面操作有効or無効
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //アニメーション停止
                    self.indicatorView.stopAnimating()
                    //画面操作有効
                    self.navigationController?.view.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                })
                return
            }else if _resultCode == 2 {//接続成功だが、バージョン取得失敗
                
                self.verGetFailure=true//起動時、バージョンの取得に失敗した。オンラインに変化したタイミングで再度取得させる
                
                self.showAlert(title: "エラー",message: "バージョン取得に失敗しました")
                //アニメーションの停止と画面操作有効or無効
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //アニメーション停止
                    self.indicatorView.stopAnimating()
                    //画面操作有効
                    self.navigationController?.view.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                })
                return
            }
            
            if self.deviceType == DEVICE_TYPE_UF3000 {
                //アニメーションの停止と画面操作有効or無効
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //アニメーション停止
                    self.indicatorView.stopAnimating()
                    //画面操作有効
                    self.navigationController?.view.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                    self.showAlert(title: "エラー",message: "接続に失敗しました")
                })
                return
            }
            
            //一度の接続失敗は、チャレンジする
            //接続失敗時、ペアリングされていないが、周辺にあるBluetoothデバイスに繋いでみる
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: {(error) -> Void in
                    if let err:NSError = error as NSError? {
                        print("showBluetoothAccessoryPicker error=\( err.localizedDescription)")
                        //キャンセルが押された
                        self.showAlert(title: "エラー",message: "接続に失敗しました")
                        //アニメーションの停止と画面操作有効or無効
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            //アニメーション停止
                            self.indicatorView.stopAnimating()
                            //画面操作有効
                            self.navigationController?.view.isUserInteractionEnabled = true
                            self.view.isUserInteractionEnabled = true
                        })
                        return
                    }
                    
                    //何か接続を選択されたので、再接続実施
                    self.connectDeviceAndVerRead(targetDevice: targetDevice, callback: {(_resultCode)-> Void in
                        var errMsg = ""
                        if _resultCode == 1 {
                            errMsg = "接続に失敗しました"
                        } else if _resultCode == 2 {
                            errMsg = "バージョン取得に失敗しました"
                            self.verGetFailure = true//起動時、バージョンの取得に失敗した。オンラインに変化したタイミングで再度取得させる
                        }
                        
                        if errMsg.count > 0 {
                            self.showAlert(title: "エラー",message: errMsg as String)
                        }
                        //アニメーションの停止と画面操作有効or無効
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            //アニメーション停止
                            self.indicatorView.stopAnimating()
                            //画面操作有効
                            self.navigationController?.view.isUserInteractionEnabled = true
                            self.view.isUserInteractionEnabled = true
                        })
                    })
                    })
                })
        })
    }
    
    /**
     //デバイスへ接続 & バージョンリード
     //戻り値
     // 0:接続&バージョン取得成功
     // 1:接続失敗
     // 2:バージョン取得失敗
     */
    func connectDeviceAndVerRead(targetDevice:String,callback:((_ resultCode:Int)-> Void)?) {
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            //ライブラリに対して非同期で接続要求を投げる
            let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
            var retVal:Int32 = SharedRfidSupervision.sharedManager.getRfidSuite().claimDevice(targetDevice as String?, callback: {state in
                print("ConnectState Callback state=\(state.rawValue)")
                //もし、オフラインに変化したら、操作無効にする
                if (state.rawValue) == ConnectState.offline.rawValue{//deviceTurnOnline
                    print("ConnectState Callback Offline")
                    self.deviceTurnOffline()
                    
                }else if (state.rawValue) == ConnectState.online.rawValue {//deviceTurnOffline
                    print("ConnectState Callback Online")
                    semaphore.signal()
                    self.deviceTurnOnline()
                }
            })
            if(retVal != OPOS_SUCCESS) {
                semaphore.signal()
            }
            
            if semaphore.wait(timeout:.now() + 6.000) == .timedOut {
                retVal = OPOS_E_TIMEOUT
            }
            
            if retVal == OPOS_SUCCESS {
                //接続成功
                SharedRfidSupervision.sharedManager.getRfidSuite().deviceEnabled = true
                SharedData.sharedManager.setData(anObject: CNS_ON, aKey: CONNECT_STATE)
                
                ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
                    //機種判定
                    var ret:Int32 = 0
                    ret = SharedRfidSupervision.sharedManager.getRfidSuite().enableModelCheckProperty({(resultCode,resultCodeExtended) -> Void in
                        if resultCode != OPOS_SUCCESS {
                            self.showAlert(title: "エラー", message: "機種判定に失敗しました。")
                        }
                        else {
                            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                                if self.deviceType == DEVICE_TYPE_UF2200 || (self.deviceType == DEVICE_TYPE_UF3000 && targetDevice.count == BT_MAC_ADRESS_LEN && ToolCommon.isMatchInputRule(target: targetDevice, expression: REGEX_HEX_NOLIMIT)) {
                                    self.deviceAdressTextField.text = ToolCommon.BTAdressEasyToSee(adress: targetDevice)
                                }
                                else {
                                    self.deviceAdressTextField.text = targetDevice
                                }
                                //画面上のボタンは有効にする
                                self.buttonsEnable(enabled: true)
                            })
                        }
                    })
                    if ret != OPOS_SUCCESS {
                        self.showAlert(title: "エラー", message: "機種判定に失敗しました。")
                    }
                })
                
                //バッテリー更新タイマーを開始する
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.startBatteryTimer()
                })
                
                //ファームバージョンも取り込む
                self.updateFirmVer(callback: {(_resultCode)-> Void in
                    if _resultCode == OPOS_SUCCESS {
                        ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                            if let connectCallback = callback {
                                connectCallback(0)//成功
                            }
                        })
                    } else {
                        if let connectCallback = callback {
                            connectCallback(2)//接続成功。バージョン取得失敗
                        }
                    }
                })
            } else {
                print("接続失敗　エラーコード＝\(retVal)")
                SharedData.sharedManager.setData(anObject: CNS_OFF, aKey: CONNECT_STATE)
                if let connectCallback = callback {
                    connectCallback(1)//接続失敗
                }
            }
        })
    }
    
    /** デバイス接続ボタン以外の４個のボタンの状態を、イネーブルにしたりディセーブルにしたり切り替えを行う */
    func buttonsEnable(enabled:Bool) {
        self.settingsButton.isEnabled = enabled
        self.readButton.isEnabled = enabled
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableScanner == Int32(ScannerDecision.AvailableScanner.rawValue) {
            self.barcodeButton.isEnabled = enabled
        }
        else {
            self.barcodeButton.isEnabled = false
        }
    }
    
    /** ファームバージョンを取得して、画面に表示する */
    func updateFirmVer(callback:((_ resultCode:Int32)-> Void)?) {
        
        let retVal:Int32 = SharedRfidSupervision.sharedManager.getRfidSuite().getFirmwareVer({(firmVer,resultCode,resultCodeExtended) -> Void in
            if resultCode != OPOS_SUCCESS {
                print("FWバージョン取得コールバックに失敗　エラーコード＝\(resultCode)")
                if let updateCallback = callback {
                    updateCallback(resultCode)
                }
                return
            }
            
            //共有データの更新
            SharedData.sharedManager.setData(anObject: firmVer!, aKey: FW_VER)
            //画面更新
            ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                //画面表示用に短くする
                let shortVer:NSMutableString = NSMutableString()
                ToolCommon.convertVersionToShort(fullVer:firmVer!, resultShortVer: shortVer)
                self.firmVerTextField.text = shortVer as String
                if let updateCallback = callback {
                    updateCallback(OPOS_SUCCESS)
                }
            })
        })
        
        if retVal != OPOS_SUCCESS {
            if let updateCallback = callback {
                updateCallback(retVal)
            }
        }
    }

    /** バッテリータイマーインターバル取得 */
    func getBatteryTimerInterval()->Float {
        let userDefaults = UserDefaults.standard
        if let stringBatteryTimerInterval = userDefaults.string(forKey: "BatteryTimerInterval") {
            let intBatteryTimerInterval = Int(stringBatteryTimerInterval)
            let floatBatteryTimerInterval:Float = Float(intBatteryTimerInterval!/1000)
            return floatBatteryTimerInterval
        }
        return 0
    }
    
    /** ログレベル取得 */
    func getLogLevel()->Int {
        let userDefaults = UserDefaults.standard
        let boolLogFileOutput = userDefaults.bool(forKey: "LogFileOutput")
        let boolLogConsolOutput = userDefaults.bool(forKey: "LogConsolOutput")
        var intLogLevel = 0
        if let stringLogLevel = userDefaults.string(forKey: "LogLevel") {
            intLogLevel = Int(stringLogLevel)!
        }
        return (!boolLogFileOutput && !boolLogConsolOutput) ? 0 : intLogLevel
    }

    /** ログ出力設定取得 */
    func getLogOutput()->Int {
        let userDefaults = UserDefaults.standard
        let boolLogFileOutput = userDefaults.bool(forKey: "LogFileOutput")
        let boolLogConsolOutput = userDefaults.bool(forKey: "LogConsolOutput")
        if boolLogFileOutput && boolLogConsolOutput {
            return 0
        }
        else if boolLogConsolOutput
        {
            
            return 1
        }
        else if boolLogFileOutput
        {
            return 2
        }
        return 0
    }

}

