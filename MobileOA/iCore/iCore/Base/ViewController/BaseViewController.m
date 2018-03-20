//
//  BaseViewController.m
//  iCore
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "BaseViewController.h"

#import "Navigation.h"

@interface BaseViewController ()

// 是否已经被初始化
@property (nonatomic, assign, getter = isInitialized) BOOL initialized;
// 是否已经被销毁
@property (nonatomic, assign, getter = isDestroyed) BOOL destroyed;

// 是否支持手势返回 YES支持，NO不支持
@property (nonatomic, assign, getter = isSupportBackGesture) BOOL supportBackGesture;

@end

@implementation BaseViewController

#pragma mark - ******************************LifeCycle Method***************************************

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 默认支持手势返回
    self.navigationController.supportBackGesture = _supportBackGesture;
    
    //
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 初始化
    [self initialize];
    
    // 加载网络
    [self i_loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

// 设置布局代码建议在此处完成，此方法会在needlayout中调用
- (void)updateViewConstraints
{
    [super updateViewConstraints];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithConfigDic:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithConfigDic:nil];
}

- (instancetype)initWithConfigDic:(NSDictionary *)configDic
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        _supportBackGesture = YES; // 默认支持手势

        [self i_initFields];
    }

    return self;
}
- (void)dealloc
{
    kLog_Dealloc_Info;
    
    [self unload];
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

- (void)initialize
{
    if (self.initialized)
    {
        return;
    }
    
    self.initialized = YES;
    self.destroyed = NO;
    
#ifdef DEBUG // debug模式下，就是crash
    [self i_createViews];
    [self i_createEvents];
#else
    @try
    {
        [self i_createViews];
        [self i_createEvents];
    }
    @catch (NSException *exception)
    {
        kLog_Print(@"(((((( %@ initialize ))))))\n %@", NSStringFromClass([self class]), exception);
    }
#endif
}

- (void)unload
{
    if (self.destroyed)
    {
        return;
    }
    
    self.destroyed = YES;
    self.initialized = NO;
    
#ifdef DEBUG // debug模式下，就是crash
    [self i_unload];
    
    [self i_cancelLoadData];
    [self i_destroyEvents];
    [self i_destroyViews];
    [self i_uninitFields];
#else
    @try
    {
        [self i_unload];
        
        [self i_cancelLoadData];
        [self i_destroyEvents];
        [self i_destroyViews];
        [self i_uninitFields];
    }
    @catch (NSException *exception)
    {
        kLog_Print(@"(((((( %@ unload ))))))\n %@", NSStringFromClass([self class]), exception);
    }
#endif
}

#pragma mark - ******************************Public Method******************************************

#pragma mark - push界面

- (void)i_pushVC:(UIViewController *)aVC
{
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - pop界面

- (void)i_popVC
{
    [self i_popVCWithAnimated:YES];
}

- (void)i_popVCToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)i_popVCWithAnimated:(BOOL)aAnimated
{
    [self.navigationController popViewControllerAnimated:aAnimated];
}

- (void)i_popToVC:(UIViewController *)aVC
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[aVC class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

#pragma mark - 设置是否支持手势返回

- (void)i_setSupportBackGesture:(BOOL)supportBackGesture
{
    self.navigationController.supportBackGesture = supportBackGesture;
    self.supportBackGesture = supportBackGesture;
}

#pragma mark - 结束编辑状态：收起键盘

- (void)i_endEditing
{
    [self.view endEditing:YES];
}

- (void)i_endAllParentsEditing
{
    [self.view endEditing:YES];
    
    if (self.parentViewController
        && [self.parentViewController isKindOfClass:[self class]])
    {
        [(BaseViewController *) self.parentViewController i_endAllParentsEditing];
    }
}

#pragma mark - ******************************Override Method****************************************

- (void)i_initFields
{
}

- (void)i_uninitFields
{
}

- (void)i_createViews
{
}

- (void)i_destroyViews
{
}

- (void)i_createEvents
{
}

- (void)i_destroyEvents
{
}

- (void)i_loadData
{
}

- (void)i_cancelLoadData
{
}

- (void)i_unload
{
    // 供子类复写，处理unload时需要的操作
}

#pragma mark - 此方法会被系统回调，设置当前StatusBar的Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    /// UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    /// UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
    return _statusBarStyle;
}

#pragma mark - 处理影响引用计数的功能

- (void)i_releaseReferenceCount
{
    // 由需要的子类实现此方法，释放影响VC引用计数的地方，比如：定时器
}

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;

    /// 操作增加一个动画效果
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                     }];
}

#pragma mark - ******************************类方法  ************************************************

// 初始化类方法
+ (instancetype)initWithConfigDic:(NSDictionary *)configDic
{
    return [[self alloc] initWithConfigDic:configDic];
}
@end
