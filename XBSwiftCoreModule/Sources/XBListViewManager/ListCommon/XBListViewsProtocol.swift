//
//  ZB_CollectionViews.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/14.
//

import UIKit

//MARK: common
public protocol XBListConfigureDataProtocol: class {
    func configureData<T>(item: T)
}
extension XBListConfigureDataProtocol {
    public func configureData<T>(item: T) {
        
    }
}

fileprivate struct XBViewsComponentsKey {
    fileprivate static var cellKey = "com.XBCellComponentsKey"
    fileprivate static var cellWeakKey = "com.XBCellComponentsWeakKey"
    fileprivate static var sectionViewKey = "com.XBSectionViewComponentsKey"
    fileprivate static var sectionViewWeakKey = "com.XBSectionViewComponentsWeakKey"
}

//MARK：Cell

//MARK:CellDelegate
public protocol XBCelldelegate {
    
    func handelCellEvent(indexPath: IndexPath?, item: XBDataModelProtocol?, eventID: Int)
}

extension XBCelldelegate {
    public func handelCellEvent(indexPath: IndexPath?, item: XBDataModelProtocol?, eventID: Int) {}
}

//MARK: cellprotocol
public class XBCellComponents {
    var indexPath: IndexPath?
    var delegate: XBCelldelegate? {
        set {objc_setAssociatedObject(self, &XBViewsComponentsKey.cellWeakKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
        get {objc_getAssociatedObject(self, &XBViewsComponentsKey.cellWeakKey) as? XBCelldelegate }
    }
    var item: XBDataModelProtocol?
}


public protocol XBCellDataProtocol: XBListConfigureDataProtocol {
    var components: XBCellComponents { get }
    var item: XBDataModelProtocol? { get set }
    var indexPath: IndexPath? { get set }
    var delegate: XBCelldelegate? { get set }
    
}
extension XBCellDataProtocol {
    public var components: XBCellComponents {
        get {
            var _cmp = objc_getAssociatedObject(self, &XBViewsComponentsKey.cellKey)
            if _cmp == nil {
                _cmp = XBCellComponents()
                objc_setAssociatedObject(self, &XBViewsComponentsKey.cellKey, _cmp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _cmp as! XBCellComponents
        }
    }
    public var indexPath: IndexPath? {
        get { components.indexPath }
        set { components.indexPath = newValue }
    }
    public var delegate: XBCelldelegate? {
        get { components.delegate }
        set { components.delegate = newValue }
    }
    public var item: XBDataModelProtocol? {
        get { components.item }
        set { components.item = newValue }
    }
}

//MARK: section
//MARK: SecViewDelegate
public protocol XBSectionViewdelegate {
    func handelSectionViewEvent(section: Int?, sectionData: XBSectionModelProtocol?, eventID: Int)
}
extension XBSectionViewdelegate {
    public func handelSectionViewEvent(section: Int?, sectionData: XBSectionModelProtocol?, eventID: Int) {}
}

//MARK：secViewDataProtocol
public class XBSectionViewComponents {
    var section: Int?
    var delegate: XBSectionViewdelegate? {
        set {objc_setAssociatedObject(self, &XBViewsComponentsKey.sectionViewWeakKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
        get {objc_getAssociatedObject(self, &XBViewsComponentsKey.sectionViewWeakKey) as? XBSectionViewdelegate }
    }
    var sectionData: XBSectionModelProtocol?
}

public protocol XBSectionViewDataProtocol: XBListConfigureDataProtocol {
    var components: XBSectionViewComponents { get }
    var section: Int? {get set}
    var delegate: XBSectionViewdelegate? { get set }
    var sectionData: XBSectionModelProtocol? { get set }
    
}
extension XBSectionViewDataProtocol {
    public var components: XBSectionViewComponents {
        get {
            var _cmp = objc_getAssociatedObject(self, &XBViewsComponentsKey.sectionViewKey)
            if _cmp == nil {
                _cmp = XBSectionViewComponents()
                objc_setAssociatedObject(self, &XBViewsComponentsKey.sectionViewKey, _cmp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _cmp as! XBSectionViewComponents
        }
    }
    public var section: Int? {
        get { components.section }
        set { components.section = newValue }
    }
    public var delegate: XBSectionViewdelegate? {
        get { components.delegate }
        set { components.delegate = newValue }
    }
    public var sectionData: XBSectionModelProtocol? {
        get { components.sectionData }
        set { components.sectionData = newValue }
    }
}
