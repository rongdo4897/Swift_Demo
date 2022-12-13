//
//  SharedData.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved
//

import Foundation
class SharedData: NSObject {
    private var rfidSuite:TecRfidSuite
    private var dictionary:Dictionary<String, String>
    
    /** シングルトン */
    static let sharedManager = SharedData()
    
    private override init() {
        //RFIDライブラリの初期化
        rfidSuite=TecRfidSuite()
        dictionary = [:]
    }
    
    // MARK: - 公開メソッド
    /** SDKインスタンス取得 */
    func getRfidSuite()->TecRfidSuite {
        return rfidSuite
    }
    
    /** 排他処理 */
    public func synchronized(obj: AnyObject, closure: () -> Void) {
        objc_sync_enter(obj)
        closure()
        objc_sync_exit(obj)
    }
    
    /** データをキーとともに追加します */
    func setData(anObject:String,aKey:String) {
        synchronized(obj: dictionary as AnyObject) {
            dictionary[aKey] = anObject
        }
    }
    
    /** 指定したキーに対応するデータを返します */
    func getDataForKey(aKey:String)->String {
        if let val = dictionary[aKey] {
            return val
        }
        return ""
    }

    /** 指定したキーと、それに対応するデータを、辞書から削除します */
    func removeDataForKey(aKey:String) {
        synchronized(obj: dictionary as AnyObject) {
            dictionary[aKey] = nil
        }
    }
}
