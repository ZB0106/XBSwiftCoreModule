
#Pod::Spec.new do |spec|
Pod::Spec.new do |s|

  s.name         = "XBSwiftCoreModule"
  s.version      = "0.0.6"
  s.summary      = "develop components for swift, you can configure a listview or circleView with this components"
  s.homepage     = "https://github.com/ZB0106/XBSwiftCoreModule"
  s.author             = { "rzb16@sina.com" => "rzb16@sina.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/ZB0106/XBSwiftCoreModule", :tag => "#{s.version}" }
  s.source_files  = "XBSwiftCoreModule/Sources/XBListViewManager/*/*.swift","XBSwiftCoreModule/Sources/XBCircleScroll/*.swift","XBSwiftCoreModule/Sources/XBMenuView/*.swift","XBSwiftCoreModule/Sources/XBFoundationExtension/*.swift","XBSwiftCoreModule/Sources/XBUIKitExtension/*.swift","XBSwiftCoreModule/Sources/XBTools/*.swift"
  s.resources = "XBSwiftCoreModule/Sources/XBCircleScroll/*.bundle"
  s.requires_arc = true
  s.frameworks = 'UIKit', 'Foundation'
  #子部件
  s.subspec 'XBListViewManager' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBListViewManager/*/*.swift','XBSwiftCoreModule/Sources/XBListViewManager/*.swift'
  xb.frameworks = 'UIKit', 'Foundation'

  #依赖子库
#  xb.dependency 'CocoapodsStudy/ZB_Swift_Base'
  end
 s.subspec 'XBCircleScroll' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBCircleScroll/*/*.swift','XBSwiftCoreModule/Sources/XBCircleScroll/*.swift'
  xb.resources = "XBSwiftCoreModule/Sources/XBCircleScroll/*.bundle"
  xb.frameworks = 'UIKit', 'Foundation'
  xb.dependency 'XBSwiftCoreModule/XBTools'
  end
 s.subspec 'XBMenuView' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBMenuView/*/*.swift','XBSwiftCoreModule/Sources/XBMenuView/*.swift'
  xb.frameworks = 'UIKit', 'Foundation'

  end
s.subspec 'XBFoundationExtension' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBFoundationExtension/*/*.swift','XBSwiftCoreModule/Sources/XBFoundationExtension/*.swift'
  xb.frameworks = 'UIKit', 'Foundation'

  end
s.subspec 'XBUIKitExtension' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBUIKitExtension/*/*.swift','XBSwiftCoreModule/Sources/XBUIKitExtension/*.swift'
  xb.frameworks = 'UIKit', 'Foundation'

  end

  s.subspec 'XBTools' do |xb|
  xb.source_files = 'XBSwiftCoreModule/Sources/XBTools/*/*.swift','XBSwiftCoreModule/Sources/XBTools/*.swift'
  xb.frameworks = 'UIKit', 'Foundation'
  end

  s.swift_versions = ['5.1', '5.2', '5.3']
#由于需要依赖的三方库都是静态库,如果这里不指定本库为静态库,则cocoapods中默认会编译成动态库,而此动态库中依赖了静态库,会导致编译失败, 因此这里需要指定编译成静态库
  s.static_framework = true

end
