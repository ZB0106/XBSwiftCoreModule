//
//  XBCollectionLayout.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/27.
//

import Foundation
import UIKit




open class XBCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
}

open class XBCollectionLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext {

    public override init() {
        super.init()
    }
    // if set to NO, flow layout will not requery the collection view delegate for size information etc.
    open var invalidateFlowLayoutDelegateMetrics: Bool = true
    
    // if set to NO, flow layout will keep all layout information, effectively not invalidating - useful for a subclass which invalidates only a piece of itself
    open var invalidateFlowLayoutAttributes: Bool = true
}


@objc public protocol XBCollectionLayoutDelegate: UICollectionViewDelegateFlowLayout {
    //宽度为0时会自动计算宽度，会自动根据列数计算宽度
   
    //MARK: custom itemColumInsection
    @objc optional func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemColumInsection section: Int) -> Int
    // //动画相关
//    open var transform3D: CATransform3D = CATransform3DIdentity
//    open var transform: CGAffineTransform = .identity
//    open var zIndex: Int = 0
    //
        
}

extension XBCollectionLayout {
    public enum XBSectionInsetReference : Int {
        //不会根据contentinset 改变header或者footer的悬浮位置
        case none = 0
        //根据contentinset改变header和footer的悬浮位置
        case headerfromContentInset = 1
        case footerfromContentInset = 2
        case fromContentInset = 3
    }
    //MARK:waterflow宽度为0或者高度为0时会自动计算宽高，设置宽高后就不会限制滚动方向
    public enum XBCollectionLayoutType: Int {
        case leftFlow = 0
        case centerFlow = 1
        case waterFlow = 2//
    }
    public enum XBCollectionLayoutDirection: Int {
        case vertical = 0
        case horizontal = 1
    }
    
    public typealias XBSectionConfigure = (section: Int, x: CGFloat, y: CGFloat, lineSpace: CGFloat, itemSpace: CGFloat, sectionInsets: UIEdgeInsets, headerAttr: XBCollectionViewLayoutAttributes?, footerAttr: XBCollectionViewLayoutAttributes?, itemAttrs: [XBCollectionViewLayoutAttributes])
}

open class XBCollectionLayout: UICollectionViewLayout {
    
   
    open override class var layoutAttributesClass: AnyClass {XBCollectionViewLayoutAttributes.self}
    
    //布局属性代理，自身的代理
    weak private var delegete: XBCollectionLayoutDelegate? {collectionView?.delegate as? XBCollectionLayoutDelegate}
    
    open var scrollDirection: XBCollectionLayout.XBCollectionLayoutDirection = .vertical { didSet {invalidateLayout()} }// default is UICollectionViewScrollDirectionVertical
    open var layoutType: XBCollectionLayoutType = .centerFlow { didSet {invalidateLayout()} }
    open var minimumLineSpacing: CGFloat = 0.0 {didSet {invalidateLayout()}}

    open var minimumInteritemSpacing: CGFloat = 0.0 {didSet {invalidateLayout()}}

    open var itemSize: CGSize = .zero {didSet {invalidateLayout()}}

    // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
    open var estimatedItemSize: CGSize = .zero {didSet {invalidateLayout()}}

    open var headerReferenceSize: CGSize = CGSize(width: 0.001, height: 0.001) {didSet {invalidateLayout()}}

    open var footerReferenceSize: CGSize = CGSize(width: 0.001, height: 0.001) {didSet {invalidateLayout()}}

    open var sectionInset: UIEdgeInsets = .zero {didSet {invalidateLayout()}}
    open var headerInset: UIEdgeInsets = .zero {didSet {invalidateLayout()}}
    open var footerInset: UIEdgeInsets = .zero {didSet {invalidateLayout()}}
    /// The reference boundary that the section insets will be defined as relative to. Defaults to `.fromContentInset`.
    /// NOTE: Content inset will always be respected at a minimum. For example, if the sectionInsetReference equals `.fromSafeArea`, but the adjusted content inset is greater that the combination of the safe area and section insets, then section content will be aligned with the content inset instead.
    
    open var sectionInsetReference: XBCollectionLayout.XBSectionInsetReference = .none {didSet {invalidateLayout()}}


    // Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).
    open var sectionHeadersPinToVisibleBounds: Bool = false {didSet {invalidateLayout()}}

    open var sectionFootersPinToVisibleBounds: Bool = false {didSet {invalidateLayout()}}
    //每组的列数
    open var itemColum = 1
    //对attris数组进行采样的最小值
    private var minAttrsCount = 20
    //采样数组重新生成的rect并集
    private var unionRects: [CGRect] = []
    
