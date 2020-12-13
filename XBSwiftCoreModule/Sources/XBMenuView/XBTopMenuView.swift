//
//  XBTopMenuView.swift
//  CZBPersonalInfoModule
//
//  Created by xbing on 2020/11/10.
//

import UIKit

private let MinTag = 55498

public enum MenuViewContentSizeType {
    //各子控件固定width
    case indeterminacy(width: CGFloat)
    //各子控件依赖于父控件等宽布局
    case equalToSuper
    //依赖与各控件自己的尺寸
    case determinedBySubSize
}

public typealias XBTopMenuClickHandle = (Int) -> Void
public class XBTopMenuView: UIScrollView {
    
    deinit {
        #if DEBUG
        print(#function,classForCoder)
        #endif
        buttonArr.removeAll()
        self.clickHandle = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public init(titles: [String], contentSizeType: MenuViewContentSizeType = .equalToSuper, buttonComponents: XBMenuButtonComponents) {
        super.init(frame: .zero)
        self.contentSizeType = contentSizeType
        self.titles = titles
        self.buttonCom = buttonComponents
        self.itemsCount = titles.count
        configuerSubviews()
    }
    
    public init(buttons: [UIButton], contentSizeType: MenuViewContentSizeType = .equalToSuper) {
        super.init(frame: .zero)
        self.contentSizeType = contentSizeType
        self.buttonArr = buttons
        self.itemsCount = buttons.count
        configuerSubviews()
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //防止多次计算
        if buttonArr.count != itemsCount {
            return
        }
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        var w:CGFloat = 0
        let h = self.frame.height
        
        switch self.contentSizeType {
        case .equalToSuper:
            w = self.frame.width/CGFloat(buttonArr.count)
            for (i, btn) in buttonArr.enumerated() {
                x = CGFloat(i)*w
                btn.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        case .indeterminacy(let width):
            for (i, btn) in buttonArr.enumerated() {
                x = CGFloat(i)*width
                btn.frame = CGRect(x: x, y: y, width: width, height: h)
            }
        case .determinedBySubSize:
            for (i, btn) in buttonArr.enumerated() {
                w = btn.sizeThatFits(.zero).width+6.0
                x = CGFloat(i)*w
                btn.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        default: break
            
        }
        //设置滚动尺寸
        self.contentSize = CGSize(width: buttonArr[buttonArr.count-1].frame.maxX, height: self.frame.height)
       
    }
    public var itemsCount: Int = 0
    public var clickHandle: XBTopMenuClickHandle?
    private var buttonCom: XBMenuButtonComponents?
    private var buttonArr = [UIButton]()
    private var titles = [String]()
    private var contentSizeType: MenuViewContentSizeType!
   
}
//布局subviews
extension XBTopMenuView {
    func configuerSubviews() {
        for (_, view) in self.buttonArr.enumerated() {
            view.removeFromSuperview()
        }
        if buttonArr.count > 0 {
            for (i, btn) in buttonArr.enumerated() {
                btn.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
                self.addSubview(btn)
                btn.tag = MinTag+i
                if i == 0 {
                    self.didTap(btn)
                }
            }
        } else {
            for (i, title) in titles.enumerated() {
                buttonCom!.title = title
                let btn = XBDownLineBtn(components: buttonCom!)
                btn.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
                self.addSubview(btn)
                buttonArr.append(btn)
                btn.tag = MinTag+i
                if i == 0 {
                    self.didTap(btn)
                }
            }
        }
        
    }
}
//button相关事件
extension XBTopMenuView {
    public func changeBtnWithTag(tag: Int) {
        if let btn = self.viewWithTag(tag+MinTag) as? XBDownLineBtn {
            self.didTap(btn)
        }
        
    }
    
    @objc func didTap(_ btn: UIButton) {
        for view in buttonArr {
            if view == btn {
                if view.isSelected {
                    break
                } else {
                    view.isSelected = true
                }
            } else {
                view.isSelected = false
            }
        }
        self.clickHandle?(btn.tag-MinTag)
    }
    
    
}
/*

 
**/
