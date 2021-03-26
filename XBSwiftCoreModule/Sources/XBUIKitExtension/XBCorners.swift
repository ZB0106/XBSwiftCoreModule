//
//  XBCorners.swift
//  XBSwiftCoreModule
//
//  Created by xbing on 2021/3/25.
//

private final class XBCornerView: UIView {
    
    override class var layerClass: AnyClass {
        return XBCornerLayer.self
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _superView = superview else { return }
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
            let anchors = [
                leftAnchor.constraint(equalTo: _superView.leftAnchor),
                rightAnchor.constraint(equalTo: _superView.rightAnchor),
                topAnchor.constraint(equalTo: _superView.topAnchor),
                bottomAnchor.constraint(equalTo: _superView.bottomAnchor)
            ]
            anchors.forEach({$0.priority = .defaultLow})
            NSLayoutConstraint.activate(anchors)
        }
    }
}

private final class XBCornerLayer: CALayer {
    override func display() {
        super.contents = super.contents
        let size = bounds.size
        guard size != .zero else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        guard let bgColor = xbBgColor else { UIGraphicsEndImageContext(); return }
        ctx.setFillColor(bgColor)
        //        //单色选择最快的渲染方式
        ctx.interpolationQuality = CGInterpolationQuality.none
        var pathRect = bounds
        if shadowColor != nil {
            pathRect = bounds.insetBy(dx: abs(xbShadowOffset.width), dy: abs(xbShadowOffset.height))
            ctx.setShadow(offset: xbShadowOffset, blur: 0, color: xbShadowColor)
        }
        let path = UIBezierPath(roundedRect: pathRect, byRoundingCorners: corners, cornerRadii: CGSize(width: xbCornerRadius, height: xbCornerRadius))
//        CGContextBeginTransparencyLayer  //开启透明图层，用于绘制组合阴影
        ctx.addPath(path.cgPath)
        
        ctx.fillPath()
        //        ctx.fillPath()//包含ctx.closePath()，path.fill()
        //        ctx.drawPath(using: .fill)//包含ctx.closePath()，path.fill()
        //获取image
         let image = UIGraphicsGetImageFromCurrentImageContext()
        contents = image?.cgImage
        needsDisplayOnBoundsChange = false
        //结束context
        UIGraphicsEndImageContext()
    }
    
    internal var corners: UIRectCorner = [] {
        didSet {
            guard oldValue != corners else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbBgColor: CGColor? {
        didSet {
            guard oldValue != xbBgColor else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbCornerRadius: CGFloat = 0 {
        didSet {
            guard oldValue != xbCornerRadius else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbShadowOpacity: Float = 0 {
        didSet {
            guard oldValue != xbShadowOpacity else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbShadowOffset: CGSize = CGSize(width: 0, height: -3.0) {
        didSet {
            guard oldValue != xbShadowOffset else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbShadowRadius: CGFloat = 3.0 {
        didSet {
            guard oldValue != xbShadowRadius else {
                return
            }
            setNeedsDisplay()
        }
    }
    internal var xbShadowColor: CGColor? {
        didSet {
            guard oldValue != xbShadowColor else {
                return
            }
            setNeedsDisplay()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else {
                return
            }
            setNeedsDisplay()
            displayIfNeeded()
        }
    }
}

private struct XBCorerViewKey {
    static var cornerKey = "XBCorerViewKey"
}
extension UIView {
    
    
    public var cornerShadowView: UIView {
        if _cornerView == nil {
            _cornerView = XBCornerView()
            insertSubview(_cornerView!, at: 0)
        }
        return _cornerView!
    }
    private var _cornerView: XBCornerView? {
        get {
           return objc_getAssociatedObject(self, &XBCorerViewKey.cornerKey) as? XBCornerView
        }
        set {
            objc_setAssociatedObject(self, &XBCorerViewKey.cornerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func setCornerAndShow(corners: UIRectCorner, cornerRadius: CGFloat, bgColor: UIColor = UIColor.clear, shadowColor: UIColor? = nil, shadowOffSet: CGSize? = nil, shadowRadius: CGFloat? = nil, shadowOpacity: CGFloat = 1.0) {
        
        guard let cornerLayer = cornerShadowView.layer as? XBCornerLayer else { return }
        cornerLayer.corners = corners
        cornerLayer.xbCornerRadius = cornerRadius
        cornerLayer.xbShadowColor = shadowColor?.withAlphaComponent(shadowOpacity).cgColor
        cornerLayer.xbBgColor = bgColor.cgColor
        if let offset = shadowOffSet {
            cornerLayer.xbShadowOffset = offset
        }
        if let r = shadowRadius {
            cornerLayer.xbShadowRadius = r
        }
        //统一提交更新，刷新
        cornerLayer.layoutIfNeeded()
    }
}

extension UIImage {
    /// 根据corner绘制圆角图片，阴影图片只是做了偏移操作和一些其他的处理
    /// - Parameters:
    ///   - corners:
    ///   - cornerRadius:
    ///   - bgColor:
    ///   - shadowColor:
    ///   - shadowOffSet:
    ///   - shadowRadius:
    /// - Returns: Uiimage
    public class func cornerImage(corners: UIRectCorner, cornerRadius: CGFloat, bgColor: UIColor, shadowScale: CGFloat = 0) -> UIImage? {
        let size = cornerRadius*2
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        var rlSize = rect.size
        if rlSize.width <= 0 || rlSize.height <= 0 {
            rlSize = CGSize(width: 1, height: 1)
        }
         UIGraphicsBeginImageContextWithOptions(rlSize, false, shadowScale)
        let ctx = UIGraphicsGetCurrentContext()
//            kCGInterpolationLow：969毫秒
//            kCGInterpolationMedium：1690毫秒
//            kCGInterpolationHigh：2694毫秒
//            kCGInterpolationNone：545毫秒
        //单色图片不会影响效果所以选择最快的方式none
        ctx?.interpolationQuality = CGInterpolationQuality.none
        //绘制圆角路径
        let path = UIBezierPath(roundedRect:rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        //设置圆角路径填充色
        ctx?.setFillColor(bgColor.cgColor)
        //填充路径
        path.fill()
        //或者
//        ctx?.addPath(path.cgPath)
//        ctx?.fillPath()
        path.close()
        let image = UIGraphicsGetImageFromCurrentImageContext()?.stretchableImage(withLeftCapWidth: Int(cornerRadius), topCapHeight: Int(cornerRadius))
        UIGraphicsEndImageContext()
        return image
    }
}

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
