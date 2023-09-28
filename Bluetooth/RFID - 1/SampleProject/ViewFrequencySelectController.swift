//
//  ViewFrequencySelectController.swift
//  UF-2200Sample
//
//  Created by H.Kobayashi[ASNO] on 2020/09/24.
//  Copyright © 2020年 TOSHIBA TEC CORPORATION. All rights reserved.
//

import UIKit
class ViewFrequencySelectController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var frequencydetailBtn: UIButton!
    @IBOutlet weak var saveFileBtn: UIButton!
    @IBOutlet weak var frequency01: UIButton!
    @IBOutlet weak var frequency02: UIButton!
    @IBOutlet weak var frequency03: UIButton!
    @IBOutlet weak var frequency04: UIButton!
    @IBOutlet weak var frequency05: UIButton!
    @IBOutlet weak var frequency06: UIButton!
    @IBOutlet weak var frequency07: UIButton!
    @IBOutlet weak var frequency08: UIButton!
    @IBOutlet weak var frequency09: UIButton!
    @IBOutlet weak var frequency10: UIButton!
    @IBOutlet weak var frequency11: UIButton!
    @IBOutlet weak var frequency12: UIButton!
    @IBOutlet weak var comboPickerView: UIPickerView!
    @IBOutlet weak var frequencyDetailView: UIView!
    
    
    private var model = JP3
    var tapBtn:UIButton!
    private var backupComboFramePosY:CGFloat = 0.0
    private var FREQUENCY_TABLE:Array<String> = []
    private var saveFrequencyList:Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        //共有ファームバージョンを、取り込む そして、デバイスの種別を判断する
        let firmVer = SharedData.sharedManager.getDataForKey(aKey: FW_VER)
        model = ToolCommon.checkModel(fullVer: firmVer)
        initFrequency()
        
        //デザインで配置されたピッカーの位置を保持しておく（この値は、ピッカを出したり隠したりする為に記憶しておく）
        backupComboFramePosY = self.comboPickerView.frame.origin.y
    }
    
        //Frequencyの値セット
    func initFrequency() {
        //    【特定省電力:JP1】　　　　　  　　　　　【登録局:JP3】
        //    1st:26ch　5th:17ch　9th:29ch　　　　　1st:skip　5th:17ch　9th:skip
        //    2nd:30ch　6th:11ch　10th:31ch　　　 2nd:skip　6th:11ch　10th:skip
        //    3rd:28ch  7th:23ch　11th:5ch　　    3rd:skip　7th:23ch　11th:5ch
        //    4th:32ch　8th:27ch　12th:skip　　　　  4th:skip　 8th:skip　12th:skip
        //    【特定省電力:JP4】                                  【登録局:JP6】
        //    1st:26ch　5th:17ch　9th:29ch                1st:skip　5th:17ch　 9th:skip
        //    2nd:skip　6th:11ch　10th:31ch               2nd:25ch 6th:11ch　 10th:skip
        //    3rd:28ch  7th:23ch　11th:5ch                 3rd:skip　7th:23ch　 11th:5ch
        //    4th:32ch　8th:skip　12th:skip                4th:skip   8th:skip　  12th:24ch
        
        if model == JP1 {
                        
            FREQUENCY_TABLE = ["5ch", "11ch", "17ch", "23ch", "24ch", "25ch", "26ch", "27ch", "28ch", "29ch", "30ch", "31ch", "32ch" , "skip"]
        }
        else if model == JP3 {
            FREQUENCY_TABLE = ["5ch", "11ch", "17ch", "23ch", "24ch", "25ch" , "skip"]
        }
        else if model == JP4 {
            FREQUENCY_TABLE = ["5ch", "11ch", "17ch", "23ch", "24ch", "25ch", "26ch", "27ch", "28ch", "29ch", "30ch", "31ch", "32ch", "skip"]
        }
        else if model == JP6 {
            FREQUENCY_TABLE = ["5ch", "11ch", "17ch", "23ch", "24ch", "25ch" , "skip"]
        }
        self.comboPickerView.delegate = self
        self.comboPickerView.dataSource = self
        
        let ud = UserDefaults.standard
        if let list = ud.array(forKey: AUTO_FREQUENCY_CHANNEL_KEY) {
            saveFrequencyList = list;
        }
        else {
            let defAutoList = ToolCommon.getFwDefFrequencyAutoList(model: model)
            saveFrequencyList = defAutoList;
        }

        readFrequencyFile()
    }

    func readFrequencyFile() {
        var btnNameList:Array<String> = []
        for i in 0..<saveFrequencyList.count {
            let frenquecnyName = saveFrequencyList[i]
            if frenquecnyName as! NSObject ==  NSNumber(value:FREQUENCY_CHANNEL_SKIP) {
                btnNameList.append("skip")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch05.rawValue) {
                btnNameList.append("5ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch11.rawValue) {
                btnNameList.append("11ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch17.rawValue) {
                btnNameList.append("17ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch23.rawValue) {
                btnNameList.append("23ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch24.rawValue) {
                btnNameList.append("24ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch25.rawValue) {
                btnNameList.append("25ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch26.rawValue) {
                btnNameList.append("26ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch27.rawValue) {
                btnNameList.append("27ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch28.rawValue) {
                btnNameList.append("28ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch29.rawValue) {
                btnNameList.append("29ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch30.rawValue) {
                btnNameList.append("30ch")
            } else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch31.rawValue) {
                btnNameList.append("31ch")
            }else if frenquecnyName as! NSObject == NSNumber(value:FrequencyLowChannelType.ch32.rawValue) {
                btnNameList.append("32ch")
            }
        }
        for i in 0..<12 {
            switch i {
            case 0:
                if (i <= btnNameList.count-1) {
                    self.frequency01.setTitle(btnNameList[0], for: .normal)
                }else{
                    self.frequency01.setTitle("skip", for: .normal)
                }
                break;
            case 1:
                if (i <= btnNameList.count-1) {
                    self.frequency02.setTitle(btnNameList[1], for: .normal)
                }else{
                    self.frequency02.setTitle("skip", for: .normal)
                }
                break;
            case 2:
                if (i <= btnNameList.count-1) {
                    self.frequency03.setTitle(btnNameList[2], for: .normal)
                }else{
                    self.frequency03.setTitle("skip", for: .normal)
                }
                break;
            case 3:
                if (i <= btnNameList.count-1) {
                    self.frequency04.setTitle(btnNameList[3], for: .normal)
                }else{
                    self.frequency04.setTitle("skip", for: .normal)
                }
                break;
            case 4:
                if (i <= btnNameList.count-1) {
                    self.frequency05.setTitle(btnNameList[4], for: .normal)
                }else{
                    self.frequency05.setTitle("skip", for: .normal)
                }
                break;
            case 5:
                if (i <= btnNameList.count-1) {
                    self.frequency06.setTitle(btnNameList[5], for: .normal)
                }else{
                    self.frequency06.setTitle("skip", for: .normal)
                }
                break;
            case 6:
                if (i <= btnNameList.count-1) {
                    self.frequency07.setTitle(btnNameList[6], for: .normal)
                }else{
                    self.frequency07.setTitle("skip", for: .normal)
                }
                break;
            case 7:
                if (i <= btnNameList.count-1) {
                    self.frequency08.setTitle(btnNameList[7], for: .normal)
                }else{
                    self.frequency08.setTitle("skip", for: .normal)
                }
                break;
            case 8:
                if (i <= btnNameList.count-1) {
                    self.frequency09.setTitle(btnNameList[8], for: .normal)
                }else{
                    self.frequency09.setTitle("skip", for: .normal)
                }
                break;
            case 9:
                if (i <= btnNameList.count-1) {
                    self.frequency10.setTitle(btnNameList[9], for: .normal)
                }else{
                    self.frequency10.setTitle("skip", for: .normal)
                }
                break;
            case 10:
                if (i <= btnNameList.count-1) {
                    self.frequency11.setTitle(btnNameList[10], for: .normal)
                }else{
                    self.frequency11.setTitle("skip", for: .normal)
                }
                break;
            case 11:
                if (i <= btnNameList.count-1) {
                    self.frequency12.setTitle(btnNameList[11], for: .normal)
                }else{
                    self.frequency12.setTitle("skip", for: .normal)
                }
                break;
                
            default:
                break;
            }
        }
    }
    
    func createFrequencyFile() {
        //ボタンに表示されている文言で、登録する数値を判別
        saveFrequencyList = []
        let btnArray = [
            self.frequency01.titleLabel?.text,self.frequency02.titleLabel?.text,self.frequency03.titleLabel?.text,self.frequency04.titleLabel?.text,self.frequency05.titleLabel?.text,self.frequency06.titleLabel?.text,self.frequency07.titleLabel?.text,self.frequency08.titleLabel?.text,self.frequency09.titleLabel?.text,self.frequency10.titleLabel?.text,self.frequency11.titleLabel?.text,self.frequency12.titleLabel?.text]
        for i in 0..<btnArray.count {
            let btnName = btnArray[i]
            var number = NSNumber(value:FREQUENCY_CHANNEL_SKIP)
            if btnName == "skip" {
                number = NSNumber(value:FREQUENCY_CHANNEL_SKIP)
            }else if btnName == "5ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch05.rawValue)
            }else if btnName == "11ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch11.rawValue)
            }else if btnName == "17ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch17.rawValue)
            }else if btnName == "23ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch23.rawValue)
            }else if btnName == "24ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch24.rawValue)
            }else if btnName == "25ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch25.rawValue)
            }else if btnName == "26ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch26.rawValue)
            }else if btnName == "27ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch27.rawValue)
            }else if btnName == "28ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch28.rawValue)
            }else if btnName == "29ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch29.rawValue)
            }else if btnName == "30ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch30.rawValue)
            }else if btnName == "31ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch31.rawValue)
            }else if btnName == "32ch" {
                number = NSNumber(value:FrequencyLowChannelType.ch32.rawValue)
            }
            saveFrequencyList.append(number)
        }
    }
    
    // MARK: - UIPickerViewDelegate
    /** 列数を返す例 */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
     /** ピッカーに表示する行数を返す */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FREQUENCY_TABLE.count
    }
    
    /** ピッカーに表示する内容を返す */
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return String(format: "%@",FREQUENCY_TABLE[row])
    }
    
    /** ピッカーの選択行が決まったとき */
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        let val0 = pickerView.selectedRow(inComponent: 0)
        self.tapBtn.setTitle(String(format: "%@",self.FREQUENCY_TABLE[val0]), for:.normal)
        pickerView.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    // MARK: - UI Event
    @IBAction func actionClickFrequency(_ sender: Any) {
        //一つのピッカーを使い廻すので、どのモードで動作しているのかを判断できるように
        self.tapBtn = sender as? UIButton;
        
        //モードを変更した後、ロードし直す
        self.comboPickerView.reloadAllComponents()

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
  
    @IBAction func changeCheckState(_ sender: Any) {
        self.frequencydetailBtn.isSelected = !self.frequencydetailBtn.isSelected
        if self.frequencydetailBtn.isSelected{
            self.frequencyDetailView.isHidden = false
        }
        else {
            self.frequencyDetailView.isHidden = true
        }
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        createFrequencyFile()
        
        let ud = UserDefaults.standard
        ud.set(saveFrequencyList, forKey: AUTO_FREQUENCY_CHANNEL_KEY)
        ud.synchronize()
        
        let alert:UIAlertController = UIAlertController(title:"設定を保存",
                                                        message: "設定を保存しました",
                                                        preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
}