    private var contentSize: CGSize = .zero
    private var collectionAttrs = [XBCollectionViewLayoutAttributes]()
    private var sectionConfigures = [XBSectionConfigure]()
    private var maxW: CGFloat = 0
    private var maxH: CGFloat = 0
    private var dataQueque: DispatchQueue?
    public override init() {
        super.init()
        self.dataQueque = DispatchQueue(label: "com.XBingListViewManagerQueque")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public override func invalidateLayout() {
        //官方文档必须调用super
        super.invalidateLayout()
    }
    
    public override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        guard collectionView.bounds.size.width != 0 || collectionView.bounds.height != 0 else {return}
       
        sectionConfigures.removeAll()
        collectionAttrs.removeAll()
        unionRects.removeAll()
        
        maxH = collectionView.bounds.height
        maxW = collectionView.bounds.width
        
        
        prepareLayoutAttributes(collectionView: collectionView)
        
    }
}

extension XBCollectionLayout {
    
    open func prepareLayoutAttributes(collectionView: UICollectionView) {
        
        autoreleasepool {
            switch (scrollDirection) {
            case (.horizontal):
                horizonFlow(collectionView: collectionView)
            case (.vertical):
                verticalFlow(collectionView: collectionView)
            }
        }
    }
}
//MARK:布局
extension XBCollectionLayout {

