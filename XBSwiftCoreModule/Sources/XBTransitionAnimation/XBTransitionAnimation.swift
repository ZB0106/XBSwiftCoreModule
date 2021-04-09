//
//  XBTransitionAnimation.swift
//  Alamofire
//
//  Created by xbing on 2021/4/8.
//
import UIKit


protocol XBTransitionAnimationProtocol: NSObjectProtocol {
    func xbTransition(using transitionContext: UIViewControllerContextTransitioning)
}
class XBTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning, XBTransitionAnimationProtocol {
    var isShow: Bool = true
    var isPush: Bool = true
    var animationBlock: ((Bool) ->())?
    init(_ isShow: Bool = true, _ isPush: Bool = true) {
        super.init()
        self.isShow = isShow
        self.isPush = isPush
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        var key: UITransitionContextViewControllerKey = .to
        if !isShow {
            key = .from
        }
        guard let trasitonVC = transitionContext?.viewController(forKey: key) else {
            fatalError("转场动画失败")
        }
        return trasitonVC.xbTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        XBTransitionAnimation
        xbTransition(using: transitionContext)
    }
    
}

extension XBTransitionAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationBlock?(flag)
        //置空释放内存
        animationBlock = nil
    }
    
}
