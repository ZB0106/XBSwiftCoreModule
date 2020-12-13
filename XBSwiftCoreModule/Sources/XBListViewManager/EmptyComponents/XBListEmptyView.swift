//
//  XBEmptyView.swift
//  XBSwiftCoreModule
//
//  Created by 苹果兵 on 2020/12/6.
//


public protocol XBListEmptyViewDelegate: class {
    func XBListEmptyViewDidTap()
}

extension XBListEmptyViewDelegate {
    public func XBListEmptyViewDidTap() {
        
    }
}

class XBListEmptyView: UIView {
    
    deinit {
        print(#function,classForCoder)
    }
    
    lazy var titLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        lb.addGestureRecognizer(tap)
        return lb
    }()
    lazy var detailTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.gray
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        return lb
    }()
    
    lazy var bottomLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(emptyManager: XBListEmptyManagerProtocol) {
        super.init(frame: .zero)
        
        //configuredata
        self.titLabel.text = emptyManager.title
        if emptyManager.attributeString != nil {
            self.titLabel.attributedText = emptyManager.attributeString
        }
        
        if emptyManager.isShowTap {
            self.titLabel.isUserInteractionEnabled = true
            if emptyManager.tapTitle != nil {
                self.titLabel.text = emptyManager.tapTitle
            }
            if emptyManager.tapAttributeString != nil {
                self.titLabel.attributedText = emptyManager.attributeString
            }
        }
        
        self.detailTitleLabel.text = emptyManager.detailTitle
        if emptyManager.detailAttributeString != nil {
            self.detailTitleLabel.attributedText = emptyManager.detailAttributeString
        }
        
        self.bottomLabel.attributedText = emptyManager.bottomAttributeString
        
        self.imageView.image = UIImage(contentsOfFile: emptyManager.imageName ?? "")

        
        self.addSubview(imageView)
        self.addSubview(titLabel)
        self.addSubview(detailTitleLabel)
        self.addSubview(bottomLabel)
        
        if imageView.translatesAutoresizingMaskIntoConstraints == true {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: emptyManager.imageOffSet)
            ])
        }
        if titLabel.translatesAutoresizingMaskIntoConstraints == true {
           titLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: emptyManager.edges),
                titLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -emptyManager.edges),
                titLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: emptyManager.titleOffSet)
            ])
        }
        if detailTitleLabel.translatesAutoresizingMaskIntoConstraints == true {
            detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: emptyManager.edges),
                detailTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -emptyManager.edges),
                detailTitleLabel.topAnchor.constraint(equalTo: titLabel.bottomAnchor, constant: emptyManager.detailOffSet)
            ])
        }
        
        if bottomLabel.translatesAutoresizingMaskIntoConstraints == true {
            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: emptyManager.edges),
                bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -emptyManager.edges),
                bottomLabel.bottomAnchor.constraint(equalTo: titLabel.bottomAnchor, constant: -20)
            ])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    weak var delegate: XBListEmptyViewDelegate?
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.translatesAutoresizingMaskIntoConstraints == true {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor),
                self.rightAnchor.constraint(equalTo: superview!.rightAnchor),
                self.topAnchor.constraint(equalTo: superview!.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
                self.widthAnchor.constraint(equalTo: superview!.widthAnchor),
                self.heightAnchor.constraint(equalTo: superview!.heightAnchor)
            ])
        }
    }
    
    
    @objc func didTap() {
        self.delegate?.XBListEmptyViewDidTap()
    }
}