    //MARK: 垂直布局
    private func verticalFlow(collectionView: UICollectionView) {
        let colletionW = collectionView.bounds.width
        var y: CGFloat = 0
        var x: CGFloat = 0
        for section in 0..<collectionView.numberOfSections {
            
            //sectionConfigure
            var sectionConfigure = XBSectionConfigure(section, 0, y, 0, 0, .zero, nil, nil, [])
            
            sectionConfigure.sectionInsets = delegete?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
            
            sectionConfigure.lineSpace = delegete?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
            
            sectionConfigure.itemSpace = delegete?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
            
            //如果是centerflow就取最大值进行布局
            if layoutType == .centerFlow {
                let maxgap = max(sectionConfigure.sectionInsets.left, sectionConfigure.sectionInsets.right, sectionConfigure.itemSpace)
                sectionConfigure.sectionInsets.left = maxgap
                sectionConfigure.sectionInsets.right = maxgap
                sectionConfigure.itemSpace = maxgap
            }
            
            //header
            let headerSize = delegete?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
            let headerAttr = XBCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
            headerAttr.frame.origin = CGPoint(x: 0, y: y)
            headerAttr.frame.size = headerSize
            sectionConfigure.headerAttr = headerAttr
            collectionAttrs.append(headerAttr)
            
           
            //items
            handeleVerticalSectionItemAttrs(sectionConfigure: &sectionConfigure, collectionView: collectionView)
            
            //footer
            
            let footerSize = delegete?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
            let footerAttr = XBCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(row: 0, section: section))
            footerAttr.frame.origin = CGPoint(x: 0, y: sectionConfigure.y)
            footerAttr.frame.size = footerSize
            sectionConfigure.footerAttr = footerAttr
            
            
            y = sectionConfigure.footerAttr!.frame.maxY
            x = max(sectionConfigure.x, x)
            
            //重设header footer
            let w = max(x, colletionW)
            if footerSize.width == 0 {
                footerAttr.frame.size.width = w
            }
            if headerSize.width == 0 {
                headerAttr.frame.size.width = w
            }
            collectionAttrs.append(footerAttr)
            sectionConfigures.append(sectionConfigure)
           
        }
        maxH = y
        maxW = x
        var item = 0
        let itemsCount = collectionAttrs.count
        while item < itemsCount {
            let rect1 = collectionAttrs[item].frame
            item = min(item+minAttrsCount, itemsCount)-1
            let rect2 = collectionAttrs[item].frame
            unionRects.append(rect1.union(rect2))
            item += 1
        }
    }
    
    func handeleVerticalSectionItemAttrs(sectionConfigure: inout XBSectionConfigure, collectionView: UICollectionView) {
        let colletionW = collectionView.bounds.width
        var maxSize: CGFloat = 0
        let oriW = sectionConfigure.sectionInsets.right - sectionConfigure.itemSpace + sectionConfigure.sectionInsets.left
        let itemCount = collectionView.numberOfItems(inSection: sectionConfigure.section)
        sectionConfigure.x = oriW
        
        switch layoutType {
        case .leftFlow,.centerFlow:
            sectionConfigure.x = 0
            sectionConfigure.y += (sectionConfigure.sectionInsets.top+sectionConfigure.headerAttr!.size.height)
            var curSize: CGSize?
            var nextSize: CGSize?
            var subAttrSizes: [XBCollectionViewLayoutAttributes] = []
            var nextIndexPath: IndexPath?
            var curIndexPath: IndexPath?
            for item in 0..<itemCount {
                if nextSize != nil {
                    curSize = nextSize
                    curIndexPath = nextIndexPath
                } else {
                    curIndexPath = IndexPath(item: item, section: sectionConfigure.section)
                    curSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: curIndexPath!) ?? self.itemSize
                }
                if item < itemCount-1 {
                    nextIndexPath = IndexPath(item: item+1, section: sectionConfigure.section)
                    nextSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: nextIndexPath!) ?? self.itemSize
                } else {
                    nextIndexPath = curIndexPath
                    nextSize = curSize
                }
                if curSize! == .zero {
                    curSize = collectionView.cellForItem(at: curIndexPath!)?.sizeThatFits(CGSize(width: 0, height: 0)) ?? .zero
                }
                
                maxSize = maxSize > curSize!.height ? maxSize : curSize!.height
                let itemAttr = XBCollectionViewLayoutAttributes(forCellWith: curIndexPath!)
                itemAttr.frame.size = curSize!
                itemAttr.frame.origin  = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                sectionConfigure.x += curSize!.width + sectionConfigure.itemSpace
                sectionConfigure.itemAttrs.append(itemAttr)
                collectionAttrs.append(itemAttr)
                
                subAttrSizes.append(itemAttr)
                
                if sectionConfigure.x + nextSize!.width + sectionConfigure.itemSpace > colletionW || item == itemCount-1 {
                    let subW = subAttrSizes.compactMap{$0.size.width}.reduce(0, +)
                    var gap: CGFloat = 0
                    if layoutType == .leftFlow {
                        if subAttrSizes.count == 0 {
                            gap = floor(sectionConfigure.sectionInsets.left)
                        } else {
                            gap = floor((colletionW-subW-sectionConfigure.sectionInsets.left-sectionConfigure.sectionInsets.right)/CGFloat(subAttrSizes.count-1))
                        }
                        sectionConfigure.x = sectionConfigure.sectionInsets.left
                        subAttrSizes.forEach { itemAttr in
                            itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                            sectionConfigure.x += itemAttr.size.width+gap
                        }
                    } else {
                        gap = floor((colletionW-subW)/CGFloat(subAttrSizes.count+1))
                        sectionConfigure.x = gap
                        subAttrSizes.forEach { itemAttr in
                            itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                            sectionConfigure.x += itemAttr.size.width+gap
                        }
                    }
                    
                    sectionConfigure.y += (sectionConfigure.lineSpace+maxSize)
                    maxSize = 0
                    sectionConfigure.x = oriW
                    subAttrSizes.removeAll()
                }
                
            }
            sectionConfigure.y += sectionConfigure.sectionInsets.bottom-sectionConfigure.lineSpace
        case .waterFlow:
            sectionConfigure.x = sectionConfigure.sectionInsets.left
            sectionConfigure.y += (sectionConfigure.sectionInsets.top+sectionConfigure.headerAttr!.size.height)
            var _itemColum = delegete?.XBCollectionView?(collectionView, layout: self, itemColumInsection: sectionConfigure.section) ?? itemColum

            assert(_itemColum != 0, "colum must not be 0")

            _itemColum = _itemColum <= itemCount ? _itemColum : itemCount

            var preColumAttrs = [XBCollectionViewLayoutAttributes]()
            var currentColumAttrs = [XBCollectionViewLayoutAttributes]()
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: sectionConfigure.section)
                var realSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
                if realSize.width == 0 {
                    realSize.width = floor((colletionW - sectionConfigure.sectionInsets.left - sectionConfigure.sectionInsets.right - CGFloat(_itemColum - 1) * sectionConfigure.itemSpace) / CGFloat(_itemColum))
                }
                if realSize.height == 0 {
                    realSize.height = collectionView.cellForItem(at: indexPath)?.sizeThatFits(CGSize(width: realSize.width, height: 0)).height ?? 0
                }
                let itemAttr = XBCollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttr.frame.size = realSize
                itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)

                sectionConfigure.itemAttrs.append(itemAttr)
                collectionAttrs.append(itemAttr)

                currentColumAttrs.append(itemAttr)

                if currentColumAttrs.count == _itemColum || item == itemCount - 1 {
                    //第一组数据
                    if item < _itemColum {
                        currentColumAttrs.sort(by: {$0.size.height > $1.size.height})
                        currentColumAttrs.forEach {$0.frame.origin.x = sectionConfigure.x; sectionConfigure.x = $0.frame.maxX + sectionConfigure.itemSpace}
                        sectionConfigure.x = sectionConfigure.x + sectionConfigure.sectionInsets.right - sectionConfigure.itemSpace
                    } else {
                        preColumAttrs.sort(by: {$0.frame.maxY < $1.frame.maxY})
                        currentColumAttrs.sort(by: {$0.size.height > $1.size.height})
                        for i in 0..<currentColumAttrs.count  {
                            let cur = currentColumAttrs[i]
                            let pre = preColumAttrs[i]
                            cur.frame.origin.x = pre.frame.origin.x
                            cur.frame.origin.y = pre.frame.maxY + sectionConfigure.lineSpace
                        }
                    }
                    //最后一组
                    preColumAttrs.removeAll()
                    if item != itemCount - 1 {
                        preColumAttrs.append(contentsOf: currentColumAttrs)
                        currentColumAttrs.removeAll()
                    } else {
                        currentColumAttrs.append(contentsOf: preColumAttrs)
                    }

                }
            }

            sectionConfigure.y = (currentColumAttrs.max(by: {$0.frame.maxY < $1.frame.maxY})?.frame.maxY ?? sectionConfigure.y) + sectionConfigure.sectionInsets.bottom
            //移除
            currentColumAttrs.removeAll()
        }
    }
    
    
    //MARK: 水平布局
    private func horizonFlow(collectionView: UICollectionView) {
        let colletionH = collectionView.bounds.height
        var y: CGFloat = 0
        var x: CGFloat = 0
        for section in 0..<collectionView.numberOfSections {
            
            //sectionConfigure
            var sectionConfigure = XBSectionConfigure(section, x, 0, 0, 0, .zero, nil, nil, [])
            
            sectionConfigure.sectionInsets = delegete?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
            
            sectionConfigure.lineSpace = delegete?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
            
            sectionConfigure.itemSpace = delegete?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
            
            //如果是centerflow就取最大值进行布局
            if layoutType == .centerFlow {
                let maxgap = max(sectionConfigure.sectionInsets.top, sectionConfigure.sectionInsets.bottom, sectionConfigure.lineSpace)
                sectionConfigure.sectionInsets.top = maxgap
                sectionConfigure.sectionInsets.bottom = maxgap
                sectionConfigure.lineSpace = maxgap
            }
            
            //header
            let headerSize = delegete?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
            let headerAttr = XBCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
            headerAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: 0)
            headerAttr.frame.size = headerSize
            sectionConfigure.headerAttr = headerAttr
            collectionAttrs.append(headerAttr)
            
           
            //items
            handeleHorizonSectionItemAttrs(sectionConfigure: &sectionConfigure, collectionView: collectionView)
            
            //footer
            
            let footerSize = delegete?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
            let footerAttr = XBCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(row: 0, section: section))
            footerAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: 0)
            footerAttr.frame.size = footerSize
            sectionConfigure.footerAttr = footerAttr
            
            
            y = max(sectionConfigure.y, y)
            x = sectionConfigure.footerAttr!.frame.maxX
            
            //重设header footer
            let h = max(y, colletionH)
            if footerSize.height == 0 {
                footerAttr.frame.size.height = h
            }
            if headerSize.height == 0 {
                headerAttr.frame.size.height = h
            }
            collectionAttrs.append(footerAttr)
            sectionConfigures.append(sectionConfigure)
           
        }
        maxH = y
        maxW = x
        var item = 0
        let itemsCount = collectionAttrs.count
        while item < itemsCount {
            let rect1 = collectionAttrs[item].frame
            item = min(item+minAttrsCount, itemsCount)-1
            let rect2 = collectionAttrs[item].frame
            unionRects.append(rect1.union(rect2))
            item += 1
        }
    }
    
    func handeleHorizonSectionItemAttrs(sectionConfigure: inout XBSectionConfigure, collectionView: UICollectionView) {
        let colletionH = collectionView.bounds.height
        var maxWidth: CGFloat = 0
        let oriH = sectionConfigure.sectionInsets.top - sectionConfigure.lineSpace + sectionConfigure.sectionInsets.bottom
        let itemCount = collectionView.numberOfItems(inSection: sectionConfigure.section)
        sectionConfigure.y = oriH
        
        switch layoutType {
        case .leftFlow,.centerFlow:
            sectionConfigure.y = 0
            sectionConfigure.x += (sectionConfigure.sectionInsets.left+sectionConfigure.headerAttr!.size.width)
            var curSize: CGSize?
            var nextSize: CGSize?
            var subAttrSizes: [XBCollectionViewLayoutAttributes] = []
            var nextIndexPath: IndexPath?
            var curIndexPath: IndexPath?
            for item in 0..<itemCount {
                if nextSize != nil {
                    curSize = nextSize
                    curIndexPath = nextIndexPath
                } else {
                    curIndexPath = IndexPath(item: item, section: sectionConfigure.section)
                    curSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: curIndexPath!) ?? self.itemSize
                }
                if item < itemCount-1 {
                    nextIndexPath = IndexPath(item: item+1, section: sectionConfigure.section)
                    nextSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: nextIndexPath!) ?? self.itemSize
                } else {
                    nextIndexPath = curIndexPath
                    nextSize = curSize
                }
                if curSize! == .zero {
                    curSize = collectionView.cellForItem(at: curIndexPath!)?.sizeThatFits(CGSize(width: 0, height: 0)) ?? .zero
                }
                
                maxWidth = maxWidth > curSize!.width ? maxWidth : curSize!.width
                let itemAttr = XBCollectionViewLayoutAttributes(forCellWith: curIndexPath!)
                itemAttr.frame.size = curSize!
                itemAttr.frame.origin  = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                sectionConfigure.y += curSize!.height + sectionConfigure.lineSpace
                sectionConfigure.itemAttrs.append(itemAttr)
                collectionAttrs.append(itemAttr)
                
                subAttrSizes.append(itemAttr)
                
                if sectionConfigure.y + nextSize!.height + sectionConfigure.lineSpace > colletionH || item == itemCount-1 {
                    let subH = subAttrSizes.compactMap{$0.size.height}.reduce(0, +)
                    var gap: CGFloat = 0
                    if layoutType == .leftFlow {
                        if subAttrSizes.count == 0 {
                            gap = floor(sectionConfigure.sectionInsets.top)
                        } else {
                            gap = floor((colletionH-subH-sectionConfigure.sectionInsets.top-sectionConfigure.sectionInsets.bottom)/CGFloat(subAttrSizes.count-1))
                        }
                        sectionConfigure.y = sectionConfigure.sectionInsets.top
                        subAttrSizes.forEach { itemAttr in
                            itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                            sectionConfigure.y += itemAttr.size.height+gap
                        }
                    } else {
                        gap = floor((colletionH-subH)/CGFloat(subAttrSizes.count+1))
                        sectionConfigure.y = gap
                        subAttrSizes.forEach { itemAttr in
                            itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)
                            sectionConfigure.y += itemAttr.size.height+gap
                        }
                    }
                    
                    sectionConfigure.x += (sectionConfigure.itemSpace + maxWidth)
                    maxWidth = 0
                    sectionConfigure.y = oriH
                    subAttrSizes.removeAll()
                }
                
            }
            sectionConfigure.x += sectionConfigure.sectionInsets.right - sectionConfigure.itemSpace
        case .waterFlow:
            sectionConfigure.x += sectionConfigure.sectionInsets.left+sectionConfigure.headerAttr!.size.width
            sectionConfigure.y = sectionConfigure.sectionInsets.top
            var _itemColum = delegete?.XBCollectionView?(collectionView, layout: self, itemColumInsection: sectionConfigure.section) ?? itemColum

            assert(_itemColum != 0, "colum must not be 0")

            _itemColum = _itemColum <= itemCount ? _itemColum : itemCount

            var preColumAttrs = [XBCollectionViewLayoutAttributes]()
            var currentColumAttrs = [XBCollectionViewLayoutAttributes]()
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: sectionConfigure.section)
                var realSize = delegete?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
                if realSize.height == 0 {
                    realSize.height = floor((colletionH - sectionConfigure.sectionInsets.top - sectionConfigure.sectionInsets.bottom - CGFloat(_itemColum - 1) * sectionConfigure.lineSpace) / CGFloat(_itemColum))
                }
                if realSize.width == 0 {
                    realSize.width = collectionView.cellForItem(at: indexPath)?.sizeThatFits(CGSize(width: 0, height: realSize.height)).width ?? 0
                }
                let itemAttr = XBCollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttr.frame.size = realSize
                itemAttr.frame.origin = CGPoint(x: sectionConfigure.x, y: sectionConfigure.y)

                sectionConfigure.itemAttrs.append(itemAttr)
                collectionAttrs.append(itemAttr)

                currentColumAttrs.append(itemAttr)

                if currentColumAttrs.count == _itemColum || item == itemCount - 1 {
                    //第一组数据
                    if item < _itemColum {
                        currentColumAttrs.sort(by: {$0.size.width > $1.size.width})
                        currentColumAttrs.forEach {$0.frame.origin.y = sectionConfigure.y; sectionConfigure.y = $0.frame.maxY + sectionConfigure.lineSpace}
                        sectionConfigure.y = sectionConfigure.y + sectionConfigure.sectionInsets.bottom - sectionConfigure.lineSpace
                    } else {
                        preColumAttrs.sort(by: {$0.frame.maxX < $1.frame.maxX})
                        currentColumAttrs.sort(by: {$0.size.width > $1.size.width})
                        for i in 0..<currentColumAttrs.count  {
                            let cur = currentColumAttrs[i]
                            let pre = preColumAttrs[i]
                            cur.frame.origin = CGPoint(x: pre.frame.maxX + sectionConfigure.itemSpace, y: pre.frame.origin.y)
                        }
                    }
                    //最后一组
                    preColumAttrs.removeAll()
                    if item != itemCount - 1 {
                        preColumAttrs.append(contentsOf: currentColumAttrs)
                        currentColumAttrs.removeAll()
                    } else {
                        currentColumAttrs.append(contentsOf: preColumAttrs)
                    }

                }
            }

            sectionConfigure.x = (currentColumAttrs.max(by: {$0.frame.maxX < $1.frame.maxX})?.frame.maxX ?? sectionConfigure.x) + sectionConfigure.sectionInsets.right
            //移除
            currentColumAttrs.removeAll()
        }
    }
    
}

