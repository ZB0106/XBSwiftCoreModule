//
//  XBModelProtocol.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/14.
//

import UIKit

fileprivate struct XBModelComponentsKey {
    fileprivate static var dataModelKey = "com.XBDataModelComponentsKey"
    fileprivate static var sectionModelKey = "com.XBSectionModelComponentsKey"
}


//MARK:- XBSectionModelProtocol
public struct XBDataModelComponents {
    
    public init(cellSize: CGSize = XBListDefaultSecSize, cellClass: String? = nil) {
        self.cellSize = cellSize
        self.cellClass = cellClass
    }
    var isSelected: Bool = false
    var isEdit: Bool = false
    var editSize: CGSize = XBListDefaultSecSize
    var cellSize: CGSize = XBListDefaultSecSize
    var cellClass: String?
    
}

public protocol XBDataModelProtocol {
    var dataComponents: XBDataModelComponents { get set }
    var isSelected: Bool { get set }
    var isEdit: Bool { get set }
    var editSize: CGSize { get set }
    var cellSize: CGSize { get set }
    var cellClass: String? { get set }
}
extension XBDataModelProtocol {
//    public var dataComponents: XBDataModelComponents {
//        get {
//            var _cmp = objc_getAssociatedObject(self, &XBModelComponentsKey.dataModelKey)
//            if _cmp == nil {
//                _cmp = XBDataModelComponents()
//                objc_setAssociatedObject(self, &XBModelComponentsKey.dataModelKey, _cmp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//            return _cmp as! XBDataModelComponents
//        }
//    }
   public var isSelected: Bool {
        get { dataComponents.isSelected }
        set { dataComponents.isSelected = newValue }
    }
    public var isEdit: Bool {
        get { dataComponents.isEdit }
        set { dataComponents.isEdit = newValue }
    }
    public var editSize: CGSize {
        get { dataComponents.editSize }
        set { dataComponents.editSize = newValue }
    }
    public var cellSize: CGSize {
        get { dataComponents.cellSize }
        set { dataComponents.cellSize = newValue }
    }
    public var cellClass: String? {
        get { dataComponents.cellClass }
        set { dataComponents.cellClass = newValue }
    }
}

//MARK:- setionModel
public struct XBSectionModelComponents {
    
    public init(headerSize: CGSize = XBListDefaultSecSize, headerClass: String? = nil, cellSize: CGSize = XBListDefaultSecSize, cellClass: String? = nil) {
        self.headerSize = headerSize
        self.headerClass = headerClass
        self.cellSize = cellSize
        self.cellClass = cellClass
    }
    
//    CGSize.init(width: 0, height: 0.0001)
    var items: [XBDataModelProtocol] = []
    var isClose = false
    var isSelected = false
    
    //cell
    var cellSize = XBListDefaultSecSize
    var cellClass: String?
    
    
    //edit
    var isEdit = false
    var editSize = XBListDefaultSecSize
    
    //header
    var headerSize = XBListDefaultSecSize
    var headerClass: String?
    
    //footer
    var footerSize = XBListDefaultSecSize
    var footerClass : String?
    var isFooterEdit = false
    var footerEditSize = XBListDefaultSecSize

    //layout
    var edgeInsets = UIEdgeInsets.zero
    var lineSpace: CGFloat = 0
    var itemSpace: CGFloat = 0
    
}

public protocol XBSectionModelProtocol {
    
    
    var dataComponents: XBSectionModelComponents { get set }
    
    var items: [XBDataModelProtocol] { get set }
    //控制sec下的cell的展开与收起
    var isClose: Bool { get set }
    var isSelected: Bool { get set }
    var isEdit: Bool { get set }
    var editSize: CGSize { get set }
    
    var cellSize: CGSize { get set }
    var cellClass: String? { get set }
    
    
    var headerSize: CGSize { get set }
    var headerClass: String? { get set }

    var footerSize: CGSize { get set }
    var footerClass: String? { get set }
    var isFooterEdit: Bool { get set }
    var footerEditSize: CGSize { get set }
    
    //layout
    var edgeInsets: UIEdgeInsets { get set }
    var lineSpace: CGFloat { get set }
    var itemSpace: CGFloat { get set }
    
}

//MARK: Protocol-extension

extension XBSectionModelProtocol {
    //如果结构体遵循了该协议，扩展里的dataComponents会被多次调用，如何解决？
    //如果是class遵循了协议，就没有问题
    //原因是由于结构体中的对象随时可能被释放，所以在结构体 中尽量不要使用对象
//    public var dataComponents: XBSectionModelComponents {
//        get {
//            var _cmp = objc_getAssociatedObject(self, &XBModelComponentsKey.sectionModelKey)
//            if _cmp == nil {
//                _cmp = XBSectionModelComponents()
//                objc_setAssociatedObject(self, &XBModelComponentsKey.sectionModelKey, _cmp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//            return _cmp as! XBSectionModelComponents
//        }
//    }
    public var items: [XBDataModelProtocol] {
        get { dataComponents.items }
        set { dataComponents.items = newValue }
    }
    //控制sec下的cell的展开与收起
    public var isClose: Bool {
        get { dataComponents.isClose }
        set { dataComponents.isClose = newValue }
    }
    public var isSelected: Bool {
        get { dataComponents.isSelected }
        set { dataComponents.isSelected = newValue }
    }
    public var isEdit: Bool {
        get { dataComponents.isEdit }
        set { dataComponents.isEdit = newValue }
    }
    public var editSize: CGSize {
        get { dataComponents.editSize }
        set { dataComponents.editSize = newValue }
    }
    
    public var cellSize: CGSize {
        get { dataComponents.cellSize }
        set { dataComponents.cellSize = newValue }
    }
    public var cellClass: String? {
        get { dataComponents.cellClass }
        set { dataComponents.cellClass = newValue }
    }
    
    
    public var headerSize: CGSize {
        get { dataComponents.headerSize }
        set { dataComponents.headerSize = newValue }
    }
    public var headerClass: String? {
        get { dataComponents.headerClass }
        set { dataComponents.headerClass = newValue }
    }

    public var footerSize: CGSize {
        get { dataComponents.footerSize }
        set { dataComponents.footerSize = newValue }
    }
    public var footerClass: String? {
        get { dataComponents.footerClass }
        set { dataComponents.footerClass = newValue }
    }
    public var isFooterEdit: Bool {
        get { dataComponents.isFooterEdit }
        set { dataComponents.isFooterEdit = newValue }
    }
    public var footerEditSize: CGSize {
        get { dataComponents.footerEditSize }
        set { dataComponents.footerEditSize = newValue }
    }
    
    //layout
    public var edgeInsets: UIEdgeInsets {
        get { dataComponents.edgeInsets }
        set { dataComponents.edgeInsets = newValue }
    }
    public var lineSpace: CGFloat {
        get { dataComponents.lineSpace }
        set { dataComponents.lineSpace = newValue }
    }
    public var itemSpace: CGFloat {
        get { dataComponents.lineSpace }
        set { dataComponents.lineSpace = newValue }
    }
}
