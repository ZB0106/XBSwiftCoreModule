//
//  XBGrandiLayerUI.swift
//  XBSwiftCoreModule
//
//  Created by xbing on 2021/2/20.
//

import UIKit
class XBGradientLayerButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public init(colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5), locations: [Double]? = nil) {
        super.init(frame: .zero)
        guard let layer = self.layer as? CAGradientLayer else { return }
        if colors.count == 1 {
            layer.backgroundColor = colors.first
        } else if colors.count > 1 {
            layer.colors = colors
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            layer.locations = locations?.compactMap({NSNumber(value: $0)})
        }
        
    }
    override class var layerClass: AnyClass { CAGradientLayer.self }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XBGradientLayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public init(colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5), locations: [Double]? = nil) {
        super.init(frame: .zero)
        guard let layer = self.layer as? CAGradientLayer else { return }
        if colors.count == 1 {
            layer.backgroundColor = colors.first
        } else if colors.count > 1 {
            layer.colors = colors
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            layer.locations = locations?.compactMap({NSNumber(value: $0)})
        }
        
    }
    override class var layerClass: AnyClass { CAGradientLayer.self }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class XBGradientLayerLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public init(colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5), locations: [Double]? = nil) {
        super.init(frame: .zero)
        guard let layer = self.layer as? CAGradientLayer else { return }
        if colors.count == 1 {
            layer.backgroundColor = colors.first
        } else if colors.count > 1 {
            layer.colors = colors
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            layer.locations = locations?.compactMap({NSNumber(value: $0)})
        }
        
    }
    override class var layerClass: AnyClass { CAGradientLayer.self }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
