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
    var xbtransitionType: XBTransitionAnimationType = .system
    var xbTransitionAnimationDuration: TimeInterval = 0.24
    var animationBlock: ((Bool) ->())?
    init(_ isShow: Bool = true, _ isPush: Bool = true, _ xbtransitionType: XBTransitionAnimationType = .system, _ duration: TimeInterval) {
        super.init()
        self.isShow = isShow
        self.isPush = isPush
        self.xbtransitionType = xbtransitionType
        self.xbTransitionAnimationDuration = duration
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return xbTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        XBTransitionAnimation
        xbTransition(using: transitionContext)
    }
    
}
