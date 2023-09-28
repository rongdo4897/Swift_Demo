//
//  ToolCommon.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/20.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved
//

import Foundation
import UIKit
let JP1 = "JP1"
let JP2 = "JP2"
let JP3 = "JP3"
let JP4 = "JP4"
let JP5 = "JP5"
let JP6 = "JP6"
//入力規則チェックで使用する正規化表現
let REGEX_HEX_NOLIMIT = "^[0-9|A-F|a-f]*$"        //16進数値のみ、桁数制限なし

class ToolCommon: NSObject {
    /** 長ったらしいバージョン情報を、画面表示に適したショート表示用に切り詰める */
    class func convertVersionToShort(fullVer:String,resultShortVer:NSMutableString) {
        //0         1         2         3         4         5         6         7         8         9         10
        //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
        //d:"TEC UHF RFID UF-2200             JP1 Z#00C2014-03-06",x:"R2000 rev 00A0 0",y:"RFID1 Z#00  sppi_v2.04"
        resultShortVer.append(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]))
        resultShortVer.append(" ")
        resultShortVer.append(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 40)..<fullVer.index(fullVer.startIndex, offsetBy: 45)]))
        resultShortVer.append(" ")
        resultShortVer.append(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 93)..<fullVer.index(fullVer.startIndex, offsetBy: 103)]))
    }
    
    /** バージョン情報から、機種（特定省電力 or 登録局)を判断する
         YES:特定省電力 / NO:登録局
     */
    class func isEcoFromVer(fullVer:String)->Bool {
        //バージョン取得未完了の時は、特定省電力モードとする
        if fullVer.count == 0 {
            print("バージョン取得未完了にて、特定省電力とする")
            return true
        }
        
        //JP1:特定省電力 JP2:免許局 JP3:登録局
        if (String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == "JP1") {
            return true
        }
        return false
    }
    
    /** 指定した処理を、メインスレッドで実行させる */
    class func mainThreadSync(syncProgram: (() -> Void)?) {
        //もともとメインスレッドで実行されている場合はそのまま（これをせずにやみくもにdispatch_syncでやるとデッドロックする）
        if Thread.isMainThread {
            if let callback = syncProgram {
                callback()
            }
            return
        }
        
        //もし、サブスレッドから実行されている場合はメインスレッドから実行を行う
        DispatchQueue.main.sync {() in
            if let callback = syncProgram {
                callback()
            }
        }
    }
    
    /** 別スレッドで非同期実行 */
    class func globalThreadAsync(asyncProgram:(() -> Void)?) {
        DispatchQueue.global(qos:DispatchQoS.QoSClass.default).async {() in
            if let callback = asyncProgram {
                callback()
            }
        }
    }
    
    /** クルクルアイコンを生成して画面に割り付ける */
    class func addSpinIndicator(selfViewContr:UIViewController)->UIActivityIndicatorView {
        //クルクルアイコンを画面に割り付けておく
        let indView:UIActivityIndicatorView = UIActivityIndicatorView()
        indView.activityIndicatorViewStyle = .whiteLarge
        indView.color = .red
        let statusBarBounds = UIApplication.shared.statusBarFrame
        var statusBarHeight:CGFloat
        let navigationBarBounds = selfViewContr.navigationController?.navigationBar.bounds
        if let navigationBarHeight = navigationBarBounds?.size.height {
            statusBarHeight = statusBarBounds.size.height
            indView.center.x = selfViewContr.view.center.x
            indView.center.y = selfViewContr.view.center.y-(statusBarHeight+navigationBarHeight)
            print("statusBarHeight=\(statusBarHeight)")
        }
        selfViewContr.view.addSubview(indView)// 現在のサブビューとして登録する
        
        return indView
    }
    
    /** キーボード出現により、動かすべきY座標の量を求める */
    class func calcKeyboardMoveOffsetWithScroll(selfViewContr:UIViewController,userInfo:Dictionary<String, Any>,textControl:UIControl,scrollView:UIScrollView)->Float {
        let screenOrientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        let screenBounds = UIScreen.main.bounds
        var screenHeight:CGFloat
        let statusBarBounds = UIApplication.shared.statusBarFrame
        var statusBarHeight:CGFloat
        let navigationBarBounds = selfViewContr.navigationController?.navigationBar.bounds
        
        var moveOffset:Float = 0
        // キーボードの表示完了時の場所と大きさを取得。
        if let navigationBarHeight = navigationBarBounds?.size.height {
            if let keyboardFrameEndBounds:CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect{
                var keyboardFrameEndHeight:CGFloat
                if  screenOrientation.isPortrait {
                    screenHeight = screenBounds.size.height
                    statusBarHeight = statusBarBounds.size.height
                    keyboardFrameEndHeight = keyboardFrameEndBounds.size.height
                }
                else {
                    screenHeight = screenBounds.size.width
                    statusBarHeight = statusBarBounds.size.width
                    keyboardFrameEndHeight = keyboardFrameEndBounds.size.width
                }
                print("screenHeight=\(screenHeight)")
                print("statusBarHeight=\(statusBarHeight)")
                print("navigationBarHeight=\(navigationBarHeight)")
                print("キーボードの高さ=\(keyboardFrameEndHeight)")
                
                let textFieldPosY = textControl.frame.origin.y
                print("現在のテキストボックスの位置=\(textFieldPosY)")
                
                let textFieldHeight = textControl.frame.size.height
                print("現在のテキストボックスの高さ=\(textFieldHeight)")
                
                let scrollOffsetY = scrollView.contentOffset.y
                print("スクロールのオフセット量=\(scrollOffsetY)")
                
                //現在、テキストボックスがどこに表示されているか計算する。
                let dispPoint = (statusBarHeight+navigationBarHeight) + (textFieldPosY-scrollOffsetY) + textFieldHeight
                print("disoPoint=\(dispPoint)")
                
                //テキストボックスが、キーボードによって隠れてしまうかジャッジする
                if ((screenHeight - keyboardFrameEndHeight) > dispPoint) {
                    print("テキストボックスは、隠れない")
                    return 0
                }
                
                //どれだけずらすか計算する
                moveOffset = Float(dispPoint - (screenHeight - keyboardFrameEndHeight))
                print("moveOffset=\(moveOffset)")
                
                
                //もし、見切れている場合は、見切れない状態まで持ってゆく
                if dispPoint>screenHeight {
                    print("見切れています。その量=\(dispPoint-screenHeight)")
                    scrollView.contentOffset = CGPoint(x:scrollView.contentOffset.x, y:scrollView.contentOffset.y+(dispPoint-screenHeight))
                    moveOffset -= Float(dispPoint-screenHeight)
                }
            }
        }
        return Float(moveOffset)
    }
    
    /** Settings.bundle(Root.plist)の情報に、NSUserDefaultsの未設定デフォルトを合わせ込む */
    class func registerDefaultsFromSettingsBundle(plist:String) {
        // 設定アプリのデータにアクセスするために、NSUserDefaultsを作成
        let defs = UserDefaults.standard
        defs.synchronize()
        if let settingsBundle:URL = Bundle.main.url(forResource: "Settings", withExtension: "bundle")?.appendingPathComponent("Root.plist") {
            // Setting.bundle 内の指定の plist の情報を取得
            if let settings = NSDictionary(contentsOf:settingsBundle) {
                // 指定した plist 内の PreferenceSpecifiers の情報を取得
                if let preferences:NSArray = settings.object(forKey: "PreferenceSpecifiers") as? NSArray {
                    // オブジェクトを取得できないもののデフォルト値を格納する Dictionary を作成
                    var defaultsToRegister = Dictionary<String, Any>()
                    
                    // preferences に格納されている情報の数だけループを回す
                    for item in preferences {
                        if let prefSpecification = item as? NSDictionary {
                            if let key = prefSpecification.object(forKey: "Key") as? String {
                                if let currentObject = defs.object(forKey: key) {
                                    print("key=\(key) data=\(currentObject)")
                                }
                                else {
                                    // アクセスできない場合は、そのキーとデフォルト値を defaultsToRegister に登録する
                                    let objectToSet = prefSpecification.object(forKey: "DefaultValue")
                                    defaultsToRegister[key] = objectToSet
                                }
                            }
                        }
                    }
                    // アクセスできないデフォルト値を UserDefaults に登録する
                    defs.register(defaults: defaultsToRegister)
                    defs.synchronize()
                }
            }
        }
    }
    
    /** BTアドレスを見やすいように整形する*/
    class func BTAdressEasyToSee(adress:String)->String {
        let BTAdress:String
        if adress.count < BT_MAC_ADRESS_LEN {
            return ""
        }
        //大文字で、左から12文字のアドレス部分を切り出す
        let adressCut = adress.prefix(BT_MAC_ADRESS_LEN).uppercased()
        //2文字ずつ切り出して、:を付加する
        let ansStr:NSMutableString = NSMutableString()
        for i in stride(from: 0, to: adressCut.count, by: 2) {
            ansStr.append(String(adressCut[adressCut.index(adressCut.startIndex, offsetBy: i)..<adressCut.index(adressCut.startIndex, offsetBy: i+2)]))
            ansStr.append(":")
        }
        ansStr.deleteCharacters(in: NSMakeRange(ansStr.length-1, 1))//余計に付加してしまった:を削除
        BTAdress = ansStr as String

        return BTAdress
    }
    //#087 ADD Start
    /**
     読取識別番号テーブル取得
     
     return 読取識別番号テーブル
     */
    class func getMisreadingPreventionSettingsTable() -> NSArray{
        //ここに読取識別番号テーブル本体を作成
        return [
        //readingID, PP1  ,PCWD7-0
            [   0, 0x00000, 0x00],
            [   1, 0x20400, 0x01],
            [   2, 0x20400, 0x02],
            [   3, 0x20400, 0x03],
            [   4, 0x20400, 0x05],
            [   5, 0x20400, 0x06],
            [   6, 0x20400, 0x07],
            [   7, 0x20400, 0x08],
            [   8, 0x20400, 0x09],
            [   9, 0x20400, 0x0A],
            [  10, 0x20400, 0x0B],
            [  11, 0x20400, 0x0D],
            [  12, 0x20400, 0x0E],
            [  13, 0x10200, 0x01],
            [  14, 0x10200, 0x05],
            [  15, 0x10200, 0x06],
            [  16, 0x10200, 0x07],
            [  17, 0x10200, 0x08],
            [  18, 0x10200, 0x09],
            [  19, 0x10200, 0x0D],
            [  20, 0x10200, 0x0E],
            [  21, 0x10300, 0x01],
            [  22, 0x10300, 0x02],
            [  23, 0x10300, 0x03],
            [  24, 0x10300, 0x05],
            [  25, 0x10300, 0x06],
            [  26, 0x10300, 0x07],
            [  27, 0x10300, 0x08],
            [  28, 0x10300, 0x09],
            [  29, 0x10300, 0x0A],
            [  30, 0x10300, 0x0B],
            [  31, 0x10300, 0x0D],
            [  32, 0x10300, 0x0E],
            [  33, 0x20200, 0x05],
            [  34, 0x20200, 0x06],
            [  35, 0x20200, 0x07],
            [  36, 0x20200, 0x0D],
            [  37, 0x20200, 0x0E],
            [  38, 0x20300, 0x05],
            [  39, 0x20300, 0x06],
            [  40, 0x20300, 0x07],
            [  41, 0x20300, 0x0D],
            [  42, 0x20300, 0x0E],
            [  43, 0x30200, 0x05],
            [  44, 0x30200, 0x06],
            [  45, 0x30200, 0x0D],
            [  46, 0x30200, 0x0E],
            [  47, 0x20000, 0x01],
            [  48, 0x20000, 0x02],
            [  49, 0x20000, 0x03],
            [  50, 0x20000, 0x04],
            [  51, 0x20000, 0x05],
            [  52, 0x20000, 0x06],
            [  53, 0x20000, 0x07],
            [  54, 0x20000, 0x08],
            [  55, 0x20000, 0x09],
            [  56, 0x20000, 0x0A],
            [  57, 0x20000, 0x0B],
            [  58, 0x20000, 0x0C],
            [  59, 0x20000, 0x0D],
            [  60, 0x20000, 0x0E],
            [  61, 0x30300, 0x05],
            [  62, 0x30300, 0x06],
            [  63, 0x30300, 0x0D],
            [  64, 0x30300, 0x0E],
            [  65, 0x20400, 0x0F],
            [  66, 0x20400, 0x10],
            [  67, 0x20400, 0x11],
            [  68, 0x20400, 0x12],
            [  69, 0x20400, 0x13],
            [  70, 0x20400, 0x15],
            [  71, 0x20400, 0x16],
            [  72, 0x20400, 0x17],
            [  73, 0x20400, 0x18],
            [  74, 0x20400, 0x19],
            [  75, 0x20400, 0x1A],
            [  76, 0x20400, 0x1B],
            [  77, 0x20400, 0x1D],
            [  78, 0x20400, 0x1E],
            [  79, 0x20400, 0x1F],
            [  80, 0x10200, 0x0F],
            [  81, 0x10200, 0x10],
            [  82, 0x10200, 0x11],
            [  83, 0x10200, 0x15],
            [  84, 0x10200, 0x16],
            [  85, 0x10200, 0x17],
            [  86, 0x10200, 0x18],
            [  87, 0x10200, 0x19],
            [  88, 0x10200, 0x1A],
            [  89, 0x10200, 0x1D],
            [  90, 0x10200, 0x1E],
            [  91, 0x10200, 0x1F],
            [  92, 0x10300, 0x0F],
            [  93, 0x10300, 0x10],
            [  94, 0x10300, 0x11],
            [  95, 0x10300, 0x12],
            [  96, 0x10300, 0x13],
            [  97, 0x10300, 0x15],
            [  98, 0x10300, 0x16],
            [  99, 0x10300, 0x17],
            [ 100, 0x10300, 0x18],
            [ 101, 0x10300, 0x19],
            [ 102, 0x10300, 0x1A],
            [ 103, 0x10300, 0x1B],
            [ 104, 0x10300, 0x1D],
            [ 105, 0x10300, 0x1E],
            [ 106, 0x10300, 0x1F],
            [ 107, 0x20200, 0x0F],
            [ 108, 0x20200, 0x15],
            [ 109, 0x20200, 0x16],
            [ 110, 0x20200, 0x17],
            [ 111, 0x20200, 0x1D],
            [ 112, 0x20200, 0x1E],
            [ 113, 0x20200, 0x1F],
            [ 114, 0x20300, 0x15],
            [ 115, 0x20300, 0x16],
            [ 116, 0x20300, 0x1D],
            [ 117, 0x20300, 0x1E],
            [ 118, 0x30200, 0x15],
            [ 119, 0x30200, 0x16],
            [ 120, 0x30200, 0x1D],
            [ 121, 0x30200, 0x1E],
            [ 122, 0x20000, 0x0F],
            [ 123, 0x20000, 0x10],
            [ 124, 0x20000, 0x11],
            [ 125, 0x20000, 0x12],
            [ 126, 0x20000, 0x13],
            [ 127, 0x20000, 0x14],
            [ 128, 0x20000, 0x15],
            [ 129, 0x20000, 0x16],
            [ 130, 0x20000, 0x17],
            [ 131, 0x20000, 0x18],
            [ 132, 0x20000, 0x19],
            [ 133, 0x20000, 0x1A],
            [ 134, 0x20000, 0x1B],
            [ 135, 0x20000, 0x1C],
            [ 136, 0x20000, 0x1D],
            [ 137, 0x20000, 0x1E],
            [ 138, 0x20000, 0x1F],
            [ 139, 0x30300, 0x15],
            [ 140, 0x30300, 0x16],
            [ 141, 0x30300, 0x1D],
            [ 142, 0x30300, 0x1E]
        ]
    }
    
    /** 排他処理 */
    class func synchronized(obj: AnyObject, closure: () -> Void) {
        objc_sync_enter(obj)
        closure()
        objc_sync_exit(obj)
    }
    
    /** ログレベル取得 */
    class func getLogLevel()->Int {
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
    class func getLogOutput()->Int {
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
    
    //バージョン情報から、機種（特定省電力 or 登録局 or 免許局)を判断する
    //JP1:特定省電力 JP2:免許局 JP3:登録局
    class func checkModel(fullVer:String)->String {
        //JP1:特定省電力 JP2:免許局 JP3:登録局
        if (String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP1) {
            return JP1
        }
        else if(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP2) {
            return JP2
        }
        else if(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP3) {
            return JP3
        }
        else if(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP4) {
            return JP4
        }
        else if(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP5) {
            return JP5
        }
        else if(String(fullVer[fullVer.index(fullVer.startIndex, offsetBy: 36)..<fullVer.index(fullVer.startIndex, offsetBy: 39)]) == JP6) {
            return JP6
        }
        return JP3
    }
    
    /** FWデフォルトの周波数チャネル設定を返す。 */
    class func getFwDefFrequencyAutoList(model:String) -> Array<Any> {
        var deviceType = DEVICE_TYPE_UF2200
        if let device = UserDefaults.standard.string(forKey: DEVICE_TYPE_KEY) {
            deviceType = device
        }
        if (model == JP1 && deviceType == DEVICE_TYPE_UF2200) {
            //特定省電力
            return [NSNumber(value:FrequencyLowChannelType.ch26.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch30.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch28.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch32.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch17.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch11.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch23.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch27.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch29.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch31.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch05.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP)]
        }
        else if(model == JP3 && deviceType == DEVICE_TYPE_UF2200) {
            return [NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch17.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch11.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch23.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch05.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP)]
        }
        else if((model == JP4  && deviceType == DEVICE_TYPE_UF2200) || (model == JP1  && deviceType == DEVICE_TYPE_UF3000)) {
            return [NSNumber(value:FrequencyLowChannelType.ch26.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch28.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch32.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch17.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch11.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch23.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch29.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch31.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch05.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP)]
        }
        else if((model == JP6  && deviceType == DEVICE_TYPE_UF2200) || (model == JP3  && deviceType == DEVICE_TYPE_UF3000)) {
            return [NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch25.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch17.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch11.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch23.rawValue),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FrequencyLowChannelType.ch05.rawValue),
                    NSNumber(value:FrequencyLowChannelType.ch24.rawValue)]
        }
        else {
            return [NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP),
                    NSNumber(value:FREQUENCY_CHANNEL_SKIP)]
        }
    }
    
    /**入力規則チェック処理
        (引数)
     target:チェックを行う文字列
     expression:ルール(正規化表現)
     (戻り値)
     YES:ルールに一致　NO:不一致
     */
    class func isMatchInputRule(target:String,expression:String)->Bool {
        guard let regex =  try?NSRegularExpression(pattern: expression, options:.caseInsensitive) else {return false}
        let numberOfMatches = regex.numberOfMatches(in: target, options: [], range: NSMakeRange(0, target.count))
        if numberOfMatches == 0 {
            return false
        }
        return true
    }
}
