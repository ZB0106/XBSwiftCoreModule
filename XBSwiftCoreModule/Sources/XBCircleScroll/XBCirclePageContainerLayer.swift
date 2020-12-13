//
//  XBCirclePageContainerLayer.swift
//  XBSwiftCoreModule
//
//  Created by 苹果兵 on 2020/12/12.
//

import Foundation

class XBCirclePageContainerLayer: CALayer {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init() {
        super.init()
    }
    
    override func layoutSublayers() {
//        super.layoutSublayers() 会调用代理方法 self.delegate?.layoutSublayers?(of: self)
        self.delegate?.layoutSublayers?(of: self)
    }
}

