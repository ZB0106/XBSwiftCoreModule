//
//  XBSourceTimer.swift
//  XBSwiftCoreModule
//
//  Created by 苹果兵 on 2020/12/13.
//
import Foundation

private let XBTimerQueueLabel = "com.XBTimerQueueLabel"

//timer在suspend状态时不能赋值为空否者会崩溃,赋值为空会蹦 why？
public class XBSourceTimer: NSObject {
    
    deinit {
        print("XBSourceTimer deinit")
    }
    public init(timeInterval: Int, target: AnyObject, selector: Selector, repeats: Bool = true) {
        //timer
        super.init()
        self.timerSem = DispatchSemaphore(value: 1)
        self.timerQueue = DispatchQueue(label: XBTimerQueueLabel)
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: self.timerQueue!)
        self.timer?.schedule(deadline: .now()+DispatchTimeInterval.seconds(timeInterval), repeating: DispatchTimeInterval.seconds(timeInterval), leeway: .milliseconds(100))
        self.timer?.setEventHandler(handler: { [weak target] in
            guard let target = target, let method = class_getInstanceMethod(type(of: target), selector) else { return }
            let imp = method_getImplementation(method)
            //无参数和返回值的方法
            typealias Function = @convention(c) (AnyObject, Selector) -> Void
            let methodFunc = unsafeBitCast(imp, to: Function.self)
            methodFunc(target, selector)
        })
        
        //）执行IMP void (*func)(id, SEL, id) = (void *)imp;  func(self, methodName,param);
//        注意分析：如果方法没有传入参数时：void (*func)(id, SEL) = (void *)imp;   func(self, methodName);
//        如果方法传入一个参数时：void (*func)(id, SEL,id) = (void *)imp;   func(self, methodName,param);
//        如果方法传入俩个参数时：void (*func)(id, SEL,id,id) = (void *)imp;   func(self, methodName,param1,param2);
        
    }
    //调用类方法
    
//    func invoClassMethod() {
//        let selector = #selector(NSObject.copy)
//        guard let method = class_getClassMethod(type(of: self), selector) else { return }
//        let imp = method_getImplementation(method)
//        typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
//        let meFunc = unsafeBitCast(imp, to: Function.self)
//        meFunc(self, selector, nil)
//    }
    
//    var methodFunc = resume
//    methodFunc()
    public func resume() {
        timerSem.wait()
        if reusmeCount == 0 {
            self.timer?.resume()
            reusmeCount = 1
        }
        timerSem.signal()
    }
    public func suspend() {
        timerSem.wait()
        if reusmeCount == 1 {
            self.timer?.suspend()
            reusmeCount = 0
        }
        timerSem.signal()
    }
    
    public func cancel() {
        timerSem.wait()
        if reusmeCount == 1 {
            self.timer?.cancel()
            self.timer = nil
        } else {
            self.timer?.resume()
            self.timer?.cancel()
            self.timer = nil
        }
        timerSem.signal()
    }
    
    private var reusmeCount: Int = 0
    private var timerSem: DispatchSemaphore!
    private var timer: DispatchSourceTimer?
    private var timerQueue: DispatchQueue?
    
}
