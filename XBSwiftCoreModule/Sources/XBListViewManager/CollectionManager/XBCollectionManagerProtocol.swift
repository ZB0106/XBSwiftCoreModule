//
//  XBCollectionManagerProtocol.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit


@objc public protocol XBUICollectionViewDataSource: NSObjectProtocol {
    @objc optional func numberOfSections(in collectionView: UICollectionView) -> Int
    @objc optional func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   
    @objc optional func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    
    
    @objc optional func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    
    @objc optional func CollectionView(_ collectionView: UICollectionView, cellForItem cell: UICollectionViewCell, at indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool

    @objc optional func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)

    @objc optional func indexTitles(for collectionView: UICollectionView) -> [String]?

    @objc optional func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath
}


@objc public protocol XBUICollectionViewDelegate: NSObjectProtocol {
    @objc optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    @objc optional func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func collectionViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}
@objc public protocol XBUICollectionViewDelegateFlowLayout {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
   @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    
    //MARK: custom header与footer的偏移量
    @objc optional func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForHeaderAt section: Int) -> UIEdgeInsets
    @objc optional func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForFooterAt section: Int) -> UIEdgeInsets
    @objc optional func XBCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemColumInsection section: Int) -> Int
}
public typealias XBCollectionManagerDelegate = XBCelldelegate&XBSectionViewdelegate&XBUICollectionViewDelegate&XBUICollectionViewDataSource&XBUICollectionViewDelegateFlowLayout&XBListEmptyViewDelegate
