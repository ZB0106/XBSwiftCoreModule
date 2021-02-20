//
//  XBCirclePageLayer.swift
//  XBSwiftCoreModule
//
//  Created by 苹果兵 on 2020/12/12.
//

import Foundation




class  XBCirclePageLayer: CALayer {
    
    public init(pageType: XBCirclePageControl.XBPageControlType = .multiple(), currentCount: Int, pageCount: Int) {
        self.pageType = pageType
        self.currentCount = currentCount
        self.pageCount = pageCount
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var pageCount = 0
    var currentCount = 0
    var selContents: CGImage?
    var norContents: CGImage?
    var pageType: XBCirclePageControl.XBPageControlType
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.contents = selContents
            } else {
                self.contents = norContents
            }
            self.setNeedsDisplay()
            self.displayIfNeeded()
        }
    }
    override func display() {
        //        ctx?.scaleBy(x: 1, y: -1)
        //        ctx?.translateBy(x: 0, y: -size.height)
        //centent 只能赋值cgimage类型，其他类型不生效
        super.contents = super.contents
        
        if bounds.height == 0 || bounds.width == 0 {
            return
        }
        if needsDisplayOnBoundsChange {
            needsDisplayOnBoundsChange = false
            norContents = nil
            selContents = nil
            contents = nil
        }
        guard norContents == nil || selContents == nil else { return }
        
        //  //先开启绘制上下文，再获取 否者ctx为nil
        let height = bounds.height
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        //翻转
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -bounds.size.height)
        //保存当前绘制样式，不包括内容
//            ctx?.saveGState()
        
        //清除当前的绘制内容
//            ctx?.clear(bounds)
        
        //有裁切时 先绘制r较大的selcontent
        //重新绘制selcontent
        //保存当前绘制样式，不包括内容
//            ctx?.saveGState()
        //恢复保存的绘制样式
//            ctx?.restoreGState(),不包括内容
        
        //重设clip
//            ctx?.resetClip()
        
        switch pageType {
        case .multiple(let subTypes):
            var r = height*0.8*0.5
            if isSelected {        //重新绘制selcontent
                //恢复保存的绘制样式
    //            ctx?.restoreGState(),不包括内容
                r = height*0.5
            }
            subTypes.forEach {
                switch $0 {
                case .round(let color, let selColor):
                    var _color = color
                    if isSelected {
                        _color = selColor
                    }
                    ctx?.addArc(center: CGPoint(x: height/2.0, y: height/2.0), radius: r, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
                    ctx?.setFillColor(_color.cgColor)
                    ctx?.drawPath(using: .fill)
                    
                case .image(let image, let selImage):
                    var im = image
                    if isSelected {
                        im = selImage
                    }
                    ctx?.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
                    ctx?.clip()
            //        将当前位置连接到原点，并通过绘制一条直线(默认情况下)来关闭图形
            //        ctx?.closePath()
                    ctx?.draw(im.cgImage!, in: bounds)
                case .text(let font, let selFont, let color, let selColor):
                    
                    let text = "\(currentCount+1)"
                    var attr = NSAttributedString(string: text, attributes: [.font:font,.foregroundColor:color])
                    if isSelected {
                        attr = NSAttributedString(string: text, attributes: [.font: selFont,.foregroundColor:selColor])
                    }
                    let settter = CTTypesetterCreateWithAttributedString(attr as CFAttributedString)
                    let line = CTTypesetterCreateLine(settter as CTTypesetter, CFRangeMake(0, text.count))
                    var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
                    let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
//                    let lineHeight = ceil(abs(ascent) + abs(descent) + abs(leading))
                    let lineHeight = ceil(abs(ascent))
                    let y = (height-lineHeight)/2.0 + ceil(abs(descent)/2.0)
                    let x = (bounds.width-CGFloat(width))/2.0
                    ctx?.textPosition = CGPoint(x: x, y: y)
                    CTLineDraw(line, ctx!)
                }
            }
            let img = UIGraphicsGetImageFromCurrentImageContext()
            if isSelected {
                selContents = img?.cgImage
                contents = selContents
            } else {
                norContents = img?.cgImage
                contents = norContents
            }
        case .single(let subTypes):
            subTypes.forEach {
                switch $0 {
                case .round(let color, _):
                    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: height/2.0, height: height/2.0))
                    ctx?.addPath(path.cgPath)
                    ctx?.setFillColor(color.cgColor)
                    ctx?.drawPath(using: .fill)
                case .image(let image, _):
                    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: height/2.0, height: height/2.0))
                    ctx?.addPath(path.cgPath)
                    ctx?.clip()
            //        将当前位置连接到原点，并通过绘制一条直线(默认情况下)来关闭图形
            //        ctx?.closePath()
        
                    ctx?.draw(image.cgImage!, in: bounds)
                case .text(let font, _, let color, _):
                    let text = "\(currentCount+1)" + "/" + "\(pageCount)"
                    let attr = NSAttributedString(string: text, attributes: [.font: font,.foregroundColor:color])
                    let settter = CTTypesetterCreateWithAttributedString(attr as CFAttributedString)
                    let line = CTTypesetterCreateLine(settter as CTTypesetter, CFRangeMake(0, text.count))
                    var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
                    let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
//                    let lineHeight = ceil(abs(ascent) + abs(descent) + abs(leading))
                    let lineHeight = ceil(abs(ascent))
                    let y = (height-lineHeight)/2.0 + ceil(abs(descent)/2.0)
                    let x = (bounds.width-CGFloat(width))/2.0
                    ctx?.textPosition = CGPoint(x: x, y: y)
                    CTLineDraw(line, ctx!)
//                    let runs = CTLineGetGlyphRuns(line)
//                    let run = CFArrayGetValueAtIndex(runs, 0)
//                    CTRunDraw(run as CTRun, ctx!, CFRangeMake(0, text.count))
                
//                    let ctframe = CTFramesetterCreateFrame(settter, CFRangeMake(0, text.count), <#T##path: CGPath##CGPath#>, <#T##frameAttributes: CFDictionary?##CFDictionary?#>)
                    
                }
            }
            let img = UIGraphicsGetImageFromCurrentImageContext()
            selContents = img?.cgImage
            norContents = img?.cgImage
            contents = selContents
        }
        
        UIGraphicsEndImageContext()
    }
}
//MARK: Draw
extension XBCirclePageLayer {
   
}
