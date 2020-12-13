//
//  KVOTestOjb.m
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/7.
//

#import "KVOTestOjb.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation KVOTestOjb

//CGRect rect = CGRectMake(0, 0, 0, 0);
//CGRect r2 = {{0,0},{0,0}};
struct ces {

    int ss;
    int tt;
} dd = {.tt = 2, .ss = 3};//声明了一个 dd的struct ces 变量

enum en {
    cc,
    ss
} n = cc;

+ (void)load {
   

    dd.tt = 1;
    struct ces c = {1};
    typedef enum en  en;
    enum en n = cc;
    en m = cc;
    typedef struct ces ces;
    
    ces cc = {1};
    [self XB_swizzleOldSel:@selector(addObserver:forKeyPath:options:context:) newSel:@selector(XB_addObserver:forKeyPath:options:context:)];
}

+ (void)XB_swizzleOldSel:(SEL)oldSel newSel:(SEL)newSel {
    Class cls = [self class];
    
    //不会报错但是好像没意义
    struct c1es {

        int ss;
        int tt;
    } dd2 = {.tt = 2, .ss = 3};//声明了一个 dd的struct ces 变量
    
    
    Method oldm = class_getInstanceMethod(cls, oldSel);
    Method newm = class_getInstanceMethod(cls, newSel);
    IMP new = method_getImplementation(newm);
    IMP old = method_getImplementation(oldm);
    
    if (class_addMethod(cls, oldSel, new, method_getTypeEncoding(newm))) {
        class_replaceMethod(cls, newSel, old, method_getTypeEncoding(oldm));
    } else {
        method_exchangeImplementations(oldm, newm);
    }
}
- (void)XB_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
    NSString *oldClassname = NSStringFromClass([self class]);
    //生成动态类名
    NSString *newClassName = [@"XBKvo_" stringByAppendingString:oldClassname];
    //动态创建一个新类
    Class newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    //注册类
    objc_registerClassPair(newClass);
    //动态修改对象
    object_setClass(self, newClass);
    //给子类添加set方法
    //oc方法 SEL IMP 其中 SEL是调用方法编号  IMP 是函数指针 指向调用的代码块 SEL 和IMP是成对出现的
    class_addMethod(newClass, @selector(setName:), (IMP)newSetName, "v@:@");////v@:@ 表示的 是 void self SEL newName 和 这个方法匹配 如果这儿传的是空串也没有问题
    //通知父类 属性改变了
    objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

void newSetName(id self, SEL _cmd, NSString *newName) {
    //获取父类
    struct objc_super xb_superClass = {self, class_getSuperclass([self class])};
    //给父类发消息
    
//    objc_msgSendSuper(&xb_superClass, _cmd, newName);
    //获取父类属性监听的方法名
    NSString *methodName = NSStringFromSelector(_cmd);
    //获取属性名称
    NSString *key = [self returnKey:methodName];
    //获取当前对象的观察者
    id ob = objc_getAssociatedObject(self, @"objc");
    //给观察者发送通知  告诉观察者这个属性已经发生改变
//    objc_msgSend(ob, @selector(observeValueForKeyPath: ofObject: change: context:),key,self,@{key:newName},nil);
}

- (NSString *)returnKey:(NSString *)methName {
    return  [[methName substringWithRange:NSMakeRange(3, methName.length-4)] localizedLowercaseString];
}
@end
