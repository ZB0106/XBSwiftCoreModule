//
//  XBCircleScrollView.swift
//  XBGitDemo
//
//  Created by xbing on 2020/11/24.
//

import UIKit

public protocol XBCircleScrollViewDelegate: class {
    func XBCircleView(circleView: UIView, configureDataWithIndex index: Int)
    func XBCircleView(circleView: UIView, didSelectedAtIndex index: Int)
}

extension XBCircleScrollViewDelegate {
    public func XBCircleView(circleView: UIView, configureDataWithIndex index: Int) {}
    public func XBCircleView(circleView: UIView, didSelectedAtIndex index: Int) {}
}

public class XBCircleScrollView: UIView {
    
    deinit {
        self.removeTimer()
        print(#function,classForCoder)
    }

    public lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.isPagingEnabled = true
        v.isScrollEnabled = true
        v.delegate = self
        return v
    }()
//    private lazy var  = {
//        let v = UIImageView()
//        v.isUserInteractionEnabled = true
//        v.contentMode = .scaleAspectFit
//        return v
//    }()
//     = {
//        let v = UIImageView()
//        v.isUserInteractionEnabled = true
//        v.contentMode = .scaleAspectFit
//        return v
//    }()
//     = {
//        let v = UIImageView()
//        v.isUserInteractionEnabled = true
//        v.contentMode = .scaleAspectFit
//        return v
//    }()
//
   
    public var pageCount: Int = 0 {
        didSet {
            //pagecount==1时不需要滚动
            if pageCount <= 1 {
                self.removeTimer()
                scrollView.isScrollEnabled = false
            } else {
                self.addTimer()
                scrollView.isScrollEnabled = true
            }
            pageControl?.pageCount = pageCount
            currentPage = 1
            updateImage()
        }
    }
   
    public var pageControlRightOffSet: CGFloat = 10 {
        didSet {
            if let r = self.rightConstrait {
                NSLayoutConstraint.deactivate([r])
                pageControl?.removeConstraint(r)
            }
            self.rightConstrait = pageControl!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeInsets.right-pageControlRightOffSet)
            self.rightConstrait.isActive = true
           
        }
    }
    public var pageControlBottomOffSet: CGFloat = 10 {
        didSet {
            if let r = self.bottomConstrait {
                NSLayoutConstraint.deactivate([r])
                pageControl?.removeConstraint(r)
            }
            self.bottomConstrait = pageControl!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgeInsets.bottom-pageControlBottomOffSet)
            self.bottomConstrait.isActive = true
        }
    }
    public var pagControlHeight: CGFloat = 20.0 {
        didSet {
            if let r = self.heightConstrait {
                NSLayoutConstraint.deactivate([r])
                pageControl?.removeConstraint(r)
            }
            self.heightConstrait = pageControl!.heightAnchor.constraint(equalToConstant: pagControlHeight)
            self.heightConstrait.isActive = true
        }
    }
    private var _pageType: XBCirclePageControl.XBPageControlType = .multiple()
    public var pageType: XBCirclePageControl.XBPageControlType = .multiple() {
        didSet {
            self.pageControl?.pageType = pageType
            currentPage = 1
            updateImage()
        }
    }
    weak public var delegate: XBCircleScrollViewDelegate?
    private var pageControl: XBCirclePageControl?
    private var leftImv: UIView?
    private var rightImv: UIView?
    private var centerImv: UIView?
    private var rightConstrait: NSLayoutConstraint!
    private var heightConstrait: NSLayoutConstraint!
    private var bottomConstrait: NSLayoutConstraint!
    
    private var isShowTimer: Bool = false
    private var timer: XBSourceTimer?
    private var currentPage: Int = 1
    private var prePage: Int = 0
    private var nextPage: Int = 0
    public var edgeInsets: UIEdgeInsets = .zero
    public var imageArray: [UIImage] = []
    public var circleViewType: AnyClass?
   
    public init(circleViewType: AnyClass? = UIImageView.self, isUseTimer: Bool = false, timerInterval: Int = 3, isShowPageControl: Bool = true, pageType: XBCirclePageControl.XBPageControlType = .multiple()) {
        super.init(frame: .zero)
        self.pageType = pageType
        //写在前面这样初始化的时候不会反复调用pagetype
        if isShowPageControl {
            pageControl = XBCirclePageControl(pageType: pageType)
            pageControl?.delegate = self
            self.addSubview(pageControl!)
            if pageControl?.translatesAutoresizingMaskIntoConstraints == true {
                pageControl?.translatesAutoresizingMaskIntoConstraints = false
                self.rightConstrait = pageControl!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeInsets.right-pageControlRightOffSet)
                self.rightConstrait.isActive = true
                self.heightConstrait = pageControl!.heightAnchor.constraint(equalToConstant: pagControlHeight)
                self.heightConstrait.isActive = true
                self.bottomConstrait = pageControl!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgeInsets.bottom-pageControlBottomOffSet)
                self.bottomConstrait.isActive = true
            }
        }
        self.circleViewType = circleViewType
        self.setUpSubViews()
        self.isShowTimer = isUseTimer
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension XBCircleScrollView {
    func setUpSubViews() {
        
        self.addSubview(scrollView)
        //防止scrollview压住pagecontrol
        self.sendSubviewToBack(scrollView)
        if scrollView.translatesAutoresizingMaskIntoConstraints == true {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeInsets.left),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeInsets.right),
                scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: edgeInsets.top),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgeInsets.bottom),
            ])
        }
        
        guard let viewType = self.circleViewType as? UIView.Type else {
            fatalError("circleViewType must be a subclass of uiview")
        }
        leftImv = viewType.init()
        rightImv = viewType.init()
        centerImv = viewType.init()
        scrollView.addSubview(leftImv!)
        if leftImv!.translatesAutoresizingMaskIntoConstraints == true {
            leftImv!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                leftImv!.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                leftImv!.topAnchor.constraint(equalTo: scrollView.topAnchor),
                leftImv!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                leftImv!.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                leftImv!.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
        
        scrollView.addSubview(centerImv!)
        if centerImv!.translatesAutoresizingMaskIntoConstraints == true {
            centerImv!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                centerImv!.leadingAnchor.constraint(equalTo: leftImv!.trailingAnchor),
                centerImv!.topAnchor.constraint(equalTo: scrollView.topAnchor),
                centerImv!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                centerImv!.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                centerImv!.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
        
        scrollView.addSubview(rightImv!)
        if rightImv!.translatesAutoresizingMaskIntoConstraints == true {
            rightImv!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rightImv!.leadingAnchor.constraint(equalTo: centerImv!.trailingAnchor),
                rightImv!.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                rightImv!.topAnchor.constraint(equalTo: scrollView.topAnchor),
                rightImv!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                rightImv!.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                rightImv!.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
       
        
    }
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateImage()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //默认滚动到中间
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
    }
}

