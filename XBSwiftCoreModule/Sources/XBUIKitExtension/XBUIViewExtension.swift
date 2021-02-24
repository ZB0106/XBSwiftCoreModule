//
//  XBUIViewExtension.swift
//  XBSwiftCoreModule
//
//  Created by xbing on 2021/2/24.
//


extension UIView {
    
    private struct XBShapLayerKey {
        static var shapLayerKey = "HasShapLayer"
    }
    ////给view添加圆角以及shadow
    private var shapLayer: CAShapeLayer? {
        set {
            objc_setAssociatedObject(self, &XBShapLayerKey.shapLayerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_getAssociatedObject(self, &XBShapLayerKey.shapLayerKey) as? CAShapeLayer ?? nil
        }
    }
    
    public func addCornerAndShow(corners: UIRectCorner, rect: CGRect, cornerRadius: CGFloat, bgColor: UIColor, shadowColor: UIColor? = nil, shadowOffSet: CGSize? = nil, shadowRadius: CGFloat? = nil) {
        if shapLayer == nil {
            let layer = CAShapeLayer()
            shapLayer = layer
            self.layer.insertSublayer(layer, at: 0)
            //会出现离屏渲染
//            self.layer.mask = shapLayer
        }
        //bounds不同时重新绘制
        if !shapLayer!.bounds.equalTo(rect) {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            shapLayer?.path = path.cgPath
            shapLayer?.fillColor = bgColor.cgColor
            shapLayer?.shadowColor = shadowColor?.cgColor
            if let offset = shadowOffSet {
                shapLayer?.shadowOffset = offset
            }
            if let r = shadowRadius {
                shapLayer?.shadowRadius = r
            }
        }
    }
}

