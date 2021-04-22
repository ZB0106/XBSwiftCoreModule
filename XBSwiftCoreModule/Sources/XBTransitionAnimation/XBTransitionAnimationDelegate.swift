//
//  XBTransitionAnimation.swift
//  Alamofire
//
//  Created by xbing on 2021/4/8.
//

import UIKit


public let DefaultAnimationDuration = 0.24

public enum XBTransitionAnimationType {
    case system
    case ocapcityScale(CGPoint)
}

class XBTransitionAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    deinit {
        #if DEBUG
        print(self,#function)
        #endif
    }
    var transitonType: XBTransitionAnimationType = .system
    var xbTransitionAnimationDuration: TimeInterval = 0.24
    
    private func intialTransationAni(_ isShow: Bool, _ isPush: Bool) -> XBTransitionAnimation? {
        switch transitonType {
        case .system:
            return nil
        case .ocapcityScale:
            return XBTransitionAnimation(isShow, isPush, transitonType, xbTransitionAnimationDuration)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return intialTransationAni(true, false)
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return intialTransationAni(false, false)
    }
    //navi
    @available(iOS 7.0, *)
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            return intialTransationAni(false, true)
        } else if operation == .push {
            return intialTransationAni(true, true)
        } else {
            return nil
        }
    }
}

extension UIViewController {

    private struct XBTransitionDelegateKey {
        static var viewControllerTransitionKey = "viewControllerTransitionKey"
    }
    
    public func setXBTransitionType(transitonType: XBTransitionAnimationType, duration: TimeInterval = DefaultAnimationDuration, touchPostion: CGPoint? = nil, naviController: UINavigationController? = nil) {
       
        switch transitonType {
        case .system:
            break
        case .ocapcityScale:
            if naviController == nil {
                let delegate = XBTransitionAnimationDelegate()
                delegate.transitonType = transitonType
                delegate.xbTransitionAnimationDuration = duration
                
                self.xbViewControllerTransitionDelegate = delegate
                self.transitioningDelegate = delegate
                self.modalPresentationStyle = .custom
            } else {
                ///防止delegate提前释放，保证delegate能跟随viewcontroller一起释放,以及保证vc push和pop的动画一致性
                var tmDelegate = naviController?.delegate
                if tmDelegate == nil {
                    tmDelegate = XBTransitionAnimationDelegate()
                    (tmDelegate as? XBTransitionAnimationDelegate)?.transitonType = transitonType
                    (tmDelegate as? XBTransitionAnimationDelegate)?.xbTransitionAnimationDuration = duration
                    naviController?.delegate = tmDelegate
                }
                //XBTransitionPushViewController被调用就会是tmDelegate retaincout+1
                self.xbViewControllerTransitionDelegate = tmDelegate
            }
        }
    }
    fileprivate var xbViewControllerTransitionDelegate: NSObjectProtocol? {
        //浮点数需要使用nsnumber 包装下，其他普通数据不需要
        set {
            objc_setAssociatedObject(self, &XBTransitionDelegateKey.viewControllerTransitionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &XBTransitionDelegateKey.viewControllerTransitionKey) as? UIViewControllerTransitioningDelegate
        }
    }
}

