//
//  XBCirclePageControl.swift
//  XBSwiftCoreModule
//
//  Created by xbing on 2020/12/7.
//

protocol XBCirclePageControlDelegate: class {
    func didGotoNewIndex(index: Int)
}
 
extension XBCirclePageControlDelegate {
    func didGotoNewIndex(index: Int) {
        
    }
}

public class XBCirclePageControl: UIView {
    deinit {
        print("XBCirclePageControl deinit")
    }

    public enum XBPageControlType {
        public enum XBPageControlSubType {
            
            case round(color: UIColor, selColor: UIColor)
            case image(imageName: String, selImageName: String)
            case text(font: UIFont, selFont: UIFont, color: UIColor, selColor: UIColor)
            
            
            var value: Int {
                switch self {
                case .round:
                    return 0
                case .image:
                    return 1
                case .text:
                    return 3
                }
            }
        }
        
        case single(subTypes: [XBPageControlSubType] = [.round(color: .gray, selColor: .orange),.text(font: UIFont.systemFont(ofSize: 14.0, weight: .regular), selFont: UIFont.systemFont(ofSize: 16.0, weight: .medium), color: .white, selColor: .white)])
        case multiple(subTypes: [XBPageControlSubType] = [.round(color: .gray, selColor: .orange),.text(font: UIFont.systemFont(ofSize: 14.0, weight: .regular), selFont: UIFont.systemFont(ofSize: 16.0, weight: .medium), color: .white, selColor: .white)])
        
        var subTypes: [XBPageControlSubType] {
            switch self {
            case .multiple(let subTypes):
                return subTypes.sorted(by: { $0.value < $1.value })
            case .single(let subTypes):
                return subTypes.sorted(by: { $0.value < $1.value })
            }
        }
    }
    
    var pageCount = 0 {
        didSet {
            layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            
            for i in 0..<pageCount {
                let _layer = XBCirclePageLayer(pageType: pageType, currentCount: i, pageCount: pageCount)
                layer.addSublayer(_layer)
            }
            //重新布局self
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    internal var pageType: XBPageControlType = .multiple() {
        didSet {
            layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            
            for i in 0..<pageCount {
                let _layer = XBCirclePageLayer(pageType: pageType, currentCount: i, pageCount: pageCount)
                layer.addSublayer(_layer)
            }
            //重新布局self
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var currentPage = 0 {
        didSet {
            guard let layers = layer.sublayers else { return }
            switch pageType {
            case .multiple:
                //关闭layer的隐式动画
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                for (i, layer) in layers.enumerated() {
                    (layer as? XBCirclePageLayer)?.isSelected = i == currentPage
                }
                CATransaction.commit()
            case .single:
                //关闭layer的隐式动画
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                for (i, layer) in layers.enumerated() {
                    layer.isHidden = i != currentPage
                }
                CATransaction.commit()
            }
            
        }
    }
   
    private var widthLayout: NSLayoutConstraint?
    weak var delegate: XBCirclePageControlDelegate?
    
    init(pageType: XBPageControlType = .multiple()) {
        self.pageType = pageType
        super.init(frame: .zero)
        let tap = UITapGestureRecognizer(target: self, action: #selector(pageDidTap(gesture:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override class var layerClass: AnyClass { return XBCirclePageContainerLayer.self }
    
}

//布局
extension XBCirclePageControl {
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if bounds.height == 0 { return }
        if pageCount <= 0 { return }
        
        if self.translatesAutoresizingMaskIntoConstraints == true {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        if let widLy = widthLayout {
            NSLayoutConstraint.deactivate( [widLy] )
        }
        var width: CGFloat = 0
        switch pageType {
        case .multiple:
            width = CGFloat(pageCount)*(bounds.height+3.0)-3.0
        case .single:
            width = bounds.height*2.0
        }
        self.widthLayout = self.widthAnchor.constraint(equalToConstant: width)
        self.widthLayout?.isActive = true
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        if bounds.width == 0 || bounds.height == 0 { return }
        guard let layers = layer.sublayers else { return }
        
        print("layoutSublayers",bounds)
        let size = bounds.size.height
        let gap: CGFloat = 3.0
        
        switch pageType {
        case .multiple:
            for (i, _layer) in layers.enumerated() {
                _layer.frame = CGRect(x: CGFloat(i)*(gap+size), y: 0, width: size, height: size)
                _layer.needsDisplayOnBoundsChange = true
                _layer.setNeedsDisplay()
                _layer.displayIfNeeded()
            }
        case .single:
            for (_, _layer) in layers.enumerated() {
                _layer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: size)
                //标记需要bounds改变时需要重绘
                _layer.needsDisplayOnBoundsChange = true
                _layer.setNeedsDisplay()
                _layer.displayIfNeeded()
            }
        }
        
    }
    @objc func pageDidTap(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: self)
        guard let layers = layer.sublayers else { return }
        switch pageType {
        case .single:
            return
        default:
            break
        }
        
        for (i, layer) in layers.enumerated() {
            if layer.frame.contains(point) {
                self.delegate?.didGotoNewIndex(index: i)
                break
            }
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
