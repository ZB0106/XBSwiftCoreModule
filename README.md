# XBIOSCode

## 介绍
```1、简单易用的listManager，省去你写tableview与collectionview代理以及数据源方法的时间，使得代码更简洁```  
```2、简单易用的collectionLayout，包含有流水布局，居中布局，以及左布局，同时支持水平布局```  
```3、简单易用的circleview，非常轻量级无限循环滚动库，通过这个库，你可以很方便的实现无限循环滚动，并添加定时器以及pagecontrol（自定义），分为6种样式，使用layer绘制，并做了内存缓存，防止多次绘制，（包括图片、问题、以及背景色三种子类型，还有single与mutileple父类型）```  
```4、简单易用的menuview，非常轻量级菜单选择控件，通过这个库，你可以很方便的定制可滚动的选项卡```  

## CocoaPods

pod 'XBSwiftCoreModule'

#### or 

pod 'XBSwiftCoreModule/XBCircleScroll'

#### or

pod 'XBSwiftCoreModule/XBMenuView'
#### or

pod 'XBSwiftCoreModule/XBListViewManager'

## 使用说明
#### circleScroll：  
```初始化方法```  
```public init(circleViewType: AnyClass? = UIImageView.self, isUseTimer: Bool = false, timerInterval: Int = 3, isShowPageControl: Bool = true, pageType: XBCirclePageControl.XBPageControlType = .multiple())```  
 ```cirview = XBCircleScrollView(circleViewType: UILabel.self, isUseTimer: true)```    
```cirview.delegate = self``` 
```cirview.pageControlRightOffSet = 30.0```  
```view.addSubview(cirview)``` 
```cirview.pageCount = 0``` 
```代理方法```    
```func XBCircleView(circleView: UIView, configureDataWithIndex index: Int)```  
```func XBCircleView(circleView: UIView, didSelectedAtIndex index: Int)```  
#### listmanager：   
```使用模型控制cell的展示，初始化模型的时候必须遵循协议```    
```struct XBMovieModel: XBDataModelProtocol```  
```struct XBMovieSecModel: XBSectionModelProtocol```  
```listmanger初始化```   
```// public init(flowLayout: UICollectionViewLayout? = nil, cellClass: String? = nil, emptyManager: XBListEmptyManagerProtocol? = nil)```   
```let v = XBCollectionManager(flowLayout: self.layout, emptyManager: XBListEmptyManager())```    
```v.delegate = self```    
#### menuview  
初始化   
  ```XBTopMenuView(titles: ["centerFlow","waterFlow", "leftFlow"], contentSizeType: .equalToSuper, buttonComponents: coms)```

## Demo演示

## 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


## 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
