//
//  XBListManager.swift
//  WZEfengAndEtong
//
//  Created by rongzebing on 2018/8/7.
//  Copyright © 2018年 wanzhao. All rights reserved.
//

import UIKit



public class XBCollectionManager: XBBaseListManager {
    
    deinit {
        print(#function,self.classForCoder)
    }
    
    
    weak public var delegate : XBCollectionManagerDelegate?
    weak public var flowLayout: UICollectionViewLayout!
    
    public init(flowLayout: UICollectionViewLayout? = nil, cellClass: String? = nil, emptyManager: XBListEmptyManagerProtocol? = nil) {
        super.init()
        
        self.flowLayout = flowLayout
        if self.flowLayout == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.estimatedItemSize = .zero
            flowLayout.scrollDirection = .vertical
            self.flowLayout = flowLayout
        }
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout!)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        self.cellClass = cellClass
        self.listView = collectionView
        //
        self.emptyManager = emptyManager
    }
    
    
    public override func reloadData() {
        (self.listView as? UICollectionView)?.reloadData()
        
        super.reloadData()
    }
    
    public override func XBListEmptyViewDidTap() {
        self.delegate?.XBListEmptyViewDidTap()
    }
}

extension XBCollectionManager: XBSectionViewdelegate, XBCelldelegate {
    
    
    
    public func handelSectionViewEvent(section: Int?, sectionData: XBSectionModelProtocol?, eventID: Int) {
        self.delegate?.handelSectionViewEvent(section: section, sectionData: sectionData, eventID: eventID)
    }
    
    public func handelCellEvent(indexPath: IndexPath?, item: XBDataModelProtocol?, eventID: Int) {
        self.delegate?.handelCellEvent(indexPath: indexPath, item: item, eventID: eventID)
    }
}

extension XBCollectionManager : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let tm = self.delegate?.numberOfSections?(in: collectionView) {
            return tm
        }
        return self.sectionArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let tm = self.delegate?.collectionView?(collectionView, numberOfItemsInSection: section) {
            return tm
        }
        let secModel = self.sectionArray[section]
        
        if secModel.isClose == true {
            return 0
        }
        return secModel.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let tm = self.delegate?.collectionView?(collectionView, cellForItemAt: indexPath) {
            return tm
        }
        
        var _cellClass = self.cellClass
        
        let secModel = self.sectionArray[indexPath.section]
        
        if secModel.cellClass != nil {
            _cellClass = secModel.cellClass
        }
        let dataModel = secModel.items[indexPath.row]
        
        if dataModel.cellClass != nil {
            _cellClass = dataModel.cellClass
        }
        
        assert(_cellClass != nil, "cellClass must not be nil")
        
        let collectionCell = collectionView.XBDequeueReusableCollectionCell(withClassName: _cellClass!, clsType: NSClassFromString(_cellClass!), for: indexPath)
        if let collectionCell = collectionCell as? XBCellDataProtocol{
            collectionCell.delegate = self
            collectionCell.indexPath = indexPath
            collectionCell.item = dataModel
            collectionCell.configureData(item: dataModel)
        }
        return collectionCell
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let tm = self.delegate?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return tm
        }
        let secModel = self.sectionArray[indexPath.section]
        var clsType: AnyClass?
        var clsName: String = ""
        
        if secModel.headerClass != nil && kind == UICollectionView.elementKindSectionHeader {
            clsName = secModel.headerClass!
            clsType = NSClassFromString(clsName)
        } else if secModel.footerClass != nil && kind == UICollectionView.elementKindSectionFooter {
            clsName = secModel.footerClass!
            clsType = NSClassFromString(clsName)
        } else {}
        
        //安全检测
        if clsName.count == 0 || clsType == nil {
            clsName = NSStringFromClass(UICollectionReusableView.self)
            clsType = UICollectionReusableView.self
        }
        
        let secView = collectionView.XBDequeueReusableSupplementaryView(withClassName: clsName, clsType: clsType, ofKind: kind, for: indexPath)

        if let secView = secView as? XBSectionViewDataProtocol {
            secView.configureData(item: secModel)
            secView.delegate = self
            secView.section = indexPath.section
            secView.sectionData = secModel
        }
        return secView
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.delegate?.collectionView?(collectionView, canMoveItemAt: indexPath) ?? false
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.delegate?.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return self.delegate?.indexTitles?(for: collectionView)
    }

}

extension XBCollectionManager : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sec = sectionArray[indexPath.section]
        if sec.items.count == 0 {
            return
        }
        self.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let sec = sectionArray[indexPath.section]
        if sec.items.count == 0 {
            return
        }
        self.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    //MARK: scrollDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.collectionViewDidScroll?(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
   
}
extension XBCollectionManager: XBCollectionLayoutDelegate {
    //MARK : FLowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        if let edgeInsets = self.delegate?.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) {
            return edgeInsets
        }
       
        let secModel = self.sectionArray[section]
        return secModel.edgeInsets
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        if let tm = self.delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) {
            return tm
        }
        let secModel = self.sectionArray[section]
        return secModel.lineSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if let tm = self.delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) {
            return tm
        }
        let secModel = self.sectionArray[section]
        return secModel.itemSpace
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let tm = self.delegate?.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) {
            return tm
        }
        let secModel = self.sectionArray[section]
       
        if secModel.isEdit {
            return secModel.editSize
        }
        return secModel.headerSize
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
       
        if let tm = self.delegate?.collectionView?(collectionView,layout:collectionViewLayout, referenceSizeForFooterInSection: section) {
            return tm
        }
        
        let secModel = self.sectionArray[section]
        
        if secModel.isFooterEdit {
            return secModel.footerEditSize
        }
        return secModel.footerSize
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tm = self.delegate?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) {
            return tm
        }
        let secModel = self.sectionArray[indexPath.section]
        let dataModel = secModel.items[indexPath.row]
        if dataModel.isEdit {
            return dataModel.editSize
        }
        
        if dataModel.cellSize != XBListDefaultSecSize {
           return dataModel.cellSize
        }
        if secModel.cellSize != XBListDefaultSecSize {
            return secModel.cellSize
        }
        return self.cellSize
    }
    
    //MARK: custom header与footer的偏移量

    public func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemColumInsection section: Int) -> Int {
        if let tm = self.delegate?.XBCollectionView?(collectionView, layout: collectionViewLayout, itemColumInsection: section) {
            return tm
        }
        let colum = (self.flowLayout as? XBCollectionLayout)?.itemColum ?? 1
        return colum
    }
    
    public func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForHeaderAt section: Int) -> UIEdgeInsets {
        if let tm = self.delegate?.XBCollectionView?(collectionView, layout: collectionViewLayout, insetForHeaderAt: section) {
            return tm
        }
        let insets = (self.flowLayout as? XBCollectionLayout)?.headerInset ?? .zero
        return insets
    }
    public func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForFooterAt section: Int) -> UIEdgeInsets {
        if let tm = self.delegate?.XBCollectionView?(collectionView, layout: collectionViewLayout, insetForFooterAt: section) {
            return tm
        }
        let insets = (self.flowLayout as? XBCollectionLayout)?.footerInset ?? .zero
        return insets
    }
}
