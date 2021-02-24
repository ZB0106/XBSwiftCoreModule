//
//  UIControl_XBEx.swift
//  XBWorkSumary
//
//  Created by 苹果兵 on 2020/11/1.
//

import UIKit
//import ObjectiveC



extension UIControl {
    
    private struct XBControlAssociatedKey {
        static var timeKey = "controlextimekey"
        static var enventKey = "controlextimekey"
    }
    /// 按钮防止连续点击
    /// - Parameters:
    ///   - timeInterval: 默认0.5
    ///   - event: 默认 upinside
    public func avoidSeriasClick(timeInterval: CGFloat = 0.5, event: UIControl.Event = .touchUpInside) {
        
        self.avoidTimeInterVar = timeInterval
        self.avoidEvent = event.rawValue
        self.addTarget(self, action: #selector(xb_avoidSeriasClick), for: event)
    }
    
    @objc private func xb_avoidSeriasClick() {
        
        if self.avoidEvent == nil || self.avoidTimeInterVar == nil {
            return
        }
        let acts = self.actions(forTarget: self, forControlEvent: UIControl.Event(rawValue: self.avoidEvent!))
        var ishasAction = false
        if acts == nil || acts?.count == 0 {
            return
        }
        for (_ ,acStr) in acts!.enumerated() {
            if acStr == NSStringFromSelector(#selector(xb_avoidSeriasClick)) {
                ishasAction = true
                break
            }
        }
        if ishasAction {
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  DispatchTimeInterval.milliseconds(Int(self.avoidTimeInterVar!*1000))) { [weak self] in
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
    var avoidTimeInterVar: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &XBControlAssociatedKey.timeKey) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &XBControlAssociatedKey.timeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var avoidEvent: UInt? {
        get {
            return objc_getAssociatedObject(self, &XBControlAssociatedKey.enventKey) as? UInt
        }
        set {
            objc_setAssociatedObject(self, &XBControlAssociatedKey.enventKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

