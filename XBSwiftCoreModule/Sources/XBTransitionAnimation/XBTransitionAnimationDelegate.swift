//
//  XBTransitionAnimation.swift
//  Alamofire
//
//  Created by xbing on 2021/4/8.
//

import UIKit

class XBTransitionAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        XBTransitionAnimation(true, false)
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        XBTransitionAnimation(false, false)
    }
    
    //navi
    @available(iOS 7.0, *)
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return XBTransitionAnimation(false, true)
        } else if operation == .push {
            return XBTransitionAnimation(true, true)
        } else {
            return nil
        }
    }
}
fileprivate struct XBTransitionDelegateKey {
    static var viewControllerTransitionKey = "viewControllerTransitionKey"
    static var naviControllerTransitionKey = "naviControllerTransitionKey"
    static var transitionAnimationDurationKey = "transitionAnimationDurationKey"
    static var transitionAnimationTypeKey = "transitionAnimationTypeKey"
}


extension UIViewController {

    public enum XBTransitionAnimationType: Int {
        case none = 0
        case ocapcityScale = 1
    }

    public func XBTransitonPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.xbViewControllerTransitionDelegate = XBTransitionAnimationDelegate()
        self.present(viewControllerToPresent, animated: true, completion: completion)
    }
    private var xbViewControllerTransitionDelegate: UIViewControllerTransitioningDelegate? {
        set {
            self.transitioningDelegate = newValue
            self.modalPresentationStyle = .custom
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
                duration = 0.5
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
    //为了持有delegate 防止释放
    private var xbNaviControllerTransitionDelegate: UINavigationControllerDelegate? {
        set {
            self.delegate = newValue
            objc_setAssociatedObject(self, &XBTransitionDelegateKey.naviControllerTransitionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &XBTransitionDelegateKey.naviControllerTransitionKey) as? UINavigationControllerDelegate
        }
    }
    public func XBTransitionPushViewController(_ viewController: UIViewController, animated: Bool) {
        self.xbNaviControllerTransitionDelegate = XBTransitionAnimationDelegate()
        self.pushViewController(viewController, animated: animated)
    }
}