//MARK: Timer
extension XBCircleScrollView {
    
    func addTimer() {
        if self.isShowTimer && self.timer == nil {
            self.timer = XBSourceTimer(timeInterval: 3, target: self, selector: #selector(handelTimerEvent))
            self.timer?.resume()
        }
    }
    
    func resumeTimer() {
        self.timer?.resume()
    }
    func suspendTimer() {
        self.timer?.suspend()
    }
    
    func removeTimer() {
        
        self.timer?.cancel()
    }
    @objc func handelTimerEvent() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self  else{ return }
            if weakSelf.scrollView.contentOffset.x == 2 * weakSelf.scrollView.bounds.size.width {
                weakSelf.scrollView.contentOffset = CGPoint(x: weakSelf.scrollView.bounds.width, y: 0)
            }
            weakSelf.scrollView.setContentOffset(CGPoint(x: weakSelf.scrollView.contentOffset.x + weakSelf.scrollView.bounds.width, y: 0), animated: true)
        }
    }
    
    
}

//update
extension XBCircleScrollView: XBCirclePageControlDelegate {
    
    func updateImage() {
        guard leftImv != nil, centerImv != nil, rightImv != nil else {
            assertionFailure("circleViewType must be a subclass of uiview")
            return
        }
        if pageCount == 0 {
            return
        }
        
        if scrollView.contentOffset.x > scrollView.frame.size.width {
            currentPage = currentPage >= pageCount-1 ? 0 : currentPage+1
        } else {
            currentPage = currentPage <= 0 ? pageCount-1 : currentPage-1
        }
        //pagecontrol
        pageControl?.currentPage = currentPage
        
        prePage = currentPage == 0 ? pageCount-1 : currentPage-1
        nextPage = currentPage == pageCount-1 ? 0 : currentPage+1
       
        self.delegate?.XBCircleView(circleView: leftImv!, configureDataWithIndex: prePage)
        self.delegate?.XBCircleView(circleView: centerImv!, configureDataWithIndex: currentPage)
        self.delegate?.XBCircleView(circleView: rightImv!, configureDataWithIndex: nextPage)
    }
    
    func didGotoNewIndex(index: Int) {
        
        guard leftImv != nil, centerImv != nil, rightImv != nil else {
            assertionFailure("circleViewType must be a subclass of uiview")
            return
        }
        if index == currentPage { return }
        
        if index > currentPage {
            currentPage = index - 1
            self.scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width*2.0, y: 0), animated: true)
        } else {
            currentPage = index + 1
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @objc func didTap() {
        guard let cenV = centerImv else { return }
        self.delegate?.XBCircleView(circleView: cenV, didSelectedAtIndex: currentPage)
    }
}

extension XBCircleScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.suspendTimer()
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if abs((scrollView.contentOffset.x - scrollView.frame.size.width) / scrollView.frame.size.width) >= 0.5 {
            self.updateImage()
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.width, y: 0)
        }
        self.resumeTimer()
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateImage()
        scrollView.contentOffset = CGPoint(x: scrollView.bounds.width, y: 0)
    }
}
