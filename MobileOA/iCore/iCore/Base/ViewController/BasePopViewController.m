//
//  BasePopViewController.m
//  iCore 
//
//  Created by renqingyang on 2017/11/16.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "BasePopViewController.h"

// 默认动画时间
static NSTimeInterval defaultAnimationDuration  = 0.3;

@interface BasePopViewController ()
{
    BOOL _animationing;
}

// 当前PopVC的显示状态
@property (nonatomic, assign, getter = isShow,  readwrite) BOOL show;

// 动画类型
@property (nonatomic, assign) E_PopAnimationType animationType;

// 相应手势的View
@property (nonatomic, strong) UIView *tapGestureView;

// subCustomView
@property (nonatomic, weak) UIView *customView;

// 容器window
@property (nonatomic, strong) UIWindow* window;
// 容器VC
@property (nonatomic, strong) UIViewController *container;

@end

@implementation BasePopViewController

#pragma mark - ******************************LifeCycle Method***************************************

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.container = [UIViewController new];
    self.container.view.backgroundColor = [UIColor clearColor];

    self.window.rootViewController = self.container;
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.popBackGroundColor = [UIColor colorWithWhite:.0 alpha:0.5];
    }
    
    return self;
}

- (void)dealloc
{

}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - 单击手势

- (void)tapGestureTouchSingle:(UITapGestureRecognizer *)aTapGesture
{
    if (!_supportHiddenGesture)
    {
        if (self.popHiddenBlock != nil)
        {
            self.popHiddenBlock();
        }
        else
        {
        }
        // 隐藏pop
        [self i_showPop:NO];
    }
}

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

#pragma mark - 隐藏和显示 PopViewVC

// 隐藏PopView
- (void)hidePop
{
    if (_animationing)
    {
        return;
    }

    self.view.backgroundColor = self.popBackGroundColor;

    _animationing = YES;

    // 在iOS9 中，如果进行animateWithDuration 时，view被release 那么会引起crash。使用另外一个动画方法替换
    [UIView animateWithDuration:defaultAnimationDuration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithWhite:.0 alpha:0];
                         self.window.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {

                         _animationing = NO;
                         // 移除VC
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];

                         // 消失时，动画之后 执行回调
                         if (_popStatusChangeBlock)
                         {
                             _popStatusChangeBlock(NO);
                         }
                     }];

    // SubVC的view动画效果
    [self showCustomView:NO];
}

// 显示PopView
- (void)showPop
{
    if (_animationing)
    {
        return;
    }

    // 显示VC
    [self.container addChildViewController:self];
    [self.view setFrame:self.container.view.bounds];
    [self.container.view addSubview:self.view];
    [self didMoveToParentViewController:self.container];

    _animationing = YES;

    self.view.backgroundColor = [UIColor colorWithWhite:.0 alpha:0];
    self.window.alpha = 0.0;

    [UIView animateWithDuration:defaultAnimationDuration
                     animations:^{
                         self.view.backgroundColor = self.popBackGroundColor;
                         self.window.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {

                         _animationing = NO;

                         // 避免viewTapGesture覆盖其他View之上，导致点击任何View都有点击效果，此处做一个置底操作
                         [self.view sendSubviewToBack:self.tapGestureView];

                         // 显示时，动画之前 执行回调
                         if (_popStatusChangeBlock)
                         {
                             _popStatusChangeBlock(YES);
                         }
                     }];

    // SubVC的view动画效果
    [self showCustomView:YES];
}

#pragma mark - 显示/隐藏 CustomView

- (void)showCustomView:(BOOL)isShow
{
    // 区分不同特效
    switch (_animationType)
    {
        case E_PopAnimationType_Default: // 默认效果，透明度从0到1
        {
            [self showCustomView_Default:isShow];
        }
            break;

        case E_PopAnimationType_UpToBottom: // 从上往下
        {
            [self showCustomView_UpToBottom:isShow];
        }
            break;

        case E_PopAnimationType_BottomToUp: // 从下往上
        {
            [self showCustomView_BottomToUp:isShow];
        }
            break;
    }
}

#pragma mark - 显示/隐藏 CustomView Default

- (void)showCustomView_Default:(BOOL)isShow
{
    if (isShow) // 显示
    {
        // 动画之前
        _customView.alpha = 0.0;

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.alpha = 1.0; // 显示View
                         }
                         completion:^(BOOL finished) {

                         }];
    }
    // 隐藏
    else
    {
        // 动画之前
        _customView.alpha = 1.0; // 显示View

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             // 动画之后 复位操作，给下一次动画做准备
                             _customView.alpha = 1.0;
                         }];
    }
}

