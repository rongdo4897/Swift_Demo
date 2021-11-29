//
//  RuntimeKey.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import Foundation

struct RuntimeKey {
    /*
     UnsafeRawPointer: Một con trỏ thô để truy cập dữ liệu chưa được định kiểu.
     */
    static let zm_playgroundKey = UnsafeRawPointer.init(bitPattern: "zm_playgroundKey".hashValue)
    static let zm_animatorKey = UnsafeRawPointer.init(bitPattern: "zm_animatorKey".hashValue)
    static let zm_snapBehavior = UnsafeRawPointer.init(bitPattern: "zm_snapBehaviorKey".hashValue)
    static let zm_attachmentBehavior = UnsafeRawPointer.init(bitPattern: "zm_attachmentBehaviorKey".hashValue)
    static let zm_panGesture = UnsafeRawPointer.init(bitPattern: "zm_panGestureKey".hashValue)
    static let zm_centerPoint = UnsafeRawPointer.init(bitPattern: "zm_centerPointKey".hashValue)
    static let zm_damping = UnsafeRawPointer.init(bitPattern: "zm_dampingKey".hashValue)
}
