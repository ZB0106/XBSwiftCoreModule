//
//  +ocapty.swift
//  XbTestDemo
//
//  Created by xbing on 2021/4/9.
//

import UIKit

extension XBTransitionAnimation {
    func xbTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            fatalError("转场动画失败")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            fatalError("转场动画失败")
        }
        //由于push只展示最上层的 view，present展示所有的view所以要区别对待
        if !isShow && !isPush {
            fromVC.view.removeFromSuperview()
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        var transitionType: UIInputViewController.XBTransitionAnimationType
        if !isShow {
            transitionType = fromVC.xbTransitionType
        } else {
            transitionType = toVC.xbTransitionType
        }
        switch transitionType {
        case .ocapcityScale:
            do {
                //根据比率计算alpha动画的时间
                let maxRadius = containerView.bounds.height-20.0
                
                //透明度动画所需时间
                let opacityDuration = Double(containerView.bounds.width/2.0/maxRadius)*duration
                //透明度动画开始时间
        //        var opacityBegintime = CACurrentMediaTime()
                var opacityBegintime = 0.0
                
                var scaleFromValue: CGFloat = 0.01
                var scaleToValue: CGFloat = maxRadius
                var opacityFromValue: CGFloat = 0.01
                var opacityToValue: CGFloat = 1
                if !isShow {
                    scaleFromValue = maxRadius
                    scaleToValue = 0.01
                    opacityFromValue = 1
                    opacityToValue = 0.01
                    opacityBegintime = opacityBegintime+duration-opacityDuration
                }
                
                //关闭layer的隐式动画
                CATransaction.setDisableActions(true)
                
                ///添加动画
                let layer = CAShapeLayer()
                layer.frame = CGRect(origin: CGPoint(x: containerView.bounds.width/2.0, y: maxRadius), size: CGSize(width: 2.0, height: 2.0))
                
                let path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 1.0)
                layer.path = path.cgPath
                layer.fillColor = UIColor.black.cgColor
                containerView.layer.addSublayer(layer)
                
                ///缩放动画
                let scaleAni = CABasicAnimation(keyPath: "transform.scale")
                scaleAni.fromValue = scaleFromValue
                scaleAni.toValue = scaleToValue
                scaleAni.timingFunction = CAMediaTimingFunction(name: .linear)
                scaleAni.duration = duration
                scaleAni.isRemovedOnCompletion = false
                scaleAni.fillMode = .forwards
                ///透明度动画
                let opacityAni = CABasicAnimation(keyPath: "opacity")
                opacityAni.fromValue = opacityFromValue
                opacityAni.toValue = opacityToValue
                opacityAni.timingFunction = CAMediaTimingFunction(name: .linear)
                opacityAni.isRemovedOnCompletion = false
                opacityAni.fillMode = .forwards
                opacityAni.beginTime = opacityBegintime
                opacityAni.duration = opacityDuration
                
                //组动画
                let group = CAAnimationGroup()
                group.animations = [scaleAni, opacityAni]
                group.delegate = self
                group.duration = duration
                layer.add(group, forKey: "CirlleTransition")
                
                
                ///视图层级: 1) push: push时只会添加最上层的控制器，其他控制器的视图不会出现在视图层级结构中 UIWindow->UITransationView->UIDropShadowView->UInavigationController:UILayoutContainerView->UINavigationTransitionView->UIViewControllerWrapperView->topViewController.View
                    ///2)present: UIWindow->UITransationView->UIDropShadowView->UITransationView->presenentVC->UITransationView->presenentVC....
                
                animationBlock = { (finished) in
                    transitionContext.completeTransition(true)
                    layer.removeFromSuperlayer()
                    //采用push方式时需要手动添加fromView的view
                    if toVC.view.superview == nil {
                        containerView.addSubview(toVC.view)
                    }
                }
            }
        default:
            break
        }
    }
}
