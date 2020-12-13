//
//  XBListEmptyManager.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit


public struct XBListEmptyViewComponents {
    public init() {}
    fileprivate var title: String? = "Xbing"
    fileprivate var detailTitle: String? = "copyrights Xbing"
    fileprivate var attributeString: NSAttributedString?
    fileprivate var bottomAttributeString: NSAttributedString?
    fileprivate var detailAttributeString: NSAttributedString?
    fileprivate var tapTitle: String? = "刷新试试"
    fileprivate var isShowTap: Bool = true
    fileprivate var tapAttributeString: NSAttributedString?
    fileprivate var imageName: String?
    fileprivate var imageOffSet: CGFloat = 5.0
    fileprivate var titleOffSet: CGFloat = 5.0
    fileprivate var detailOffSet: CGFloat = 5.0
    
    //左右边距
    fileprivate var edges: CGFloat = 10.0
}

public protocol XBListEmptyManagerProtocol {
    
    var compoents: XBListEmptyViewComponents { get set }
    
    var title: String? { get set }
    var detailTitle: String? { get set }
    var attributeString: NSAttributedString? { get set }
    var bottomAttributeString: NSAttributedString? { get set }
    var detailAttributeString: NSAttributedString? { get set }
    var tapTitle: String? { get set }
    var tapAttributeString: NSAttributedString? { get set }
    
    var imageName: String? { get set }
    var imageOffSet: CGFloat { get set }
    var titleOffSet: CGFloat { get set }
    var detailOffSet: CGFloat { get set }
    var edges: CGFloat { get set }
    var isShowTap: Bool { get set }
}
extension XBListEmptyManagerProtocol {
    public var title: String? {
        get { compoents.title }
        set { compoents.title = newValue }
    }
    public var detailTitle: String? {
        get { compoents.detailTitle }
        set { compoents.detailTitle = newValue }
    }
    public var tapTitle: String? {
        get { compoents.tapTitle }
        set { compoents.tapTitle = newValue }
    }
    public var tapAttributeString: NSAttributedString? {
        get { compoents.tapAttributeString }
        set { compoents.tapAttributeString = newValue }
    }
   public var attributeString: NSAttributedString? {
        get { compoents.attributeString }
        set { compoents.attributeString = newValue }
    }
    public var bottomAttributeString: NSAttributedString? {
         get { compoents.bottomAttributeString }
         set { compoents.bottomAttributeString = newValue }
     }
    public var detailAttributeString: NSAttributedString? {
        get { compoents.detailAttributeString }
        set { compoents.detailAttributeString = newValue }
    }
    public var imageName: String? {
        get { compoents.imageName }
        set { compoents.imageName = newValue }
    }
    public var imageOffSet: CGFloat {
        get { compoents.imageOffSet }
        set { compoents.imageOffSet = newValue }
    }
    public var titleOffSet: CGFloat {
        get { compoents.titleOffSet }
        set { compoents.titleOffSet = newValue }
    }
    public var detailOffSet: CGFloat {
        get { compoents.detailOffSet }
        set { compoents.detailOffSet = newValue }
    }
    public var edges: CGFloat {
        get { compoents.edges }
        set { compoents.edges = newValue }
    }
    public var isShowTap: Bool {
        get { compoents.isShowTap }
        set { compoents.isShowTap = newValue }
    }
}

public class XBListEmptyManager: XBListEmptyManagerProtocol {
    public init() {}
    public var compoents: XBListEmptyViewComponents = XBListEmptyViewComponents()
}