extension XBCollectionLayout {
   
    // return an array layout attributes instances for all the views in the given rect
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //collectionViewContentSize返回的width和height不能为0，此处的rect会根据contentSize返回，若size为0，则会导致rect的width或者height为0，从而使以下获取交集的方法出问题
        //借鉴CHTCollectionViewWaterfallLayout里的算法
        guard rect != .zero, collectionView != nil else {
            return nil
        }
        var start = 0, end = unionRects.count
        if let i = unionRects.firstIndex(where: {rect.intersects($0)}) {
          start = i*minAttrsCount
        }
        if let i = unionRects.lastIndex(where: {rect.intersects($0)}) {
            end = min((i+1)*minAttrsCount, collectionAttrs.count)
        }
        print(#function)
//        collectionAttrs[start..<end].filter { rect.intersects($0.frame) }
        return Array(collectionAttrs[start..<end])
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> XBCollectionViewLayoutAttributes? {
        print(#function)
        guard collectionView != nil else {
            return nil
        }
        guard sectionConfigures.count > indexPath.section else {
            return nil
        }
        let list = sectionConfigures[indexPath.section].itemAttrs
        guard list.count > indexPath.row else {
            return nil
        }
        return list[indexPath.row]
    }

    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> XBCollectionViewLayoutAttributes? {
        print(#function)
        guard collectionView != nil else {
            return nil
        }
        guard sectionConfigures.count > indexPath.section else {
            return nil
        }
        
        var attr: XBCollectionViewLayoutAttributes?
        switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                attr = sectionConfigures[indexPath.section].headerAttr
            case UICollectionView.elementKindSectionFooter:
                attr = sectionConfigures[indexPath.section].footerAttr
            default: break
        }
        return attr
    }
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width || newBounds.height != collectionView?.bounds.height
    }
    // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
    open override var collectionViewContentSize: CGSize {
        
        guard collectionView != nil else {
            return .zero
        }
        return CGSize(width: maxW, height: maxH)
    }

    //停止拖动的时候会调用
//    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//    }
//    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
//    }
    
//    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
//    }
//    open override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
//    }
//    open override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.initialLayoutAttributesForAppearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
//    }
//    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
//    }
//    open override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
//    }
//    open override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print(#function)
//        return super.finalLayoutAttributesForDisappearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
//    }
}
//工具类
//交换值
//MARK: 工具类


