//
//  SharedRfidSupervision.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved
//

import Foundation
class SharedRfidSupervision: NSObject {
    private var rfidSuite:TecRfidSuite
    /** シングルトン */
    static let sharedManager = SharedRfidSupervision()
    
    private override init() {
        //RFIDライブラリの初期化
        rfidSuite=TecRfidSuite()
    }
    
    // MARK: - 公開メソッド
    /** SDKインスタンス取得 */
    func getRfidSuite()->TecRfidSuite {
        return rfidSuite
    }
}
