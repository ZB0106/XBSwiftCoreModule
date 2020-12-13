//
//  XBBaseCollectionViews.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit

//BaseViews
open class XBBaseCollectionCell: UICollectionViewCell, XBCellDataProtocol {

    public func configureData<T>(item: T) {
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.makeAddSubViews()
        self.makeLayoutSubViews()
    }
}
extension XBBaseCollectionCell {
    @objc open func makeAddSubViews() {
         
     }
     @objc open func makeLayoutSubViews() {
         
     }
}


open class XBBaseCollectionSecView: UICollectionReusableView, XBSectionViewDataProtocol {
    
    public func configureData<T>(item: T) {
        
    }
    
    
    public var indexPath: IndexPath!
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.makeAddSubViews()
        self.makeLayoutSubViews()
    }
}
extension XBBaseCollectionSecView  {
    @objc open func makeLayoutSubViews() {
       
    }
    @objc open func makeAddSubViews() {
       
    }
}
