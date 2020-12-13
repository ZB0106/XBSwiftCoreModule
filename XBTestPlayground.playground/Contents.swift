import UIKit

var str = "Hello, playground"

struct valueKey {
    static var key = "test"
    static var structKey = "strrewfs"
}

class XBStruct {
    var showTest: Bool = false
}

protocol XBTestProtocol {
//    func test() -> XBStruct
    var test: XBStruct { get }
    var showTest: Bool! { get set }
}
extension XBTestProtocol {
//    func test() -> XBStruct {
//        let str = XBStruct()
//        return str
//    }
    //如果遵循协议的是结构体，对象随时有可能被释放
    var test: XBStruct {

        var obj = objc_getAssociatedObject(self, &valueKey.key)
        if obj == nil {
            obj = XBStruct()
            objc_setAssociatedObject(self, &valueKey.key, obj, .OBJC_ASSOCIATION_ASSIGN)
        }
        return obj as! XBStruct
    }
    var showTest: Bool! {
        
        set { test.showTest = newValue }
        get { test.showTest }
        //会造成死循环
//        set { showTest = false }
//        get { showTest }
       
    }
}
struct XBShow: XBTestProtocol {
//    var test: XBStruct = XBStruct()
}

class XBSubShow: XBTestProtocol {
    var data: XBTestProtocol!
    var test: XBStruct = XBStruct()
}
var show = XBShow()
print(Unmanaged.passUnretained(show.test).toOpaque())
show.showTest = true
show.showTest
print(Unmanaged.passUnretained(show.test).toOpaque())
show.showTest = false
show.showTest
print(Unmanaged.passUnretained(show.test).toOpaque())
show.showTest = true
show.showTest
print(Unmanaged.passUnretained(show.test).toOpaque())

let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!+"tt.plist"

NSKeyedArchiver.archiveRootObject(["test"], toFile: path)

