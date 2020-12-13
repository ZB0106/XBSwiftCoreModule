//
//  XBProtocolTableViews.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit


//BaseViews
open class XBBaseTableCell: UITableViewCell, XBCellDataProtocol {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeAddSubViews()
        self.makeLayoutSubViews()
    }
}
extension XBBaseTableCell {
    @objc open func makeAddSubViews() {
         
     }
     @objc open func makeLayoutSubViews() {
         
     }
}


open class XBBaseTableSecView: UITableViewHeaderFooterView, XBSectionViewDataProtocol {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.makeAddSubViews()
        self.makeLayoutSubViews()
    }
    
}
extension XBBaseTableSecView  {
    @objc open func makeLayoutSubViews() {
        
    }
    @objc open func makeAddSubViews() {
       
    }
}
