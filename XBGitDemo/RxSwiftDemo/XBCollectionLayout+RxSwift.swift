//
//  XBCollectionLayout+RxSwift.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/8.
//

import Foundation
import RxDataSources


extension RxCollectionViewSectionedReloadDataSource {
    public typealias ConfigureItemSize = (CollectionViewSectionedDataSource<Section>, UICollectionView, IndexPath, Item) -> CGSize
    public typealias ConfigureSecSize = (CollectionViewSectionedDataSource<Section>, UICollectionView, IndexPath, String) -> CGSize
    public convenience init(
        configureItemSize: @escaping ConfigureItemSize,
        configureSecSize: @escaping ConfigureSecSize,
        configureCell: @escaping ConfigureCell,
        configureSupplementaryView: ConfigureSupplementaryView? = nil
    ) {
        self.init(configureCell: configureCell, configureSupplementaryView: configureSupplementaryView)
        
        
    }
    
    
}
