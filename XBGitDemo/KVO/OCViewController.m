//
//  OCViewController.m
//  XBWorkSumary
//
//  Created by 苹果兵 on 2020/10/31.
//

#import "OCViewController.h"

@interface TSModel : NSObject

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *age;
@property (nonatomic, copy, readwrite) NSString *sex;
@property (nonatomic, copy, readwrite) NSString *desc;

@end

@implementation TSModel
//第一种方式 name age sex 触发通知的时候desc也会触发通知，desc也必须是被监听的key。desc 也会先与他们触发通知
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
 
    //oc标签
fail: { }
    goto fail;
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"desc"]) {
        NSSet *afs = [NSSet setWithObjects:@"name",@"age", @"sex", nil];
        keyPaths = [keyPaths setByAddingObjectsFromSet:afs];
    }
    return keyPaths;
}
////第二种方式。name age sex 触发通知。desc 也会先与他们触发
//+ (NSSet<NSString *> *)keyPathsForValuesAffectingDesc {
//    return [NSSet setWithObjects:@"name",@"age", @"sex", nil];
//}
- (void)dealloc {
    NSLog(@"tsmodel  释放了");
}
@end

@interface OCViewController ()

@property (nonatomic, strong) TSModel *m;


@end


@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancel.frame = CGRectMake(280, 20, 30, 30);
    [self.view addSubview:cancel];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [bt addTarget:self action:@selector(func1) forControlEvents:UIControlEventTouchUpInside];
    bt.frame = CGRectMake(80, 80, 30, 30);
    [self.view addSubview:bt];
    
    UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [bt2 addTarget:self action:@selector(func2) forControlEvents:UIControlEventTouchUpInside];
    bt2.frame = CGRectMake(80, 120, 30, 30);
    [self.view addSubview:bt2];
    
    UIButton *bt3 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [bt3 addTarget:self action:@selector(func3) forControlEvents:UIControlEventTouchUpInside];
    bt3.frame = CGRectMake(80, 160, 30, 30);
    [self.view addSubview:bt3];
    
    
    self.m = [TSModel new];
    [self.m addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.m addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.m addObserver:self forKeyPath:@"sex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.m addObserver:self forKeyPath:@"desc" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    
}
- (void)dealloc {
    
    NSLog(@"ocVC  dealloc");
    
    
    
}
- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)func1 {
    self.m.name = @"ceshi";
}
- (void)func2 {
    self.m.age = @"20";
}

- (void)func3 {
    self.m.sex = @"women";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == nil) {
        
        NSLog(@"keypath==%@---value==%@",keyPath,change[NSKeyValueChangeNewKey]);
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
