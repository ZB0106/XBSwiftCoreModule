//
//  XBUIImageExtension.swift
//  XBSwiftCoreModule
//
//  Created by xbing on 2021/2/24.
//

extension UIImage {
    /// 根据颜色生成图片
    /// - Parameters:
    ///   - color:
    ///   - size: 默认1
    /// - Returns:
    public func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        var rlSize = size
        if size.width <= 0 || size.height <= 0 {
            rlSize = CGSize(width: 1, height: 1)
        }
        let rect = CGRect(x: 0, y: 0, width: rlSize.width, height: rlSize.height)
         UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 给图片添加颜色描边
    /// - Parameters:
    ///   - inset:
    ///   - color:
    /// - Returns:
    public func image(withInset inset: UIEdgeInsets = UIEdgeInsets.zero, color: UIColor) -> UIImage? {
        if inset == UIEdgeInsets.zero {
            return self
        }
        var size = self.size
        size.width -= inset.left+inset.right
        size.height -= inset.top+inset.bottom
        if size.width <= 0 || size.height <= 0 {
            return self;
        }
        let rect = CGRect(x: -inset.left, y: -inset.top, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        path.addRect(rect)
        ctx?.addPath(path)
        ctx?.fillPath()
        
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 图片切圆角 并添加边框，此方法设置圆角比较优秀，不会有离屏渲染，使用系统的layer设置圆角和board会有离屏渲染
    /// - Parameters:
    ///   - radius:
    ///   - corners:
    ///   - borderWidth:
    ///   - borderColor:
    ///   - borderLineJion:
    /// - Returns:
    public func imageByRoundCorner(radius: CGFloat, ivSize: CGSize = CGSize.zero,corners: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, borderLineJion: CGLineJoin = CGLineJoin.round) -> UIImage? {
        
        var realSize = self.size
        if ivSize != CGSize.zero {
            realSize = ivSize
        }
        UIGraphicsBeginImageContextWithOptions(realSize, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: realSize.width, height: realSize.height)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -rect.size.height)
        let minSize = min(realSize.width, realSize.height)
        if borderWidth < minSize / 2 {
            //cornerRadii 中 cgsiz.height 个人感觉没有用 好像听说是苹果api的遗留问题
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            ctx?.saveGState()
            path.addClip()
            ctx?.draw(self.cgImage!, in: rect)
            ctx?.restoreGState()
        }
        if borderWidth >= 0 && borderColor != nil && borderWidth < minSize / 2 {
            let strokeInset = (floor(borderWidth*self.scale)+0.5) / self.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJion
            borderColor?.setStroke()
            path.stroke()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    //网络图片转换为2x图和3x图,网络下载默认为2x图需要缩放一下
    public func scaledToXImage(scale: CGFloat) -> UIImage? {
        guard let cgimage = self.cgImage else {
            return self
        }
        let realSize = CGSize(width: self.size.width/scale, height: self.size.height/scale)
//        let realSize = self.size
        //第三个参数scale理解为每个物理像素点放几个像素，比如2倍屏放两个
        UIGraphicsBeginImageContextWithOptions(realSize, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: realSize.width, height: realSize.height)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -rect.size.height)
        ctx?.draw(cgimage, in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
}

