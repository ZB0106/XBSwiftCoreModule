//
//  XBTransitionAnimation.swift
//  Alamofire
//
//  Created by xbing on 2021/4/8.
//

import UIKit

class XBTransitionAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    deinit {
        #if DEBUG
        print(self,#function)
        #endif
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.xbTransitionType == .none {
            return nil
        }
        return XBTransitionAnimation(true, false)
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.xbTransitionType == .none {
            return nil
        }
        return XBTransitionAnimation(false, false)
    }
    
    //navi
    @available(iOS 7.0, *)
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            if fromVC.xbTransitionType == .none {
                return nil
            }
            return XBTransitionAnimation(false, true)
        } else if operation == .push {
            if toVC.xbTransitionType == .none {
                return nil
            }
            return XBTransitionAnimation(true, true)
        } else {
            return nil
        }
    }
}
fileprivate struct XBTransitionDelegateKey {
    static var viewControllerTransitionKey = "viewControllerTransitionKey"
    static var transitionAnimationDurationKey = "transitionAnimationDurationKey"
    static var transitionAnimationTypeKey = "transitionAnimationTypeKey"
}


extension UIViewController {

    public enum XBTransitionAnimationType: Int {
        case none = 0
        case ocapcityScale = 1
    }

    public func XBTransitonPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        let delegate = XBTransitionAnimationDelegate()
        viewControllerToPresent.xbViewControllerTransitionDelegate = delegate
        viewControllerToPresent.transitioningDelegate = delegate
        viewControllerToPresent.modalPresentationStyle = .custom
        
        self.present(viewControllerToPresent, animated: true, completion: completion)
    }
    fileprivate var xbViewControllerTransitionDelegate: NSObjectProtocol? {
        set {
            objc_setAssociatedObject(self, &XBTransitionDelegateKey.viewControllerTransitionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &XBTransitionDelegateKey.viewControllerTransitionKey) as? UIViewControllerTransitioningDelegate
        }
    }
    //浮点数需要使用nsnumber 包装下，其他普通数据不需要
    public var xbTransitionAnimationDuration: TimeInterval {
        set {
            let num = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &XBTransitionDelegateKey.transitionAnimationDurationKey, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var duration = (objc_getAssociatedObject(self, &XBTransitionDelegateKey.transitionAnimationDurationKey) as? NSNumber)?.doubleValue
            if duration == nil || duration == 0 {
                duration = 0.24
            }
            return duration!
        }
    }
    //浮点数需要使用nsnumber 包装下，其他普通数据不需要
    public var xbTransitionType: XBTransitionAnimationType {
        set {
            let value = newValue.rawValue
            objc_setAssociatedObject(self, &XBTransitionDelegateKey.transitionAnimationTypeKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            guard let rawValue = (objc_getAssociatedObject(self, &XBTransitionDelegateKey.transitionAnimationTypeKey) as? Int) else {
                return .none
            }
            
            return XBTransitionAnimationType.init(rawValue: rawValue) ?? .none
        }
    }
}

extension UINavigationController {
    
    public func XBTransitionPushViewController(_ viewController: UIViewController, animated: Bool) {
        
        ///防止delegate提前释放，保证delegate能跟随viewcontroller一起释放,以及保证vc push和pop的动画一致性
        var tmDelegate = delegate
        if tmDelegate == nil {
            tmDelegate = XBTransitionAnimationDelegate()
            delegate = tmDelegate
        }
        //XBTransitionPushViewController被调用就会是tmDelegate retaincout+1
        viewController.xbViewControllerTransitionDelegate = tmDelegate
        self.pushViewController(viewController, animated: animated)
    }
}
