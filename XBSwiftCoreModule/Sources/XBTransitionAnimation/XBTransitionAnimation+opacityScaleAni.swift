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
        var transitionVC: UIViewController
        if !isShow {
            transitionVC = fromVC
        } else {
            transitionVC = toVC
        }
        switch xbtransitionType {
        case .ocapcityScale(let point):
            do {
                
                let containerView = transitionContext.containerView
                ///采用push方式时需要手动添加fromView的view 由于push只展示最上层的 view，present展示所有的view所以要区别对待
                ///视图层级:
                ///1) push: push时只会添加最上层的控制器，其他控制器的视图不会出现在视图层级结构中 UIWindow->UITransationView->UIDropShadowView->UInavigationController:UILayoutContainerView->UINavigationTransitionView->UIViewControllerWrapperView->topViewController.View
                ///2)present: UIWindow->UITransationView->UIDropShadowView->UITransationView->presenentVC->UITransationView->presenentVC....
                if toVC.view.superview == nil {
                    containerView.addSubview(toVC.view)
                    containerView.bringSubviewToFront(toVC.view)
                }
                ///创建动画layer
                let layer = CAShapeLayer()
                layer.frame = CGRect(origin: point, size: CGSize(width: 2.0, height: 2.0))
                
                let path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 1.0)
                layer.path = path.cgPath
                layer.fillColor = UIColor.black.cgColor
                containerView.layer.addSublayer(layer)
                
                
                let duration = transitionDuration(using: transitionContext)
                //根据比率计算alpha动画的时间 支持由下往上弹出
                let opacityDuration = Double(point.x/point.y)*duration

                var opacityBegintime = 0.0
                var scaleFromValue: CGFloat = 0.01
                var scaleToValue: CGFloat = point.y
                var opacityFromValue: CGFloat = 0.01
                var opacityToValue: CGFloat = 1
                var positonAniBegintime = opacityDuration
                let positonDuration = duration-opacityDuration
                var positionFromValue = containerView.bounds.maxY+containerView.center.y
                var positionToValue = containerView.center.y
                // backwards动画的起始状态 forwards 动画的最终状态
                var fillMode = CAMediaTimingFillMode.backwards
                if !isShow {
                    scaleFromValue = point.y
                    scaleToValue = 0.01
                    opacityFromValue = 1
                    opacityToValue = 0.01
                    opacityBegintime = opacityBegintime+duration-opacityDuration
                    
                    positonAniBegintime = 0.0
                    positionFromValue = containerView.center.y
                    positionToValue = containerView.bounds.maxY+containerView.center.y
                    fillMode = .forwards
                }
                
                //关闭layer的隐式动画
                CATransaction.setDisableActions(true)
                CATransaction.begin()
                //动画setCompletionBlock 需要设置在添加动画之前，否者block会被立即调用
                CATransaction.setCompletionBlock {
                    
                    toVC.view.layer.removeAllAnimations()
                    layer.removeFromSuperlayer()
                    fromVC.view.isHidden = false
                    toVC.view.isHidden = false
                    //必须添加tovc.view 才能调用completeTransition。否者有可能导致tovc.view 没被保存到prensent栈中，从而 在 dismiss的时候导致tovc.view无法被添加
                    //出现问题的流程->使用自定义转场动画present->VC1->使用系统动画Prensent->VC2,此时vc2->dismiss的时候会导致 vc1.view 无法添加上去，从而导致 transitionView在最上层覆盖
                    transitionContext.completeTransition(true)
                }
                ///缩放动画
                let scaleAni = CABasicAnimation(keyPath: "transform.scale")
                scaleAni.fromValue = scaleFromValue
                scaleAni.toValue = scaleToValue
                scaleAni.timingFunction = CAMediaTimingFunction(name: .linear)
                scaleAni.duration = duration
                scaleAni.isRemovedOnCompletion = false
                scaleAni.fillMode = fillMode
                ///透明度动画
                let opacityAni = CABasicAnimation(keyPath: "opacity")
                opacityAni.fromValue = opacityFromValue
                opacityAni.toValue = opacityToValue
                opacityAni.timingFunction = CAMediaTimingFunction(name: .linear)
                opacityAni.isRemovedOnCompletion = false
                opacityAni.fillMode = fillMode
                opacityAni.beginTime = CACurrentMediaTime()+opacityBegintime
                opacityAni.duration = opacityDuration
                
                ///layer移动动画
                let positionAni = CABasicAnimation(keyPath: "position.y")
                positionAni.fromValue = positionFromValue
                positionAni.toValue = positionToValue
                positionAni.timingFunction = CAMediaTimingFunction(name: .linear)
                positionAni.isRemovedOnCompletion = false
                positionAni.fillMode = fillMode
                positionAni.beginTime = CACurrentMediaTime()+positonAniBegintime
                positionAni.duration = positonDuration
                
                transitionVC.view.layer.add(positionAni, forKey: "positionAni")
                layer.add(opacityAni, forKey: "opacityAny")
                layer.add(scaleAni, forKey: "scaleAni")
                
                CATransaction.commit()
                
                //组动画
                //使用组动画是begintime不需要添加CACurrentMediaTime()
//                let group = CAAnimationGroup()
//                group.animations = [scaleAni, opacityAni]
//                group.delegate = self
//                group.duration = duration
//                layer.add(group, forKey: "CirlleTransition")
            }
        default:
            break
        }
    }
}
