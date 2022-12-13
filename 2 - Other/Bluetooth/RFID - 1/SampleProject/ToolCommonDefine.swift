//
//  ToolCommonDefine.swift
//  UF-2200Sample
//
//  Created by AsnoShizuoka on 2018/07/19.
//  Copyright © 2018年 AsnoShizuoka. All rights reserved.
//
// 画面間で共通で使用するものの定義

import Foundation
/** ◆◆画面間データ
 ◆接続状態 0:未接続 1:接続
 */
let CONNECT_STATE="ConnectState"
let CNS_OFF="0"
let CNS_ON="1"

/** ◆再接続フラグ*/
let RECONNECT_ON="1"

/** ◆ファームウェアバージョン */
let FW_VER="FWVer"

/** ◆◆設定ファイル
 ◆Bluetoothアドレス
 */
let CFG_BD_ADRESS="BDAdress"

/** ◆継続リード用インターバル */
let CFG_ReadTimerInterval="ReadTimerInterval"

/** ◆◆画面間通知用
 ◆デバイスオフライン
 */
let NOTIF_DeviceOfflineNotification="DeviceOfflineNotification"

/** ◆デバイスオンライン */
let NOTIF_DeviceOnlineNotification="DeviceOnlineNotification"

/** ◆アプリケーションが、バックグラウンドにいった時*/
let NOTIF_applicationDidEnterBackground="applicationDidEnterBackground"

/** ◆アプリケーションが、バックグラウンドからフォアグラウンドに復帰した時（初回起動時は呼び出されない） */
let NOTIF_applicationWillEnterForeground="applicationWillEnterForeground"

/** ◆◆FWからのレスポンスコード
 ◆トリガースイッチOFF状態により、電波出ず
 */
let FW_RES_CODE_NOTRIG=0x15

/** ◆◆ファイル名定義
 ◆読み取り音ファイル名
 */
let SOUND_READ="readsound7"

/** BTアドレス長 */
let BT_MAC_ADRESS_LEN=12

let DEVICE_TYPE_KEY="DeviceType"
let DEVICE_TYPE_UF2200="UF-2200"
let DEVICE_TYPE_UF3000="UF-3000"

/** 機種モード */
enum DeviceMode: Int {
    /** UF-2200 */
    case UF2200Device = 0
    /** UF-3000*/
    case UF3000Device = 1
}

let AUTO_FREQUENCY_CHANNEL_KEY = "AutoFrequencyChannel"
let FREQUENCY_CHANNEL_SKIP = -1
