//
//  XBTools.swift
//  Alamofire
//
//  Created by xbing on 2020/12/7.
//

import Foundation
import Swift

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n", isNeedLog: Bool = false) {
    if isNeedLog {
        Swift.print(items, separator, terminator)
    } else {
        #if DEBUG
        Swift.print(items, separator, terminator)
        #endif
    }
}
