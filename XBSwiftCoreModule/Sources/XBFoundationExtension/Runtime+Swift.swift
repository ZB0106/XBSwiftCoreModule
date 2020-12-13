//
//  Runtime+Swift.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/8.
//

import UIKit


protocol XBRuntimeProtocol: class {
    static func awake()
    static func swizzleMethodForClass(cls: AnyClass, oldSel: Selector, newSel: Selector)
}

extension XBRuntimeProtocol {
    static func swizzleMethodForClass(cls: AnyClass, oldSel: Selector, newSel: Selector) {
        let oriM = class_getInstanceMethod(cls, oldSel)
        let newM = class_getInstanceMethod(cls, newSel)
        guard (oriM != nil && newM != nil) else {
            return
        }
        if class_addMethod(cls, oldSel, method_getImplementation(newM!), method_getTypeEncoding(newM!)) {
            class_replaceMethod(cls, newSel, method_getImplementation(oriM!), method_getTypeEncoding(oriM!))
        } else {
            method_exchangeImplementations(oriM!, newM!)
        }
    }
}
extension UIApplication {
    private static let runOnce: Void = {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? XBRuntimeProtocol.Type)?.awake()
        }
        
    }()
    open override var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}
