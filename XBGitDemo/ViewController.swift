//
//  ViewController.swift
//  XBGitDemo
//
//  Created by xbing on 2020/11/4.
//

import UIKit
import XBSwiftCoreModule
import SnapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    var manager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
 
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.allowsBackgroundLocationUpdates = true
        
        
        var coms = XBMenuButtonComponents()
        coms.titleColor = UIColor.black
        coms.selTitleColor = UIColor.red
        coms.downLineSelColor = UIColor.red
        let meneview = XBTopMenuView(titles: ["测试1","测试2"], contentSizeType: .equalToSuper, buttonComponents: coms)
        self.view.addSubview(meneview)
        meneview.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(60)
            make.height.equalTo(50)
        }

       
    }

    
    var block: (() -> Void)?
    var boolBlock: (() -> Bool)?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var b = 1
        self.block = {
            b = 2
        }
       print(b)
       click()
    }

    func click() {
//        let vc = XBTestListManagerController()
        let vc = XBTestCollectionController()
        self.present(vc, animated: true, completion: nil)
    }
}


public func test2() {
    //block值捕获导致vc不会及时释放，重新赋值block或者block=nil时vc才会释放
//    let vc = XBTestListManagerController()
//    autoreleasepool { () -> Bool in
//        return true
//
//    }
//    self.block = {
//        vc
//    }
//    self.block?()
}
