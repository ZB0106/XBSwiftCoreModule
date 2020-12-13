//
//  XBBaseListManager.swift
//  cocoaStudy
//
//  Created by 苹果兵 on 2020/12/5.
//

import Foundation

public class XBBaseListManager: NSObject, XBListEmptyViewDelegate {
    private var emptyView: XBListEmptyView?
    public var sectionArray = [XBSectionModelProtocol]()
    public var listView: UIScrollView!
    public var cellClass: String?
    public var cellSize: CGSize = XBListDefaultSecSize
    public var emptyManager: XBListEmptyManagerProtocol? {
        didSet {
            guard emptyManager != nil else {
                return
            }
            if self.emptyView == nil {
                
                self.emptyView = XBListEmptyView(emptyManager: self.emptyManager!)
                self.emptyView?.delegate = self
                self.listView.addSubview(self.emptyView!)
                self.listView.bringSubviewToFront(self.emptyView!)
            }
            self.reloadData()
        }
    }
    public func reloadData() {
        
        self.emptyView?.isHidden = sectionArray.count != 0
    }
    public func XBListEmptyViewDidTap() {
        
    }
}
