//
//  ZB_TableViewManager.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/14.
//

import UIKit


//MARK: sectionTable
public class XBTableManager: XBBaseListManager {
    
    weak public var delegate: XBTableViewManagerDelegate?
    public init(style: UITableView.Style = .grouped, cellClass: String? = nil, cellSize: CGSize? = nil, emptyManager: XBListEmptyManagerProtocol? = nil) {
        super.init()
        let temTableView = UITableView.init(frame: .zero, style: style)
        temTableView.delegate = self
        temTableView.dataSource = self
        temTableView.backgroundColor = UIColor.white
        temTableView.separatorStyle = .none
        temTableView.keyboardDismissMode = .onDrag
        temTableView.showsVerticalScrollIndicator = false
        //关闭自动估算高度
        temTableView.estimatedSectionHeaderHeight = 0.0
        temTableView.estimatedSectionFooterHeight = 0.0
        temTableView.estimatedRowHeight = 0.0
        self.cellClass = cellClass
        self.cellSize = cellSize ?? XBListDefaultSecSize
        
        //end
        self.listView = temTableView
        
        self.emptyManager = emptyManager
    }
    
    public override func reloadData() {
        (self.listView as? UITableView)?.reloadData()
        super.reloadData()
    }
    
    public override func XBListEmptyViewDidTap() {
        self.delegate?.XBListEmptyViewDidTap()
    }
}

extension XBTableManager: XBCelldelegate, XBSectionViewdelegate {
    
    public func handelSectionViewEvent(section: Int?, sectionData: XBSectionModelProtocol?, eventID: Int) {
        self.delegate?.handelSectionViewEvent(section: section, sectionData: sectionData, eventID: eventID)
    }
    
    public func handelCellEvent(indexPath: IndexPath?, item: XBDataModelProtocol?, eventID: Int) {
        self.delegate?.handelCellEvent(indexPath: indexPath, item: item, eventID: eventID)
    }
}

extension XBTableManager : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let tm = self.delegate?.numberOfSections?(in: tableView) {
            return tm
        }
        return sectionArray.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tm = self.delegate?.tableView?(tableView, numberOfRowsInSection: section) {
            return tm
        }
        let secModel = self.sectionArray[section]
        
        if secModel.isClose == true {
            return 0
        }
        return secModel.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tm = self.delegate?.tableView?(tableView, cellForRowAt: indexPath) {
            return tm
        }
        var _cellClass = self.cellClass
        
        let secModel = self.sectionArray[indexPath.section]
        let dataModel = secModel.items[indexPath.row]
        
        if secModel.cellClass != nil {
            _cellClass = secModel.cellClass
        }
        
        if dataModel.cellClass != nil {
            _cellClass = dataModel.cellClass
        }
        
        assert(_cellClass != nil, "cellClass must not be nil")
        
        let cell = tableView.XBDequeueReusableTableCell(withClassName: _cellClass!, clsType: NSClassFromString(_cellClass!))
        if let cell = cell as? XBCellDataProtocol{
            cell.delegate = self
            cell.indexPath = indexPath
            cell.item = dataModel
            cell.configureData(item: dataModel)
        }
        return cell!
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tm = self.delegate?.tableView?(tableView, viewForHeaderInSection: section) {
            return tm
        }
        let secModel = sectionArray[section]
        var clsName: String = secModel.headerClass ?? ""
        var clsType: AnyClass? = NSClassFromString(clsName)
        //安全检测
        if clsName.count == 0 || clsType == nil {
            clsName = NSStringFromClass(UITableViewHeaderFooterView.self)
            clsType = UITableViewHeaderFooterView.self
        }
        let secView = tableView.XBDequeueReusableHeaderFooterView(withClassName: clsName, clsType: clsType)
        if let secView = secView as? XBSectionViewDataProtocol {
            secView.configureData(item: secModel)
            secView.delegate = self
            secView.section = section
            secView.sectionData = secModel
        }
        return secView
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.delegate?.tableView?(tableView, titleForHeaderInSection: section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if let tm = self.delegate?.tableView?(tableView, viewForFooterInSection: section) {
            return tm
        }
        let secModel = sectionArray[section]
        var clsName: String = secModel.footerClass ?? ""
        var clsType: AnyClass? = NSClassFromString(clsName)
       
        if clsName.count == 0 || clsType == nil {
            clsName = NSStringFromClass(UITableViewHeaderFooterView.self)
            clsType = (UITableViewHeaderFooterView.self).self
        }
        let secView = tableView.XBDequeueReusableHeaderFooterView(withClassName: clsName, clsType: clsType)
        if let secView = secView as? XBSectionViewDataProtocol {
            secView.configureData(item: secModel)
            secView.delegate = self
            secView.section = section
        }
        return secView
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.delegate?.tableView?(tableView, titleForFooterInSection: section)
    }
    
   
}
extension XBTableManager : UITableViewDelegate {
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tm = self.delegate?.tableView?(tableView, heightForHeaderInSection: section) {
            return tm
        }
        let secModel = sectionArray[section]
        if secModel.isEdit {
            return secModel.editSize.height
        }
        return secModel.headerSize.height
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let tm = self.delegate?.tableView?(tableView, heightForFooterInSection: section) {
            return tm
        }
        let secModel = sectionArray[section]
        if secModel.isFooterEdit {
            return secModel.footerEditSize.height
        }
        return secModel.footerSize.height
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tm = self.delegate?.tableView?(tableView, heightForRowAt: indexPath) {
            return tm
        }
        let secModel = sectionArray[indexPath.section]
        let dataModel = secModel.items[indexPath.row]
        
        if dataModel.isEdit {
            return dataModel.editSize.height
        }
        if dataModel.cellSize.height != 0 {
            return dataModel.cellSize.height
        }
        if secModel.cellSize != XBListDefaultSecSize {
            return secModel.cellSize.height
        }
        return self.cellSize.height
    }
   
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.delegate?.tableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.delegate?.tableView?(tableView, editActionsForRowAt: indexPath)
    }

    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.delegate?.tableView?(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
    }

    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.delegate?.tableView?(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    self.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
}
