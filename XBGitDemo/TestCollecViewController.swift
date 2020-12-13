//
//  TestCollecViewController.swift
//  XBWorkSumary
//
//  Created by 苹果兵 on 2020/10/31.
//

import UIKit

class TestCollecViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ceshi", for: indexPath)
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.addSubview(btn)
        btn.backgroundColor = UIColor.gray
        btn.setImage(UIImage(named: "icon60"), for: .normal)
        btn.layer.cornerRadius = 15.0
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.red.cgColor
//        btn.viewByRoundCorner(radius: 15.0, corners: [.topLeft,.topRight], size: CGSize(width: 50, height: 50), borderColor: UIColor.red, borderWidth: 8.0)
        
//        var im = UIImage(named: "icon60")
////        im = im?.imageByRoundCorner(radius: 15.0, corners: [.allCorners], borderWidth: 2.0, borderColor: UIColor.red, borderLineJion: CGLineJoin.round)
//        let iv = UIImageView(image: im)
//        iv.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        iv.layer.cornerRadius = 15.0
//        iv.layer.masksToBounds = true
//        iv.layer.borderWidth = 2.0
//        iv.layer.borderColor = UIColor.red.cgColor
//        cell.addSubview(iv)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let fl = UICollectionViewFlowLayout()
        let col = UICollectionView(frame: self.view.bounds, collectionViewLayout: fl)
        col.delegate = self
        col.dataSource = self
        
        col.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ceshi")
        self.view.addSubview(col)
        
    }
    
    
    func changeHitArea(withInset inset: UIEdgeInsets)  {
        
    }

    func avoidSeriesTap(withSel sel: Selector, timeInterval: CGFloat = 0.5) {
        
    }
}
