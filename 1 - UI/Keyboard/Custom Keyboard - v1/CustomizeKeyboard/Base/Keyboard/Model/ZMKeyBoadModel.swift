//
//  ZMKeyBoadModel.swift
//  SwiftProject
//
//  Created by 牛新怀 on 2018/7/6.
//  Copyright © 2018年 牛新怀. All rights reserved.
//

import UIKit

class ZMKeyBoadModel: NSObject {

    var keyBoadString: String? // Các chữ cái trên bàn phím
    var isCapital: Bool? = false // Kiểm tra xem có viết hoa không
    
    init(str: String, flag: Bool) {
        self.keyBoadString = str
        self.isCapital = flag
    }
}

extension ZMKeyBoadModel {
    
}
