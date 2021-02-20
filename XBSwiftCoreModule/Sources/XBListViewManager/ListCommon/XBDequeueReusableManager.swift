//
//  XBDequeCellManager.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit
//MARK : dequeueReusable


private struct XBAssociatedKeys {
    static var listViewSetsKey = "XBlistViewSetsKey"
    static var listCellSetsKey = "XBlistCellSetsKey"
}

internal extension UIScrollView {
    var viewSets: Set<String> {
         set {
             objc_setAssociatedObject(self, &XBAssociatedKeys.listViewSetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
         }
         get {
             var sets = objc_getAssociatedObject(self, &XBAssociatedKeys.listCellSetsKey) as? Set<String>
             if sets == nil {
                 sets = Set<String>()
                 objc_setAssociatedObject(self, &XBAssociatedKeys.listCellSetsKey, sets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
             }
             return sets!
         }
     }
    var cellSets: Set<String> {
         set {
             objc_setAssociatedObject(self, &XBAssociatedKeys.listCellSetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
         }
         get {
             var sets = objc_getAssociatedObject(self, &XBAssociatedKeys.listCellSetsKey) as? Set<String>
             if sets == nil {
                 sets = Set<String>()
                 objc_setAssociatedObject(self, &XBAssociatedKeys.listCellSetsKey, sets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
             }
             return sets!
         }
     }
}
internal extension UICollectionView {
   
   
    
    
   func XBDequeueReusableSupplementaryView(withClassName clsName: String, clsType: AnyClass?, ofKind elementKind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = "XB"+clsName+elementKind
        if viewSets.contains(identifier) == false {
            self.register(clsType, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
            viewSets.insert(identifier)
        }
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    func XBDequeueReusableCollectionCell(withClassName clsName: String, clsType: AnyClass?, for indexPath: IndexPath) -> UICollectionViewCell {
        //swit 2.0以后 UICollectionViewCell.self 可以直接获取到包名+类名 eg：XBSwiftCoreModule.UICollectionViewCell,所以可以直接使用创建cell
        let identifier = "XB"+clsName
        if cellSets.contains(identifier) == false {
            self.register(clsType, forCellWithReuseIdentifier: identifier)
            cellSets.insert(identifier)
        }
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}





internal extension UITableView {
    
    func XBDequeueReusableHeaderFooterView(withClassName clsName: String, clsType: AnyClass?) -> UITableViewHeaderFooterView {
        let identifier = "XB"+clsName
        guard let clsType = clsType as? UITableViewHeaderFooterView.Type else {
            fatalError("class must be kind of UITableViewCell")
        }
        if viewSets.contains(identifier) == false {
            self.register(clsType, forHeaderFooterViewReuseIdentifier: identifier)
            viewSets.insert(identifier)
        }
        var view = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if view == nil {
            view = clsType.init(reuseIdentifier: identifier)
        }
        return view!
    }
    //swit 2.0以后 UICollectionViewCell.self 可以直接获取到包名+类名 eg：XBSwiftCoreModule.UICollectionViewCell,所以可以直接使用创建cell
    func XBDequeueReusableTableCell(withClassName clsName: String, clsType: AnyClass?) -> UITableViewCell {
        let identifier = "XB"+clsName
        guard let clsType = clsType as? UITableViewCell.Type else {
            fatalError("class must be kind of UITableViewCell")
        }
        if cellSets.contains(identifier) == false {
            self.register(clsType, forCellReuseIdentifier: identifier)
            cellSets.insert(identifier)
        }
        var cell = self.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = clsType.init(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
}
