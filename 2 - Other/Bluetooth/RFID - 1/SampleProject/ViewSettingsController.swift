//
//  ViewSettingsController.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
//設定ファイルの拡張子
let SETTING_EXT = ".setting"
//周波数自動用チャネルリスト用ファイル名
let AUTO_CH_LIST_FILE = "AutoFrequencyChannelList.plist"
//設定ファイルのキーとなる文字
let SETTING_KEY_POWER = "Power"
let SETTING_KEY_Q_VALUE = "ValueQ"
let SETTING_KEY_FREQUENCY = "Frequency"
let SETTING_KEY_TRIGGER = "Trigger"
let SETTING_KEY_ENERGY = "EnergySaving"
let SETTING_KEY_TAG_READ_MODE = "TagReadMode"
let SETTING_KEY_FLAG_AB = "FlagAB"
let SETTING_KEY_MISREADING_PREVENTION_SETTINGS = "MisreadingPreventionSettings"

/** タグ読取モード(0)用文言 */
let MILLER2_MEDIUMSPEED = "Miller2:中速"
/** タグ読取モード(1)用文言 */
let MILLER2_HIGHSPEED = "Miller2:高速"
/** タグ読取モード(2)用文言 */
let MILLER4_MEDIUMSPEED = "Miller4:中速"
/** タグ読取モード(3)用文言 */
let MILLER4_HIGHSPEED = "Miller4:高速"
/** タグ読取モード(4)用文言 */
let MILLER8_MEDIUMSPEED = "Miller8:中速"
/** タグ読取モード(5)用文言 */
let MILLER8_HIGHSPEED = "Miller8:高速"

/** 誤読防止機能対応版 タグ読取モード(0)用文言 */
let FM0 = "FM0"
/** 誤読防止機能対応版 タグ読取モード(1)用文言 */
let FM0_MEDIUMSPEED = "FM0:中速"
/** 誤読防止機能対応版 タグ読取モード(2)用文言 */
let MILLER2_LOWSPEED = "Miller2:低速"
/** 誤読防止機能対応版 タグ読取モード(3)用文言 */
//let MILLER2_HIGHSPEED = "Miller2:高速"
/** 誤読防止機能対応版 タグ読取モード(4)用文言 */
let MILLER4_LOWSPEED = "Miller4:低速"
/** 誤読防止機能対応版 タグ読取モード(5)用文言 */
//let MILLER4_HIGHSPEED = "Miller4:高速"
/** 誤読防止機能対応版 タグ読取モード(6)用文言 */
let MILLER8_LOWSPEED = "Miller8:低速"
/** 誤読防止機能対応版 タグ読取モード(7)用文言 */
//let MILLER8_HIGHSPEED = "Miller8:高速"

/** フラグAB(0)用文言 */
let FLAG_AB = "A、B両方"
/** フラグAB(1)用文言 */
let FLAG_A = "Aのみ"
/** フラグAB(2)用文言 */
let FLAG_B = "Bのみ"
/** 三選択肢(A、B両方,Aのみ,Bのみ)表示 */
let FlagABShowall = "1"

/** 設定種別 */
enum ComboMode: Int {
    /** 出力 */
    case ComboModePower
    /** Q値 */
    case ComboModeValueQ
    /** 周波数 */
    case ComboModeFrequency
    /** トリガースイッチ */
    case ComboModeTrigger
    /** タグ読取モード */
    case ComboModeTagReadMode
    /** フラグAB */
    case ComboModeFlagAB
    /** 読取識別番号 */
    case ComboModeMisreadingPreventionSettings
}

/** タグ読取モードのタイプ */
enum TagReadModeType: Int {
    /** タグ読取モード(Miller2:中速) */
    case Miller2MediumSpeedType = 0
    /** タグ読取モード(Miller2:高速) */
    case Miller2HighSpeedType = 1
    /** タグ読取モード(Miller4:中速) */
    case Miller4MediumSpeedType = 2
    /** タグ読取モード(Miller4:高速) */
    case Miller4HighSpeedType = 3
    /** タグ読取モード(Miller8:中速) */
    case Miller8MediumSpeedType = 4
    /** タグ読取モード(Miller8:高速) */
    case Miller8THighSpeedype = 5
}
/** 誤読防止機能対応版 タグ読取モードのタイプ */
enum TagReadModeTypeTruncate: Int{
    /** タグ読取モード(FM0) */
    case T_FM0 = 0
    /** タグ読取モード(FM0:中速) */
    case T_FM0MediumSpeedType = 1
    /** タグ読取モード(Miller2:低速) */
    case T_Miller2LowSpeedType = 2
    /** タグ読取モード(Miller2:高速) */
    case T_Miller2HighSpeedType = 3
    /** タグ読取モード(Miller4:低速) */
    case T_Miller4LowSpeedType = 4
    /** タグ読取モード(Miller4:高速) */
    case T_Miller4HighSpeedType = 5
    /** タグ読取モード(Miller8:低速) */
    case T_Miller8LowSpeedType = 6
    /** タグ読取モード(Miller8:高速) */
    case T_Miller8HighSpeedType = 7
};