#pragma mark - 显示/隐藏 CustomView UpToBottom

- (void)showCustomView_UpToBottom:(BOOL)isShow
{
    // SubVCView的原始位置
    CGFloat customViewOriginY = _customView.originY;

    if (isShow) // 显示
    {
        // 动画之前
        // frame，在屏幕下方不可见
        _customView.originY = -(_customView.originY + _customView.height);

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.originY = customViewOriginY;
                         }
                         completion:^(BOOL finished) {

                         }];
    }
    else // 隐藏
    {
        // 动画之前

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.originY = -(_customView.originY + _customView.height);
                         }
                         completion:^(BOOL finished) {

                             // 动画之后 复位操作，给下一次动画做准备
                             _customView.originY = customViewOriginY;
                         }];
    }
}

#pragma mark - 显示/隐藏 CustomView BottomToUp

- (void)showCustomView_BottomToUp:(BOOL)isShow
{
    // SubVCView的原始位置
    CGFloat customViewOriginY = _customView.originY;

    if (isShow) // 显示
    {
        // 动画之前
        // frame，在屏幕下方不可见
        _customView.originY = self.view.height;

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.originY = customViewOriginY;
                         }
                         completion:^(BOOL finished) {

                         }];
    }
    else // 隐藏
    {
        // 动画之前

        [UIView animateWithDuration:defaultAnimationDuration
                         animations:^{
                             // 动画之后
                             _customView.originY = self.view.height;
                         }
                         completion:^(BOOL finished) {
                             // 动画之后 复位操作，给下一次动画做准备
                             _customView.originY = customViewOriginY;
                         }];
    }
}

#pragma mark - ******************************Public Method******************************************

- (void)i_setCustomView:(UIView *)view animation:(E_PopAnimationType)animationType
{
    self.customView = view;
    self.animationType = animationType;
}

/// 显示/隐藏 PopVC
- (void)i_showPop:(BOOL)isShow
{
    if (isShow)
    {
        [self showPop];
    }
    else
    {
        [self hidePop];
    }
}
#pragma mark - ******************************Override Method****************************************

- (void)i_initFields
{
    [super i_initFields];

    // 默认从上到下动画
    _animationType = E_PopAnimationType_BottomToUp;
}

- (void)i_uninitFields
{
    [super i_uninitFields];
}

- (void)i_createViews
{
    [super i_createViews];

    [self.view addSubview:self.tapGestureView];
}

- (void)i_destroyViews
{
    [super i_destroyViews];
}

- (void)i_createEvents
{
    [super i_createEvents];
}

- (void)i_destroyEvents
{
    [super i_destroyEvents];
}

- (void)i_loadData
{
    [super i_loadData];
}

- (void)i_cancelLoadData
{
    [super i_cancelLoadData];
}

- (void)i_unload
{
    
}

#pragma mark - 处理影响引用计数的功能

- (void)i_releaseReferenceCount
{
    
}

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

- (UIView *)tapGestureView
{
    if (!_tapGestureView)
    {
        _tapGestureView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tapGestureView.backgroundColor = [UIColor clearColor];

        //  添加单击手势
        UITapGestureRecognizer *tapGestureSingle = [[UITapGestureRecognizer alloc] init];

        [tapGestureSingle addTarget:self action:@selector(tapGestureTouchSingle:)];
        [_tapGestureView addGestureRecognizer:tapGestureSingle];
    }

    return _tapGestureView;
}

- (UIWindow *)window
{
    if (!_window)
    {
        ///初始化一个Window， 做到对业务视图无干扰。
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

        ///设置为最顶层，防止 AlertView 等弹窗的覆盖
        _window.windowLevel = UIWindowLevelStatusBar + 1;

        ///默认为YES，当你设置为NO时，这个Window就会显示了
        _window.hidden = NO;

        _window.alpha  = 0.0;
    }

    return _window;
}
@end