class ViewSettingsController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var settingsScroll: UIScrollView!
    @IBOutlet weak var comboPickerView: UIPickerView!
    @IBOutlet weak var powerSelectButton: UIButton!
    @IBOutlet weak var valueQSelectButton: UIButton!
    @IBOutlet weak var frequencySelectButton: UIButton!
    @IBOutlet weak var triggerSelectButton: UIButton!
    @IBOutlet weak var energySavingSwitch: UISwitch!
    @IBOutlet weak var tagReadModeSelectButton: UIButton!
    @IBOutlet weak var flagABSelectButton: UIButton!
    @IBOutlet weak var MisreadingPreventionSettingsButton: UIButton!
    
    /** 出力用テーブル */
    private var POWER_TABLE:Array<String> = []
    /** Q値用テーブル */
    private var VALUE_Q_TABLE:Array<String> = []
    /**  周波数用テーブル */
    private var FREQUENCY_TABLE:Array<String> = []
    /** トリガースイッチ用テーブル */
    private var TRIGGER_SW_TABLE:Array<String> = []
    /** タグ読取モード用テーブル */
    private var TAG_READ_MODE_TABLE:Array<String> = []
    /** フラグAB用テーブル */
    private var FLAG_AB_TABLE:Array<String> = []
    /** 読取識別番号テーブル */
    private var MISREADING_PREVETION_SETTINGS_TABLE:Array<String> = []

    private var POWER_INDEX:Dictionary<String, NSNumber> = [:]
    private var VALUE_Q_INDEX:Dictionary<String, NSNumber> = [:]
    private var FREQUENCY_INDEX:Dictionary<String, NSNumber> = [:]
    private var TRIGGER_SW_INDEX:Dictionary<String, NSNumber> = [:]
    /** タグ読取モード用インデックス */
    private var TAG_READ_MODE_INDEX:Dictionary<String, NSNumber> = [:]
    /** フラグAB用インデックス */
    private var FLAG_AB_INDEX:Dictionary<String, NSNumber> = [:];
    /** 読取識別番号インデックス */
    private var MISREADING_PREVETION_SETTINGS_INDEX:Dictionary<String, NSNumber> = [:]

    private var selectedIndexPower = 0
    private var selectedIndexValueQ = 0
    private var selectedIndexFrequency = 0
    private var selectedIndexTrigger = 0
    private var selectedIndexTagReadMode = 0
    private var selectedIndexFlagAB = 0
    private var selectedIndexMisreadingPreventionSettings = 0

    //逆引き辞書
    private var reversePowerDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseValueQDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseFrequencyDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseTriggerDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseTagReadModeDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseFlagABDictionary:Dictionary<NSNumber, String> = [:]
    private var reverseMisreadingPreventionSettingsDictionary:Dictionary<NSNumber, String> = [:]

    /** クルクルアイコン */
    private var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    private var backupComboFramePosY:CGFloat = 0.0

    var comboMode:ComboMode = ComboMode.ComboModePower//コンボ（ピッカー）動作モード
    var isEcoDevice = false//true:特定省電力 false:登録局
    
    var valEnergy:Int32 = 0
    
    private var model = JP3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(view_Tapped(sender:)))
        // ビューにジェスチャーを追加
        self.view.addGestureRecognizer(tapGesture)
        
        //共有ファームバージョンを、取り込む そして、デバイスの種別を判断する
        let firmVer = SharedData.sharedManager.getDataForKey(aKey: FW_VER)
        isEcoDevice = ToolCommon.isEcoFromVer(fullVer: firmVer)
        model = ToolCommon.checkModel(fullVer: firmVer)
        if isEcoDevice {
            print("この機種は特定省電力です")
        }
        
        
        //定数的要素の定義　※本処理はアタマで行う。なので、この上に処理を書き込むことを禁止する
        //出力値設定
        if (isEcoDevice) {
            //特定省電力用
            POWER_TABLE = ["125mW", "97mW", "75mW", "58mW", "45mW", "35mW", "27mW", "21mW", "16mW", "13mW", "9.8mW", "7.6mW", "5.9mW", "4.6mW", "3.6mW", "2.8mW", "2.1mW", "1.7mW","1.3mW", "1.0mW"]
            
            POWER_INDEX = [POWER_TABLE[0]:NSNumber(value:PowerLowRange.LowRangePower125mW.rawValue),POWER_TABLE[1]:NSNumber(value:PowerLowRange.LowRangePower97mW.rawValue),POWER_TABLE[2]:NSNumber(value:PowerLowRange.LowRangePower75mW.rawValue),POWER_TABLE[3]:NSNumber(value:PowerLowRange.LowRangePower58mW.rawValue),POWER_TABLE[4]:NSNumber(value:PowerLowRange.LowRangePower45mW.rawValue),POWER_TABLE[5]:NSNumber(value:PowerLowRange.LowRangePower35mW.rawValue),POWER_TABLE[6]:NSNumber(value:PowerLowRange.LowRangePower27mW.rawValue),POWER_TABLE[7]:NSNumber(value:PowerLowRange.LowRangePower21mW.rawValue),POWER_TABLE[8]:NSNumber(value:PowerLowRange.LowRangePower16mW.rawValue),POWER_TABLE[9]:NSNumber(value:PowerLowRange.LowRangePower13mW.rawValue),POWER_TABLE[10]:NSNumber(value:PowerLowRange.LowRangePower9_8mW.rawValue),POWER_TABLE[11]:NSNumber(value:PowerLowRange.LowRangePower7_6mW.rawValue),POWER_TABLE[12]:NSNumber(value:PowerLowRange.LowRangePower5_9mW.rawValue),POWER_TABLE[13]:NSNumber(value:PowerLowRange.LowRangePower4_6mW.rawValue),POWER_TABLE[14]:NSNumber(value:PowerLowRange.LowRangePower3_6mW.rawValue),POWER_TABLE[15]:NSNumber(value:PowerLowRange.LowRangePower2_8mW.rawValue),POWER_TABLE[16]:NSNumber(value:PowerLowRange.LowRangePower2_1mW.rawValue),POWER_TABLE[17]:NSNumber(value:PowerLowRange.LowRangePower1_7mW.rawValue),POWER_TABLE[18]:NSNumber(value:PowerLowRange.LowRangePower1_3mW.rawValue),POWER_TABLE[19]:NSNumber(value:PowerLowRange.LowRangePower1_0mW.rawValue)]
        }
        else {
            //登録局用
            POWER_TABLE = ["500mW", "410mW", "336mW", "276mW", "226mW", "186mW", "152mW", "125mW", "97mW", "75mW", "58mW", "45mW", "35mW", "27mW", "21mW", "16mW", "13mW", "9.8mW", "7.6mW", "5.9mW", "4.6mW", "3.6mW", "2.8mW", "2.1mW", "1.7mW", "1.3mW", "1.0mW"]
            
            POWER_INDEX = [POWER_TABLE[0]:NSNumber(value:PowerHighRange.HighRangePower500mW.rawValue),POWER_TABLE[1]:NSNumber(value:PowerHighRange.HighRangePower410mW.rawValue),POWER_TABLE[2]:NSNumber(value:PowerHighRange.HighRangePower336mW.rawValue),POWER_TABLE[3]:NSNumber(value:PowerHighRange.HighRangePower276mW.rawValue),POWER_TABLE[4]:NSNumber(value:PowerHighRange.HighRangePower226mW.rawValue),POWER_TABLE[5]:NSNumber(value:PowerHighRange.HighRangePower186mW.rawValue),POWER_TABLE[6]:NSNumber(value:PowerHighRange.HighRangePower152mW.rawValue),POWER_TABLE[7]:NSNumber(value:PowerHighRange.HighRangePower125mW.rawValue),POWER_TABLE[8]:NSNumber(value:PowerHighRange.HighRangePower97mW.rawValue),POWER_TABLE[9]:NSNumber(value:PowerHighRange.HighRangePower75mW.rawValue),POWER_TABLE[10]:NSNumber(value:PowerHighRange.HighRangePower58mW.rawValue),POWER_TABLE[11]:NSNumber(value:PowerHighRange.HighRangePower45mW.rawValue),POWER_TABLE[12]:NSNumber(value:PowerHighRange.HighRangePower35mW.rawValue),POWER_TABLE[13]:NSNumber(value:PowerHighRange.HighRangePower27mW.rawValue),POWER_TABLE[14]:NSNumber(value:PowerHighRange.HighRangePower21mW.rawValue),POWER_TABLE[15]:NSNumber(value:PowerHighRange.HighRangePower16mW.rawValue),POWER_TABLE[16]:NSNumber(value:PowerHighRange.HighRangePower13mW.rawValue),POWER_TABLE[17]:NSNumber(value:PowerHighRange.HighRangePower9_8mW.rawValue),POWER_TABLE[18]:NSNumber(value:PowerHighRange.HighRangePower7_6mW.rawValue),POWER_TABLE[19]:NSNumber(value:PowerHighRange.HighRangePower5_9mW.rawValue),POWER_TABLE[20]:NSNumber(value:PowerHighRange.HighRangePower4_6mW.rawValue),POWER_TABLE[21]:NSNumber(value:PowerHighRange.HighRangePower3_6mW.rawValue),POWER_TABLE[22]:NSNumber(value:PowerHighRange.HighRangePower2_8mW.rawValue),POWER_TABLE[23]:NSNumber(value:PowerHighRange.HighRangePower2_1mW.rawValue),POWER_TABLE[24]:NSNumber(value:PowerHighRange.HighRangePower1_7mW.rawValue),POWER_TABLE[25]:NSNumber(value:PowerHighRange.HighRangePower1_3mW.rawValue),POWER_TABLE[26]:NSNumber(value:PowerHighRange.HighRangePower1_0mW.rawValue)]
        }

        reversePowerDictionary = [:]
        for key in POWER_INDEX.keys {
            if let val = POWER_INDEX[key] {
                reversePowerDictionary[val] = key
            }
        }

        //Q値設定
        VALUE_Q_TABLE = ["1 tag", "1-4 tags", "1-8 tags", "1-16 tags", "1-32 tags", "1-64 tags", "1-128 tags", "1-256 tags", "1-512 tags", "1-1024 tags", "1-2048 tags"]
        //画面の値→RWの値変換用
        VALUE_Q_INDEX = [VALUE_Q_TABLE[0]:NSNumber(value:0),VALUE_Q_TABLE[1]:NSNumber(value:1),VALUE_Q_TABLE[2]:NSNumber(value:2),VALUE_Q_TABLE[3]:NSNumber(value:3),VALUE_Q_TABLE[4]:NSNumber(value:4),VALUE_Q_TABLE[5]:NSNumber(value:5),VALUE_Q_TABLE[6]:NSNumber(value:6),VALUE_Q_TABLE[7]:NSNumber(value:7),VALUE_Q_TABLE[8]:NSNumber(value:8),VALUE_Q_TABLE[9]:NSNumber(value:9),VALUE_Q_TABLE[10]:NSNumber(value:10)]

        //RWの値→画面の値変換用
        //※VALUE_Q_INDEXだけだと、画面の値→RWの値へ変換はできるが、その逆はできない。そのため、ここでその逆をできる辞書の作成を行う
        reverseValueQDictionary = [:]
        for key in VALUE_Q_INDEX.keys {
            if let val = VALUE_Q_INDEX[key] {
                reverseValueQDictionary[val] = key
            }
        }

        //周波数値設定
        if (isEcoDevice) {
            //特定省電力用
            FREQUENCY_TABLE = ["Auto", "5ch", "11ch", "17ch", "23ch", "24ch", "25ch", "26ch", "27ch", "28ch", "29ch", "30ch", "31ch", "32ch"]
        
            FREQUENCY_INDEX = [FREQUENCY_TABLE[0]:NSNumber(value:FrequencyChannelType.auto.rawValue),FREQUENCY_TABLE[1]:NSNumber(value:FrequencyLowChannelType.ch05.rawValue),FREQUENCY_TABLE[2]:NSNumber(value:FrequencyLowChannelType.ch11.rawValue),FREQUENCY_TABLE[3]:NSNumber(value:FrequencyLowChannelType.ch17.rawValue),FREQUENCY_TABLE[4]:NSNumber(value:FrequencyLowChannelType.ch23.rawValue),FREQUENCY_TABLE[5]:NSNumber(value:FrequencyLowChannelType.ch24.rawValue),FREQUENCY_TABLE[6]:NSNumber(value:FrequencyLowChannelType.ch25.rawValue),FREQUENCY_TABLE[7]:NSNumber(value:FrequencyLowChannelType.ch26.rawValue),FREQUENCY_TABLE[8]:NSNumber(value:FrequencyLowChannelType.ch27.rawValue),FREQUENCY_TABLE[9]:NSNumber(value:FrequencyLowChannelType.ch28.rawValue),FREQUENCY_TABLE[10]:NSNumber(value:FrequencyLowChannelType.ch29.rawValue),FREQUENCY_TABLE[11]:NSNumber(value:FrequencyLowChannelType.ch30.rawValue),FREQUENCY_TABLE[12]:NSNumber(value:FrequencyLowChannelType.ch31.rawValue),FREQUENCY_TABLE[13]:NSNumber(value:FrequencyLowChannelType.ch32.rawValue)]
        }
        else if(model == JP2 || model == JP5) {
            //免許局用
            FREQUENCY_TABLE = ["5ch", "11ch", "17ch", "23ch"]
            FREQUENCY_INDEX = [FREQUENCY_TABLE[0]:NSNumber(value:FrequencyHighChannelType.ch05.rawValue),FREQUENCY_TABLE[1]:NSNumber(value:FrequencyHighChannelType.ch11.rawValue),FREQUENCY_TABLE[2]:NSNumber(value:FrequencyHighChannelType.ch17.rawValue),FREQUENCY_TABLE[3]:NSNumber(value:FrequencyHighChannelType.ch23.rawValue)]
        }
        else {
            //登録局用
            FREQUENCY_TABLE = ["Auto", "5ch", "11ch", "17ch", "23ch", "24ch", "25ch"]
            FREQUENCY_INDEX = [FREQUENCY_TABLE[0]:NSNumber(value:FrequencyChannelType.auto.rawValue),FREQUENCY_TABLE[1]:NSNumber(value:FrequencyHighChannelType.ch05.rawValue),FREQUENCY_TABLE[2]:NSNumber(value:FrequencyHighChannelType.ch11.rawValue),FREQUENCY_TABLE[3]:NSNumber(value:FrequencyHighChannelType.ch17.rawValue),FREQUENCY_TABLE[4]:NSNumber(value:FrequencyHighChannelType.ch23.rawValue),FREQUENCY_TABLE[5]:NSNumber(value:FrequencyHighChannelType.ch24.rawValue),FREQUENCY_TABLE[6]:NSNumber(value:FrequencyHighChannelType.ch25.rawValue)]

        }
        //逆引き辞書の作成
        reverseFrequencyDictionary = [:]
        for key in FREQUENCY_INDEX.keys {
            if let val = FREQUENCY_INDEX[key] {
                reverseFrequencyDictionary[val] = key
            }
        }
        
        TRIGGER_SW_TABLE = ["押している間だけON", "ホールドモード", "トリガースイッチ無効"]
        TRIGGER_SW_INDEX = [TRIGGER_SW_TABLE[0]:NSNumber(value:TrigModeType.realtime.rawValue),TRIGGER_SW_TABLE[1]:NSNumber(value:TrigModeType.hold.rawValue),TRIGGER_SW_TABLE[2]:NSNumber(value:TrigModeType.none.rawValue)]

        reverseTriggerDictionary = [:]
        for key in TRIGGER_SW_INDEX.keys {
            if let val = TRIGGER_SW_INDEX[key] {
                reverseTriggerDictionary[val] = key
            }
        }

        //読取モードリスト設定
        setTagReadModeList()
        //フラグABリスト設定
        setFlagABList()
        //読取識別番号設定
        setMisreadingPreventionSettingsList()

        comboMode = ComboMode.ComboModePower

        //デザインで配置されたピーッカーの位置を保持しておく（この値は、ピッカを出したり隠したりする為に記憶しておく）
        backupComboFramePosY = self.comboPickerView.frame.origin.y
        print("デザインで配置された位置を保持しておく%f",backupComboFramePosY)
        
        //クルクルアイコンを画面に割り付けておく
        indicatorView = ToolCommon.addSpinIndicator(selfViewContr: self)
        
        //ここで、デバイスからの値取り込みを行う。
        rememberToInitVal()
        settingReadFromAllDevices()

        //"無効"以外が設定された場合、読み取りモードボタンを使用不可にする
        if(selectedIndexMisreadingPreventionSettings != 0){
            self.tagReadModeSelectButton.isEnabled = false;
        }
        else{
            self.tagReadModeSelectButton.isEnabled = true;
        }
    }
    
    /**
     タグ読取モード設定
     */
    func setTagReadModeList() {
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
            //タグ読取モード設定
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                TAG_READ_MODE_TABLE = [FM0, FM0_MEDIUMSPEED, MILLER2_LOWSPEED, MILLER2_HIGHSPEED, MILLER4_LOWSPEED, MILLER4_HIGHSPEED, MILLER8_LOWSPEED, MILLER8_HIGHSPEED]
                TAG_READ_MODE_INDEX = [TAG_READ_MODE_TABLE[0]:NSNumber(value:TagReadModeTypeTruncate.T_FM0.rawValue),
                                       TAG_READ_MODE_TABLE[1]:NSNumber(value:TagReadModeTypeTruncate.T_FM0MediumSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[2]:NSNumber(value:TagReadModeTypeTruncate.T_Miller2LowSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[3]:NSNumber(value:TagReadModeTypeTruncate.T_Miller2HighSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[4]:NSNumber(value:TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[5]:NSNumber(value:TagReadModeTypeTruncate.T_Miller4HighSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[6]:NSNumber(value:TagReadModeTypeTruncate.T_Miller8LowSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[7]:NSNumber(value:TagReadModeTypeTruncate.T_Miller8HighSpeedType.rawValue)]
                
            }
            else{
                TAG_READ_MODE_TABLE = [MILLER2_MEDIUMSPEED, MILLER2_HIGHSPEED, MILLER4_MEDIUMSPEED,MILLER4_HIGHSPEED,MILLER8_MEDIUMSPEED,MILLER8_HIGHSPEED]
                TAG_READ_MODE_INDEX = [TAG_READ_MODE_TABLE[0]:NSNumber(value:TagReadModeType.Miller2MediumSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[1]:NSNumber(value:TagReadModeType.Miller2HighSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[2]:NSNumber(value:TagReadModeType.Miller4MediumSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[3]:NSNumber(value:TagReadModeType.Miller4HighSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[4]:NSNumber(value:TagReadModeType.Miller8MediumSpeedType.rawValue),
                                       TAG_READ_MODE_TABLE[5]:NSNumber(value:TagReadModeType.Miller8THighSpeedype.rawValue)]
                
            }
            reverseTagReadModeDictionary = [:]
            for key in TAG_READ_MODE_INDEX.keys {
                if let val = TAG_READ_MODE_INDEX[key] {
                    reverseTagReadModeDictionary[val] = key
                }
            }
            
            self.tagReadModeSelectButton.isEnabled = true
        }
        else {
            TAG_READ_MODE_TABLE = ["","","","","","","",""]
            TAG_READ_MODE_INDEX = [:]
            
            reverseTagReadModeDictionary = [:]
            self.tagReadModeSelectButton.isEnabled = false
        }
    }
    
    /**
     フラグAB設定
     */
    func setFlagABList() {
        //フラグAB選択肢表示設定を、設定ファイルから取ってくる
        if let flagABSetting = UserDefaults.standard.string(forKey: "FlagABSetting") {
            if flagABSetting == FlagABShowall {
                FLAG_AB_TABLE = [FLAG_AB, FLAG_A, FLAG_B];
                //画面の値→RWの値変換用
                FLAG_AB_INDEX = [FLAG_AB_TABLE[0]:NSNumber(value:FlagABValue.AB.rawValue),
                                       FLAG_AB_TABLE[1]:NSNumber(value:FlagABValue.A.rawValue),
                                       FLAG_AB_TABLE[2]:NSNumber(value:FlagABValue.B.rawValue)]
            }
            else {
                FLAG_AB_TABLE = [FLAG_AB, FLAG_A];
                //画面の値→RWの値変換用
                FLAG_AB_INDEX = [FLAG_AB_TABLE[0]:NSNumber(value:FlagABValue.AB.rawValue),
                                       FLAG_AB_TABLE[1]:NSNumber(value:FlagABValue.A.rawValue)]
            }
        }
        else {
            FLAG_AB_TABLE = [FLAG_AB, FLAG_A];
            //画面の値→RWの値変換用
            FLAG_AB_INDEX = [FLAG_AB_TABLE[0]:NSNumber(value:FlagABValue.AB.rawValue),
                                   FLAG_AB_TABLE[1]:NSNumber(value:FlagABValue.A.rawValue)]
        }
        //RWの値→画面の値変換用
        //※FLAG_AB_INDEXだけだと、画面の値→RWの値へ変換はできるが、その逆はできない。そのため、ここでその逆をできる辞書の作成を行う
        reverseFlagABDictionary = [:]
        for key in FLAG_AB_INDEX.keys {
            if let val = FLAG_AB_INDEX[key] {
                reverseFlagABDictionary[val] = key
            }
        }
    }
    
    /**
     読取識別番号設定
     */
    func setMisreadingPreventionSettingsList() {
        
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            //配列の作成
            let array:NSArray = ToolCommon.getMisreadingPreventionSettingsTable()
            for obj in array{
                let subarray = obj as! NSArray
                let readingID = subarray[0] as! NSNumber
                if readingID == 0{
                    MISREADING_PREVETION_SETTINGS_TABLE.append("無効")
                }
                else{
                    MISREADING_PREVETION_SETTINGS_TABLE.append(readingID.description)
                }
                MISREADING_PREVETION_SETTINGS_INDEX[readingID.description] = readingID
            }
            
            //RWの値→画面の値変換用
            //※READING_ID_NUMBER_INDEXだけだと、画面の値→RWの値へ変換はできるが、その逆はできない。そのため、ここでその逆をできる辞書の作成を行う
            reverseMisreadingPreventionSettingsDictionary = [:]
            for key in MISREADING_PREVETION_SETTINGS_INDEX.keys {
                if let val = MISREADING_PREVETION_SETTINGS_INDEX[key] {
                    if val == 0{
                        reverseMisreadingPreventionSettingsDictionary[val] = "無効"
                    }
                    else{
                        reverseMisreadingPreventionSettingsDictionary[val] = key
                    }
                }
            }
        }
        else {
            MISREADING_PREVETION_SETTINGS_TABLE = []
            MISREADING_PREVETION_SETTINGS_INDEX = [:]
            
            reverseMisreadingPreventionSettingsDictionary = [:]
            self.MisreadingPreventionSettingsButton.isEnabled = false
        }

    }
    
    /** View が表示される直前に呼ばれるメソッド */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        // 共有データからデータを読み出し
        let selectedFileName = SharedData.sharedManager.getDataForKey(aKey: "SelectedFileName")
        if !selectedFileName.isEmpty {
            //データが存在すれば、ファイルが選択されたのだと判断する。
            //データ存在確認後は、速やかに削除
            SharedData.sharedManager.removeDataForKey(aKey: "SelectedFileName")
            print("selectedFileName=\(selectedFileName)")
            
            //ファイルに書き込まれた内容を、画面に展開する
            indicationFileToView(fileName: selectedFileName)
        }
    }
    
    /** View が他のView (画面から消えた) 非表示後に呼び出されるメッソド*/
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: -内部メソッド
    /** 全ての設定情報をデバイスから取り込む */
    func settingReadFromAllDevices() {
        //クルクルアイコン　アニメーション開始
        startFreeze()
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            do {
                defer {
                    self.stopFreeze()
                }
                if !self.configerReadPower() {
                    return
                }
                if !self.configerReadQValue() {
                    return
                }
                if !self.configerReadFrequency() {
                    return
                }
                if !self.configerReadTriggerSwMode() {
                    return
                }
                if !self.configerReadSavingEnergy() {
                    return
                }
                if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
                    if !self.configerReadTagReadMode() {
                        return
                    }
                }
                if !self.configerReadFlagAB() {
                    return
                }
                if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                    if !self.configerReadMisreadingPreventionSettings() {
                        return
                        
                    }
                }
            }
        })
    }
    
     /** 初期設定に戻す */
    func rememberToInitVal() {
        //初期値設定
        //出力選択の初期化
        if isEcoDevice {
            //特定省電力
            self.selectedIndexPower  = self.POWER_TABLE.index(of:self.reversePowerDictionary[NSNumber(value: PowerLowRange.LowRangePower125mW.rawValue)]!)!
        }
        else {
            //登録局用
            self.selectedIndexPower  = self.POWER_TABLE.index(of:self.reversePowerDictionary[NSNumber(value: PowerHighRange.HighRangePower125mW.rawValue)]!)!
        }
        self.selectedIndexValueQ  = self.VALUE_Q_TABLE.index(of:self.reverseValueQDictionary[NSNumber(value: 4)]!)!
        if self.reverseFrequencyDictionary[NSNumber(value:FrequencyChannelType.auto.rawValue)] == nil {
            self.selectedIndexFrequency  = self.FREQUENCY_TABLE.index(of:self.reverseFrequencyDictionary[NSNumber(value: FrequencyLicenseChannelType.ch05.rawValue)]!)!
        }
        else {
            self.selectedIndexFrequency  = self.FREQUENCY_TABLE.index(of:self.reverseFrequencyDictionary[NSNumber(value: FrequencyChannelType.auto.rawValue)]!)!
        }
        self.selectedIndexTrigger  = self.TRIGGER_SW_TABLE.index(of:self.reverseTriggerDictionary[NSNumber(value: TrigModeType.none.rawValue)]!)!
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                self.selectedIndexTagReadMode  = self.TAG_READ_MODE_TABLE.index(of:self.reverseTagReadModeDictionary[NSNumber(value: TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue)]!)!
            }
            else{
                self.selectedIndexTagReadMode  = self.TAG_READ_MODE_TABLE.index(of:self.reverseTagReadModeDictionary[NSNumber(value: TagReadModeType.Miller4MediumSpeedType.rawValue)]!)!
            }
        }
        self.selectedIndexFlagAB  = self.FLAG_AB_TABLE.index(of:self.reverseFlagABDictionary[NSNumber(value: FlagABValue.A.rawValue)]!)!
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            self.selectedIndexMisreadingPreventionSettings  = self.MISREADING_PREVETION_SETTINGS_TABLE.index(of:self.reverseMisreadingPreventionSettingsDictionary[NSNumber(value: 0)]!)!
        }

        //ボタンのタイトルにセット
        self.powerSelectButton.setTitle(String(format: "%@:%@", self.POWER_INDEX[self.POWER_TABLE[self.selectedIndexPower]]!,self.POWER_TABLE[self.selectedIndexPower]), for:.normal)
        self.valueQSelectButton.setTitle(String(format: "%@:%@", self.VALUE_Q_INDEX[self.VALUE_Q_TABLE[self.selectedIndexValueQ]]!,self.VALUE_Q_TABLE[self.selectedIndexValueQ]), for:.normal)
        self.frequencySelectButton.setTitle(String(format: "%@",self.FREQUENCY_TABLE[self.selectedIndexFrequency]), for:.normal)
        self.triggerSelectButton.setTitle(String(format: "%@",self.TRIGGER_SW_TABLE[self.selectedIndexTrigger]), for:.normal)
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
            self.tagReadModeSelectButton.setTitle(String(format: "%@",self.TAG_READ_MODE_TABLE[self.selectedIndexTagReadMode]), for:.normal)
        }
        self.flagABSelectButton.setTitle(String(format: "%@",self.FLAG_AB_TABLE[self.selectedIndexFlagAB]), for:.normal)
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            if selectedIndexMisreadingPreventionSettings == 0 {
                self.MisreadingPreventionSettingsButton.setTitle(String(format: "無効"), for:.normal)
            }
            else{
                self.MisreadingPreventionSettingsButton.setTitle(String(format: "%@",self.MISREADING_PREVETION_SETTINGS_TABLE[self.selectedIndexMisreadingPreventionSettings]), for:.normal)
            }
        }
        else{
            self.MisreadingPreventionSettingsButton.setTitle(String(format: "無効"), for:.normal)
        }
        //"無効"以外が設定された場合、読み取りモードボタンを使用不可にする
        if(selectedIndexMisreadingPreventionSettings != 0){
            self.tagReadModeSelectButton.isEnabled = false;
        }
        else{
            self.tagReadModeSelectButton.isEnabled = true;
        }

        //省電力設定のデフォルトはON
        self.energySavingSwitch.setOn(true, animated: true)
        valEnergy = Int32(EnergyType.sav.rawValue)
        
        //自動周波数設定削除
        let ud = UserDefaults.standard
        ud.removeObject(forKey: AUTO_FREQUENCY_CHANNEL_KEY)
        ud.synchronize()
    }
    
    /** ファイルから読み込んで画面へ展開する */
    func indicationFileToView(fileName:String) {
        print("indicationFileToView fileName=\(fileName)")
        
        // ドキュメントフォルダのパス文字列を取得
        let aDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileFullPath:String = String(format:"%@/%@", aDirectory,fileName)
        print("fileFullPath=\(fileFullPath)")

        //ファイルから、Dictionaryに取り込む
        
        if let settingDictionary = NSDictionary(contentsOfFile: fileFullPath) {
            //設定内容を取り込み、値に問題が無いかチェックする
            guard let powVal = settingDictionary.object(forKey: SETTING_KEY_POWER) as? NSNumber else {
                showDialog(title: "エラー", message: "設定ファイル読み込み失敗\n出力値範囲外")
                return
            }
            if (reversePowerDictionary[powVal] == nil) {
                //値異常
                showDialog(title: "エラー", message: "設定ファイル読み込み失敗\n出力値範囲外")
                return
            }
            
            guard let valQ = settingDictionary.object(forKey: SETTING_KEY_Q_VALUE) as? NSNumber else {
                showDialog(title: "エラー", message: "設定ファイル読み込み失敗\nQ値範囲外")
                return
            }
            if (reverseValueQDictionary[valQ] == nil) {
                //値異常
                showDialog(title: "エラー", message: "設定ファイル読み込み失敗\nQ値範囲外")
                return
            }
            
            guard let freqVal = settingDictionary.object(forKey: SETTING_KEY_FREQUENCY) as? NSNumber else {
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n周波数範囲外")
                return
            }
            if (reverseFrequencyDictionary[freqVal] == nil) {
                //値異常
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n周波数範囲外")
                return
            }
            
            guard let trigVal = settingDictionary.object(forKey: SETTING_KEY_TRIGGER) as? NSNumber else {
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\nトリガ範囲外")
                return
            }
            if (reverseTriggerDictionary[trigVal] == nil) {
                //値異常
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\nトリガ範囲外")
                return
            }
            
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
                guard let tagReadModeVal = settingDictionary.object(forKey: SETTING_KEY_TAG_READ_MODE) as? NSNumber else {
                    showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n読取モード設定範囲外")
                    return
                }
                if (reverseTagReadModeDictionary[tagReadModeVal] == nil) {
                    //値異常
                    showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n読取モード設定範囲外")
                    return
                }
            }
            
            guard let flagABVal = settingDictionary.object(forKey: SETTING_KEY_FLAG_AB) as? NSNumber else {
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\nフラグAB設定範囲外")
                return
            }
            if (reverseFlagABDictionary[flagABVal] == nil) {
                //値異常
                showDialog(title: "エラー", message:"設定ファイル読み込み失敗\nフラグAB設定範囲外")
                return
            }

            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                guard let MisreadingPreventionSettingsVal = settingDictionary.object(forKey: SETTING_KEY_MISREADING_PREVENTION_SETTINGS) as? NSNumber else {
                    showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n読取識別番号設定範囲外")
                    return
                }
                if (reverseMisreadingPreventionSettingsDictionary[MisreadingPreventionSettingsVal] == nil) {
                    //値異常
                    showDialog(title: "エラー", message:"設定ファイル読み込み失敗\n読取識別番号設定範囲外")
                    return
                }
            }
        

            //値をインデックスに変換数
            self.selectedIndexPower  = self.POWER_TABLE.index(of:self.reversePowerDictionary[powVal]!)!
            self.selectedIndexValueQ  = self.VALUE_Q_TABLE.index(of:self.reverseValueQDictionary[valQ]!)!
            self.selectedIndexFrequency  = self.FREQUENCY_TABLE.index(of:self.reverseFrequencyDictionary[freqVal]!)!
            self.selectedIndexTrigger  = self.TRIGGER_SW_TABLE.index(of:self.reverseTriggerDictionary[trigVal]!)!
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
                if let mode = settingDictionary.object(forKey: SETTING_KEY_TAG_READ_MODE) as? NSNumber {
                    self.selectedIndexTagReadMode  = self.TAG_READ_MODE_TABLE.index(of:self.reverseTagReadModeDictionary[mode]!)!
                }
            }
            self.selectedIndexFlagAB  = self.FLAG_AB_TABLE.index(of:self.reverseFlagABDictionary[flagABVal]!)!
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                if let readingID = settingDictionary.object(forKey: SETTING_KEY_MISREADING_PREVENTION_SETTINGS) as? NSNumber {
                    self.selectedIndexMisreadingPreventionSettings  = self.MISREADING_PREVETION_SETTINGS_TABLE.index(of:self.reverseMisreadingPreventionSettingsDictionary[readingID]!)!
                }
            }

            //ボタンのタイトルにセット
            self.powerSelectButton.setTitle(String(format: "%@:%@", self.POWER_INDEX[self.POWER_TABLE[self.selectedIndexPower]]!,self.POWER_TABLE[self.selectedIndexPower]), for:.normal)
            self.valueQSelectButton.setTitle(String(format: "%@:%@", self.VALUE_Q_INDEX[self.VALUE_Q_TABLE[self.selectedIndexValueQ]]!,self.VALUE_Q_TABLE[self.selectedIndexValueQ]), for:.normal)
            self.frequencySelectButton.setTitle(String(format: "%@",self.FREQUENCY_TABLE[self.selectedIndexFrequency]), for:.normal)
            self.triggerSelectButton.setTitle(String(format: "%@",self.TRIGGER_SW_TABLE[self.selectedIndexTrigger]), for:.normal)
            //省電力設定のデフォルトはON
            if let eng = settingDictionary.object(forKey: SETTING_KEY_ENERGY) as? Bool {
               self.energySavingSwitch.setOn(eng, animated: true)
                valEnergy = eng ? Int32(EnergyType.sav.rawValue) : Int32(EnergyType.non.rawValue)
            }
            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
                self.tagReadModeSelectButton.setTitle(String(format: "%@",self.TAG_READ_MODE_TABLE[self.selectedIndexTagReadMode]), for:.normal)
            }
            self.flagABSelectButton.setTitle(String(format: "%@",self.FLAG_AB_TABLE[self.selectedIndexFlagAB]), for:.normal)

            if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                self.MisreadingPreventionSettingsButton.setTitle(String(format: "%@",self.MISREADING_PREVETION_SETTINGS_TABLE[self.selectedIndexMisreadingPreventionSettings]), for:.normal)
            }
            //"無効"以外が設定された場合、読み取りモードボタンを使用不可にする
            if(selectedIndexMisreadingPreventionSettings != 0){
                self.tagReadModeSelectButton.isEnabled = false;
            }
            else{
                self.tagReadModeSelectButton.isEnabled = true;
            }
            
            if self.FREQUENCY_TABLE[self.selectedIndexFrequency] == "Auto" {
                let frequencyAutoList = settingDictionary.object(forKey: AUTO_FREQUENCY_CHANNEL_KEY)
                let ud = UserDefaults.standard
                ud.set(frequencyAutoList, forKey: AUTO_FREQUENCY_CHANNEL_KEY)
                ud.synchronize()
            }
        }
        else {
           showDialog(title: "エラー", message: "設定ファイル読み込み失敗")
        }
    }
    
    /** 画面に設定されている内容をファイルに書き出す */
    func saveSettingToFile(fileName:String) {
        print("saveSettingToFile fileName=\(fileName)")
        
        // ドキュメントフォルダのパス文字列を取得
        let aDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileFullPath:String = String(format:"%@/%@%@", aDirectory,fileName,SETTING_EXT)
        print("fileFullPath=\(fileFullPath)")
        
        //画面に設定されている内容を、Dictionaryへ格納する
        let settingDictionary:NSMutableDictionary = [:]
        let power = POWER_INDEX[POWER_TABLE[selectedIndexPower]]
        settingDictionary.setObject(power as Any, forKey: SETTING_KEY_POWER as NSString)
        
        let qval = VALUE_Q_INDEX[VALUE_Q_TABLE[selectedIndexValueQ]]
        settingDictionary.setObject(qval as Any, forKey: SETTING_KEY_Q_VALUE as NSString)
        
        let frequency = FREQUENCY_INDEX[FREQUENCY_TABLE[selectedIndexFrequency]]
        settingDictionary.setObject(frequency as Any, forKey: SETTING_KEY_FREQUENCY as NSString)
        
        let trigger = TRIGGER_SW_INDEX[TRIGGER_SW_TABLE[selectedIndexTrigger]]
        settingDictionary.setObject(trigger as Any, forKey: SETTING_KEY_TRIGGER as NSString)
        
        let eng = self.energySavingSwitch.isOn
        settingDictionary.setObject(eng, forKey: SETTING_KEY_ENERGY as NSString)
        
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
            let readMode = TAG_READ_MODE_INDEX[TAG_READ_MODE_TABLE[selectedIndexTagReadMode]]
            settingDictionary.setObject(readMode as Any, forKey: SETTING_KEY_TAG_READ_MODE as NSString)
        }
        
        let flagAB = FLAG_AB_INDEX[FLAG_AB_TABLE[selectedIndexFlagAB]]
        settingDictionary.setObject(flagAB as Any, forKey: SETTING_KEY_FLAG_AB as NSString)
        
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            var key = MISREADING_PREVETION_SETTINGS_TABLE[selectedIndexMisreadingPreventionSettings]
            if (key == "無効"){
                key="0"
            }
            let MisreadingPreventionSettings = MISREADING_PREVETION_SETTINGS_INDEX[key]
            settingDictionary.setObject(MisreadingPreventionSettings as Any, forKey: SETTING_KEY_MISREADING_PREVENTION_SETTINGS as NSString)
        }
        
        if self.FREQUENCY_TABLE[self.selectedIndexFrequency] == "Auto" {
            let ud = UserDefaults.standard
            if let frequencyAutoList = ud.array(forKey: AUTO_FREQUENCY_CHANNEL_KEY) {
                settingDictionary.setObject(frequencyAutoList as Any, forKey: AUTO_FREQUENCY_CHANNEL_KEY as NSString)
            }
            else {
                let defAutoList = ToolCommon.getFwDefFrequencyAutoList(model: model)
                settingDictionary.setObject(defAutoList as Any, forKey: AUTO_FREQUENCY_CHANNEL_KEY as NSString)
            }
        }
        
        //Dictionaryに格納されたデータをファイルに..
        if settingDictionary.write(toFile: fileFullPath, atomically: true) {
            showDialog(title: "情報", message: "保存に成功しました")
        }
        else {
            showDialog(title: "エラー", message: "保存に失敗しました")
        }
    }

    // MARK: -表示処理
    /**
     ピッカーを表示する
     @param selectMode 選択したモード
     @param selectedIndex 選択インデックス
     */
    func showPicker(selectMode:ComboMode,selectedIndex:NSInteger) {
        //一つのピッカーを使い廻すので、どのモードで動作しているのかを判断できるように
        comboMode = selectMode
        
        //モードを変更した後、ロードし直す
        self.comboPickerView.reloadAllComponents()

        //現在の選択行をSETする
        self.comboPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)

        //ピーッカーを表示状態にする
        self.comboPickerView.isHidden = false

        //じわじわと、アニメーションで、ピッカーを表示する
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            //標準位置へ
            self.comboPickerView.frame = CGRect(x:self.comboPickerView.frame.origin.x,
                                                y:self.backupComboFramePosY,
                                               width:self.comboPickerView.frame.size.width,
                                               height:self.comboPickerView.frame.size.height)
        }, completion: { _ in
            // アニメーションが終わった後実行する処理
            //特になし
        })
    }
    
    /**
     ダイアログ表示
     @param title タイトル
     @param message メッセージ
     */
    func showDialog(title:String!,message:String) {
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
    
    // MARK: -デバイス設定関連
    /** デバイス出力取得 */
    func configerReadPower()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ 送信出力レベル ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getPower({(powerLevel,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("GetPowerのコールバックで失敗している")
                        self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックGetPower失敗 code=%d", callbackResult))
                    return
                }
                
                //範囲外チェックを行う
                if self.reversePowerDictionary[NSNumber(value: powerLevel)] == nil {
                    //範囲外
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\n範囲外の出力値 value=%d", powerLevel))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.selectedIndexPower  = self.POWER_TABLE.index(of:self.reversePowerDictionary[NSNumber(value: powerLevel)]!)!
                    self.powerSelectButton.setTitle(String(format: "%@:%@", self.POWER_INDEX[self.POWER_TABLE[self.selectedIndexPower]]!,self.POWER_TABLE[self.selectedIndexPower]), for:.normal)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("GetPowerの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドGetPower失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("GetPowerのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイスQ値取得 */
    func configerReadQValue()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0

        // ■ Q値 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getQValue({(valueQ,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("GetQValueのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックGetQValue失敗 code=%d", callbackResult))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //もし、valueQが、VALUE_Q_INDEXの範囲内に無い時は、最大を使用する
                    if self.reverseValueQDictionary[NSNumber(value: valueQ)] == nil {
                        //算出されたmaxインデックスをセットする（おそらく10であることを祈る）
                        //let allValues = Array(self.VALUE_Q_INDEX.values)
                        let val = self.VALUE_Q_INDEX.max { a, b in a.value.intValue < b.value.intValue }
                        self.selectedIndexValueQ  = (val?.value.intValue)!
                        print("取得したQ値は範囲外(\(valueQ))だったので、最大に丸めました(\(self.selectedIndexValueQ))。")
                    }
                    else {
                        self.selectedIndexValueQ  = self.VALUE_Q_TABLE.index(of:self.reverseValueQDictionary[NSNumber(value: valueQ)]!)!
                    }
                    self.valueQSelectButton.setTitle(String(format: "%@:%@", self.VALUE_Q_INDEX[self.VALUE_Q_TABLE[self.selectedIndexValueQ]]!,self.VALUE_Q_TABLE[self.selectedIndexValueQ]), for:.normal)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("GetQValueの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドGetQValue失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("GetQValueのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイス周波数値取得 */
    func configerReadFrequency()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0

        // ■ 周波数 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getFrequency({(frequencyChannel,autoFrequencyList,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("GetFrequencyのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックGetFrequency失敗 code=%d", callbackResult))
                    return
                }
                
                if frequencyChannel == FrequencyChannelType.auto.rawValue {
                    let list:Array = autoFrequencyList!
                    print("GetFrequency FrequencyChannelTypeAuto FrequencyList=\(list)")
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    //取り込んだ値を、画面に展開する
                    
                    //範囲外チェックを行う
                    if self.reverseFrequencyDictionary[NSNumber(value: frequencyChannel)] == nil {
                        //範囲外
                        self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\n範囲外の周波数値 value=%d", frequencyChannel))
                        return
                    }
                    
                    //チャネル番号を、インデックス番号に変換する
                    self.selectedIndexFrequency  = self.FREQUENCY_TABLE.index(of:self.reverseFrequencyDictionary[NSNumber(value: frequencyChannel)]!)!
                    
                    //画面表示の更新
                    self.frequencySelectButton.setTitle(String(format: "%@",self.FREQUENCY_TABLE[self.selectedIndexFrequency]), for:.normal)
                    
                    if frequencyChannel == FrequencyChannelType.auto.rawValue {
                        var frequencyAutoList:Array = autoFrequencyList!
                        while(frequencyAutoList.count != 12) {
                            frequencyAutoList.append(NSNumber(value:FREQUENCY_CHANNEL_SKIP))
                        }
                        let ud = UserDefaults.standard
                        ud.set(frequencyAutoList, forKey: AUTO_FREQUENCY_CHANNEL_KEY)
                        ud.synchronize()
                    }
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("GetFrequencyの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドGetFrequency失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("GetFrequencyのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイストリガーモード取得 */
    func configerReadTriggerSwMode()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0

        // ■ トリガスイッチモード ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getTriggerSwMode({(trigMode,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("GetTriggerSwModeのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックGetTriggerSwMode失敗 code=%d", resultCode))
                    return
                }
                
                //範囲外チェックを行う
                if self.reverseTriggerDictionary[NSNumber(value: trigMode)] == nil {
                    //範囲外
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\n範囲外の設定値 value=%d", trigMode))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.selectedIndexTrigger  = self.TRIGGER_SW_TABLE.index(of:self.reverseTriggerDictionary[NSNumber(value: trigMode)]!)!
                    self.triggerSelectButton.setTitle(String(format: "%@",self.TRIGGER_SW_TABLE[self.selectedIndexTrigger]), for:.normal)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("GetTriggerSwModeの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドGetTriggerSwMode失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("GetTriggerSwModeのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイス省電力設定取得 */
    func configerReadSavingEnergy()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0

        // ■ 省電力設定値 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getSavingEnergy({(energy,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("GetSavingEnergyのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックGetSavingEnergy失敗 code=%d", callbackResult))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.energySavingSwitch.setOn((energy == EnergyType.sav.rawValue), animated: true)
                    self.valEnergy = (energy == EnergyType.sav.rawValue) ? Int32(EnergyType.sav.rawValue) : Int32(EnergyType.non.rawValue)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("GetSavingEnergyの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドGetSavingEnergy失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("GetSavingEnergyのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイス読取モード設定取得 */
    func configerReadTagReadMode()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ タグ読取モード ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getTagReadMode({(tagSpeed,millerSubCarrier,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("getTagReadModeのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックgetTagReadMode失敗 code=%d", resultCode))
                    return
                }
            
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.selectedIndexTagReadMode  = self.getReadMode(tagSpeed: tagSpeed, millerSubCarrier: millerSubCarrier)
                    self.tagReadModeSelectButton.setTitle(String(format: "%@",self.TAG_READ_MODE_TABLE[self.selectedIndexTagReadMode]), for:.normal)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("getTagReadModeの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドgetTagReadMode失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("getTagReadModeのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /**
     タグ読取モード取得処理
     @param tagSpeed タグ速度設定
     @param millerSubCarrier ミラー副搬送波設定
     @return int 読取モード
     */
    func getReadMode(tagSpeed:Int32,millerSubCarrier:Int32)-> Int {
        var readmode = TagReadModeType.Miller4MediumSpeedType.rawValue
        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            ///// 対応表 /////
            //tagSpeed      millerSubCarrier  readmode
            //--------------------------------------------------
            //FM0           Miller4           FM0
            //FM0Medium     Miller4           FM0Mediup
            //MillerLow     Miller2           Miller2Low
            //MillerHigh    Miller2           Miller2High
            //MillerLow     Miller4           Miller4Low
            //MillerHigh    Miller4           Miller4High
            //MillerLow     Miller8           Miller8Low
            //MillerHigh    Miller8           Miller8High
            //--------------------------------------------------
            // ※Mediumに設定されている場合、低速にする
            //MillerMedium  Miller2           Miller2Low
            //MillerMedium  Miller4           Miller4Low
            //MillerMedium  Miller8           Miller8Low
            //--------------------------------------------------
            
            if tagSpeed==TagReadSpeedType.FM0Type.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_FM0.rawValue
            }
            else if tagSpeed==TagReadSpeedType.FM0MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_FM0MediumSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.LowSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller2Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller2LowSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller2Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller2HighSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.LowSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller4HighSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.LowSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller8Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller8LowSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller8Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller8HighSpeedType.rawValue
            }
                // ※Mediumに設定されている場合、低速にする
            else if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller2Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller2LowSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller8Type.rawValue {
                readmode = TagReadModeTypeTruncate.T_Miller8LowSpeedType.rawValue
            }
            else {
                readmode = TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue
            }
        }
        else{
            if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller2Type.rawValue {
                readmode = TagReadModeType.Miller2MediumSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller2Type.rawValue {
                readmode = TagReadModeType.Miller2HighSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeType.Miller4MediumSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller4Type.rawValue {
                readmode = TagReadModeType.Miller4HighSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.MediumSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller8Type.rawValue {
                readmode = TagReadModeType.Miller8MediumSpeedType.rawValue
            }
            else if tagSpeed==TagReadSpeedType.HighSpeedType.rawValue && millerSubCarrier == TagReadMillerType.Miller8Type.rawValue {
                readmode = TagReadModeType.Miller8THighSpeedype.rawValue
            }
            else {
                readmode = TagReadModeType.Miller4MediumSpeedType.rawValue
            }
        }

        return readmode;
    }
    
    /** デバイスフラグAB設定取得 */
    func configerReadFlagAB()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ フラグAB設定 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getFlagAB({(flag,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("getFlagABのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックgetFlagAB失敗 code=%d", resultCode))
                    return
                }
                
                //範囲外チェックを行う
                if self.reverseFlagABDictionary[NSNumber(value: flag)] == nil {
                    //範囲外
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\n範囲外の設定値 value=%d", flag))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.selectedIndexFlagAB  = self.FLAG_AB_TABLE.index(of:self.reverseFlagABDictionary[NSNumber(value: flag)]!)!
                    self.flagABSelectButton.setTitle(String(format: "%@",self.FLAG_AB_TABLE[self.selectedIndexFlagAB]), for:.normal)
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("getFlagABの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドgetFlagAB失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("getFlagABのコールバック内で失敗している")
            return false
        }
        return true
    }

    /** デバイス読取識別番号設定取得 */
    func configerReadMisreadingPreventionSettings()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ 読取識別番号設定 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().getMisreadingPreventionSettings({(readingID,resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("getMisreadingPreventionSettingsのコールバックで失敗している")
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nコールバックgetMisreadingPreventionSettings失敗 code=%d", resultCode))
                    return
                }
                
                //範囲外チェックを行う
                if self.reverseMisreadingPreventionSettingsDictionary[NSNumber(value: readingID)] == nil {
                    //範囲外
                    self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\n範囲外の設定値 value=%d", readingID))
                    return
                }
                
                //画面更新を行う
                ToolCommon.mainThreadSync(syncProgram: {()-> Void in
                    self.selectedIndexMisreadingPreventionSettings  = self.MISREADING_PREVETION_SETTINGS_TABLE.index(of:self.reverseMisreadingPreventionSettingsDictionary[NSNumber(value: readingID)]!)!
                    self.MisreadingPreventionSettingsButton.setTitle(String(format: "%@",self.MISREADING_PREVETION_SETTINGS_TABLE[self.selectedIndexMisreadingPreventionSettings]), for:.normal)
                    //"無効"以外が設定された場合、読み取りモードボタンを使用不可にする
                    if(self.selectedIndexMisreadingPreventionSettings != 0){
                        self.tagReadModeSelectButton.isEnabled = false;
                    }
                    else{
                        self.tagReadModeSelectButton.isEnabled = true;
                    }
                })
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("getMisreadingPreventionSettingsの実行で失敗している")
            self.showDialog(title: "エラー", message: String(format: "設定の読み込みに失敗しました\nメソッドgetMisreadingPreventionSettings失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("getMisreadingPreventionSettingsのコールバック内で失敗している")
            return false
        }
        return true
    }

    /** デバイス出力値書き込み */
    func configerWritePower()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ 送信出力レベル ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        let powerVal:Int32 = (self.POWER_INDEX[self.POWER_TABLE[self.selectedIndexPower]]?.int32Value)!
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setPower(powerVal, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SetPowerのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSetPower失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SetPowerの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSetPower失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("SetPowerのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイスQ値書き込み */
    func configerWriteQValue()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ Q値 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        let valQ:Int32 = (self.VALUE_Q_INDEX[self.VALUE_Q_TABLE[self.selectedIndexValueQ]]?.int32Value)!
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setQValue(valQ, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SetQValueのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSetQValue失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SetQValueの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSetQValue失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("SetQValueのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイス周波数値書き込み */
    func configerWriteFrequency()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ 周波数 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        var frequencyAutoList:Array<Any> = []
        //選択されたインデックスから、RWに書き込む値を取り出す
        let frequencyChannel:Int32 = (self.FREQUENCY_INDEX[self.FREQUENCY_TABLE[self.selectedIndexFrequency]]?.int32Value)!
        
        //自動の場合、周波数選択画面で設定した複数チャネル設定を取得し、設定する
         if frequencyChannel == FrequencyChannelType.auto.rawValue {
             print("コンボ選択Auto")
             var list:Array<Any> = []
             let ud = UserDefaults.standard
             if let savelist = ud.array(forKey: AUTO_FREQUENCY_CHANNEL_KEY) {
                 list = savelist;
             }
             else {
                 let defAutoList = ToolCommon.getFwDefFrequencyAutoList(model: model)
                 list = defAutoList;
             }
             var autolist:Array<Any> = []
             for val in list {
                 if val as! NSNumber != NSNumber(value:FREQUENCY_CHANNEL_SKIP) {
                     autolist.append(val)
                 }
             }
             frequencyAutoList = autolist
             print("write frequencyAutoList = \(frequencyAutoList)")
         }
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setFrequency(frequencyChannel, autoFrequencyList: frequencyAutoList, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SetFrequencyのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSetFrequency失敗 code=%d Extended=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SetFrequencyの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSetFrequency失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("SetFrequencyのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイストリガーモード設定書き込み */
    func configerWriteTriggerSwMode()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ トリガーモード ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        let valTrigMode:Int32 = (self.TRIGGER_SW_INDEX[self.TRIGGER_SW_TABLE[self.selectedIndexTrigger]]?.int32Value)!
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setTriggerSwMode(valTrigMode, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SetTriggerSwModeのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSetTriggerSwMode失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SetTriggerSwModeの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSetTriggerSwMode失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("SetTriggerSwModeのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /** デバイス省電力設定書き込み */
    func configerWriteSavingEnergy()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        // ■ 省電力設定 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setSavingEnergy(self.valEnergy, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SetSavingEnergyのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSetSavingEnergy失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SetSavingEnergyの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSetSavingEnergy失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("SetSavingEnergyのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /**
     タグ読取モード設定情報書き込み
     @return BOOL 結果
     */
    func configerWriteTagReadMode()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ タグ読取モード◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        var valTagSpeed:UInt = 0
        var valMillerSubCarrier:UInt = 0
        self.getTagReadModeInfo(readmode: selectedIndexTagReadMode,tagSpeed: &valTagSpeed,millerSubCarrier: &valMillerSubCarrier)
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setTagReadMode(Int32(valTagSpeed),millerSubCarrier: Int32(valMillerSubCarrier), callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("setTagReadModeのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックsetTagReadMode失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("setTagReadModeの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドsetTagReadMode失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("setTagReadModeのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /**
     タグ速度ミラー副搬送波設定取得処理
     @param readmode 読取モード
     @param tagSpeed タグ速度設定
     @param millerSubCarrier ミラー副搬送波設定
     */
    func getTagReadModeInfo(readmode:Int,tagSpeed:inout UInt,millerSubCarrier:inout UInt) {

        if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
            switch readmode {
            case TagReadModeTypeTruncate.T_FM0.rawValue:
                tagSpeed = TagReadSpeedType.FM0Type.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_FM0MediumSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.FM0MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller2LowSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.LowSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller2Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller2HighSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller2Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller4LowSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.LowSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller4HighSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller8LowSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.LowSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller8Type.rawValue
                break;
            case TagReadModeTypeTruncate.T_Miller8HighSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller8Type.rawValue
                break;
            default:
                tagSpeed = TagReadSpeedType.MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            }

        }
        else{
            switch readmode {
            case TagReadModeType.Miller2MediumSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller2Type.rawValue
                break;
            case TagReadModeType.Miller2HighSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller2Type.rawValue
                break;
            case TagReadModeType.Miller4MediumSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeType.Miller4HighSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            case TagReadModeType.Miller8MediumSpeedType.rawValue:
                tagSpeed = TagReadSpeedType.MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller8Type.rawValue
                break;
            case TagReadModeType.Miller8THighSpeedype.rawValue:
                tagSpeed = TagReadSpeedType.HighSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller8Type.rawValue
                break;
            default:
                tagSpeed = TagReadSpeedType.MediumSpeedType.rawValue
                millerSubCarrier = TagReadMillerType.Miller4Type.rawValue
                break;
            }

        }

    }
    
    /**
     フラグAB設定情報書き込み
     @return BOOL 結果
     */
    func configerWriteFlagAB()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ フラグAB設定 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        var flagAB:UInt32 = 0
        if let flag = self.FLAG_AB_INDEX[self.FLAG_AB_TABLE[self.selectedIndexFlagAB]] {
            flagAB = UInt32(truncating: flag)
        }
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setFlagAB(flagAB, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("setFlagABのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックsetFlagAB失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("setFlagABの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドsetFlagAB失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("setFlagABのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    /**
     読取識別番号設定情報書き込み
     @return BOOL 結果
     */
    func configerWriteMisreadingPreventionSettings()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0
        
        // ■ 読取識別番号設定 ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
        //選択されたインデックスから、RWに書き込む値を取り出す
        var readingID:Int32 = 0
        if let tmp = self.MISREADING_PREVETION_SETTINGS_INDEX[self.MISREADING_PREVETION_SETTINGS_TABLE[self.selectedIndexMisreadingPreventionSettings]] {
            readingID = Int32(truncating: tmp)
        }
        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().setMisreadingPreventionSettings(readingID, callback:{(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("setMisreadingPreventionSettingsのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックsetMisreadingPreventionSettings失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("setMisreadingPreventionSettingsの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドsetMisreadingPreventionSettings失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            NSLog("setMisreadingPreventionSettingsのコールバック内で失敗している")
            return false
        }
        return true
    }

    /** デバイスに現在の設定内容を記録させる */
    func configerSaveMemory()-> Bool {
        var retVal:Int32 = 0
        let faseSemaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
        var callbackResult:Int32 = 0

        retVal = SharedRfidSupervision.sharedManager.getRfidSuite().saveMemory({(resultCode,resultCodeExtended) -> Void in
            do {
                defer { // スコープを抜けるときに実行される
                    faseSemaphore.signal()
                }
                callbackResult = resultCode
                
                if callbackResult != OPOS_SUCCESS {
                    print("SaveMemoryのコールバックに失敗 resultCode=\(resultCode)")
                    self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nコールバックSaveMemory失敗 code=%d", resultCode))
                    return
                }
            }
        })
        
        if retVal != OPOS_SUCCESS {
            print("SaveMemoryの関数実行失敗 retVal=\(retVal)")
            self.showDialog(title: "エラー", message: String(format: "設定の送信に失敗しました\nメソッドSaveMemory失敗 code=%d", retVal))
            return false
        }
        
        if (faseSemaphore.wait(timeout:.distantFuture) == .success) {
            print("待機解除")
        }
        
        if callbackResult != OPOS_SUCCESS {
            print("SaveMemoryのコールバック内で失敗している")
            return false
        }
        return true
    }
    
    // MARK: - UIPickerViewDelegate
    /** 列数を返す例 */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /** ピッカーに表示する行数を返す */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch comboMode {
        case ComboMode.ComboModePower:
            return POWER_TABLE.count
        case ComboMode.ComboModeValueQ:
            return VALUE_Q_TABLE.count
        case ComboMode.ComboModeFrequency:
            return FREQUENCY_TABLE.count
        case ComboMode.ComboModeTrigger:
            return TRIGGER_SW_TABLE.count
        case ComboMode.ComboModeTagReadMode:
            return TAG_READ_MODE_TABLE.count
        case ComboMode.ComboModeFlagAB:
            return FLAG_AB_TABLE.count
        case ComboMode.ComboModeMisreadingPreventionSettings:
            return MISREADING_PREVETION_SETTINGS_TABLE.count
        }
    }
    
    /** ピッカーに表示する内容を返す */
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        switch comboMode {
        case ComboMode.ComboModePower:
            return String(format: "%d:%@", (POWER_INDEX[POWER_TABLE[row]]?.intValue)!,POWER_TABLE[row])
        case ComboMode.ComboModeValueQ:
            return String(format: "%d:%@", (VALUE_Q_INDEX[VALUE_Q_TABLE[row]]?.intValue)!,VALUE_Q_TABLE[row])
        case ComboMode.ComboModeFrequency:
            return String(format: "%@",FREQUENCY_TABLE[row])
        case ComboMode.ComboModeTrigger:
            return String(format: "%@",TRIGGER_SW_TABLE[row])
        case ComboMode.ComboModeTagReadMode:
            return String(format: "%@",TAG_READ_MODE_TABLE[row])
        case ComboMode.ComboModeFlagAB:
            return String(format: "%@",FLAG_AB_TABLE[row])
        case ComboMode.ComboModeMisreadingPreventionSettings:
            return String(format: "%@",MISREADING_PREVETION_SETTINGS_TABLE[row])
        }
    }
    
    /** ピッカーの選択行が決まったとき */
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        // 1列目の選択された行数を取得
        let val0 = pickerView.selectedRow(inComponent: 0)
        
        print("\(val0)行目が選択")
        
        //選択されたインデックスを格納する
        if comboMode == ComboMode.ComboModePower {
            self.selectedIndexPower = val0
            //ボタンキャプションを、選択されたものに変更する
            self.powerSelectButton.setTitle(String(format: "%@:%@", self.POWER_INDEX[self.POWER_TABLE[self.selectedIndexPower]]!,self.POWER_TABLE[self.selectedIndexPower]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeValueQ {
            self.selectedIndexValueQ = val0
            self.valueQSelectButton.setTitle(String(format: "%@:%@", self.VALUE_Q_INDEX[self.VALUE_Q_TABLE[self.selectedIndexValueQ]]!,self.VALUE_Q_TABLE[self.selectedIndexValueQ]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeFrequency {
            self.selectedIndexFrequency = val0
            self.frequencySelectButton.setTitle(String(format: "%@",self.FREQUENCY_TABLE[self.selectedIndexFrequency]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeTrigger {
            self.selectedIndexTrigger = val0
            self.triggerSelectButton.setTitle(String(format: "%@",self.TRIGGER_SW_TABLE[self.selectedIndexTrigger]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeTagReadMode {
            self.selectedIndexTagReadMode = val0
            self.tagReadModeSelectButton.setTitle(String(format: "%@",self.TAG_READ_MODE_TABLE[self.selectedIndexTagReadMode]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeFlagAB {
            self.selectedIndexFlagAB = val0
            self.flagABSelectButton.setTitle(String(format: "%@",self.FLAG_AB_TABLE[self.selectedIndexFlagAB]), for:.normal)
        }
        else if comboMode == ComboMode.ComboModeMisreadingPreventionSettings {
            self.selectedIndexMisreadingPreventionSettings = val0
            self.MisreadingPreventionSettingsButton.setTitle(String(format: "%@",self.MISREADING_PREVETION_SETTINGS_TABLE[self.selectedIndexMisreadingPreventionSettings]), for:.normal)
            //"無効"以外が設定された場合、読み取りモードボタンを使用不可にする
            if(self.selectedIndexMisreadingPreventionSettings != 0){
                self.tagReadModeSelectButton.isEnabled = false;
            }
            else{
                self.tagReadModeSelectButton.isEnabled = true;
            }
        }

        //アニメーションで、じわじわと、ピッカーを非表示にする
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            let screenOrientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
            let screenBounds = UIScreen.main.bounds
            let screenHeight = (screenOrientation.isPortrait) ? screenBounds.size.height : screenBounds.size.width
            pickerView.frame = CGRect(x:pickerView.frame.origin.x,
            y:screenHeight,
            width:pickerView.frame.size.width,
            height:pickerView.frame.size.height)
        }, completion: { _ in
            pickerView.isHidden = true
            pickerView.selectRow(0, inComponent: 0, animated: false)
        })
        
        if comboMode == ComboMode.ComboModeFrequency {
            if self.FREQUENCY_TABLE[self.selectedIndexFrequency] == "Auto" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "frequencySegue")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - UI Event
    /**
     * ビューがタップされたとき
     */
    @objc func view_Tapped(sender:UITapGestureRecognizer) {
        print("タップされました．")
    }
    
    @IBAction func clickPowerSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModePower,selectedIndex: selectedIndexPower)
    }
    @IBAction func clickValueQSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeValueQ,selectedIndex: selectedIndexValueQ)
    }
    
    @IBAction func clickFrequencySelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeFrequency,selectedIndex: selectedIndexFrequency)
    }
    
    @IBAction func clickTriggerSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeTrigger,selectedIndex: selectedIndexTrigger)
    }
    
    /** タグ読取りモードピッカー表示 */
    @IBAction func clickTagReadModeSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeTagReadMode,selectedIndex: selectedIndexTagReadMode)
    }
    
    /** フラグABピッカー表示 */
    @IBAction func clickFlagABSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeFlagAB,selectedIndex: selectedIndexFlagAB)
    }

    /** 読取識別番号ピッカー表示 */
    @IBAction func clickMisreadingPreventionSettingsSelect(_ sender: Any) {
        showPicker(selectMode: ComboMode.ComboModeMisreadingPreventionSettings,selectedIndex: selectedIndexMisreadingPreventionSettings)
    }
    
    @IBAction func clickInit(_ sender: Any) {
        rememberToInitVal()
    }
    
    @IBAction func energySwitchChange(_ sender: Any) {
        valEnergy = self.energySavingSwitch.isOn ? Int32(EnergyType.sav.rawValue) : Int32(EnergyType.non.rawValue)
    }
    
    @IBAction func clickSaveButton(_ sender: Any) {
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
                                                                        self.showDialog(title: "エラー",message: "ファイル名を入力してください")
                                                                        return
                                                                    }
                                                                    //画面に設定されている内容をファイルに書き出す
                                                                    self.saveSettingToFile(fileName: fileName)
                                                                }
                                                            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickSettingReadFromDevice(_ sender: Any) {
        settingReadFromAllDevices()
    }
    
    /** 設定をデバイスに書き込む */
    @IBAction func clickSettingWeiteToDevice(_ sender: Any) {
        //クルクルアイコン　アニメーション開始 と　画面操作無効
        startFreeze()
        ToolCommon.globalThreadAsync(asyncProgram:  {()-> Void in
            do {
                defer {
                    self.stopFreeze()
                }
                if !self.configerWritePower() {
                    return
                }
                if !self.configerWriteQValue() {
                    return
                }
                if !self.configerWriteFrequency() {
                    return
                }
                if !self.configerWriteTriggerSwMode() {
                    return
                }
                if !self.configerWriteSavingEnergy() {
                    return
                }
                if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTagReadMode == TagReadModeDecision.AvailableTagReadMode.rawValue {
                    if !self.configerWriteTagReadMode() {
                        return
                    }
                }
                if !self.configerWriteFlagAB() {
                    return
                }
                if SharedRfidSupervision.sharedManager.getRfidSuite().isAvailableTruncate == TruncateDecision.AvailableTruncate.rawValue {
                    if !self.configerWriteMisreadingPreventionSettings() {
                        return
                    }
                }
                //最後にメモリに保存
                if !self.configerSaveMemory() {
                    return
                }
                //全ての設定書き込みが完了した時にメッセージを表示する
                self.showDialog(title: nil, message:"送信完了")
            }
        })
    }
}

