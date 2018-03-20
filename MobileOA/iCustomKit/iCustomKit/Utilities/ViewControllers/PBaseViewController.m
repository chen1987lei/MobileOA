//
//  PBaseViewController.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PBaseViewController.h"

#import "PBaseViewController+PToast.h"

@interface PBaseViewController ()

@end

@implementation PBaseViewController

#pragma mark - ******************************LifeCycle Method***************************************

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kColor_RGB(0xFFFFFF);
    
    [self setupNavigationBar];
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
    [self i_showToastWithErrMessage:@"内存警告\n方便的话去群里面说一下这事"];
}

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)initWithConfigDic:(NSDictionary *)configDic
{
    self = [super initWithConfigDic:configDic];
    
    if (self)
    {
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    return self;
}

- (void)dealloc
{
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

- (void)setupNavigationBar
{
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        
        __weak typeof(self) weakSelf = self;

        [self i_setNavigationBarLeftBarButtonsWithElements:@[[UIImage imageNamed:PkCustomKitBundlePath(@"i_nav_back_arrow_btn")]]
                                  leftBarButtonClickedBlock:^(NSInteger barButtonIndex)
        {
            if (barButtonIndex == 0)
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - ******************************Public Method******************************************

#pragma mark - ******************************Override Method****************************************

- (void)i_initFields
{
    [super i_initFields];
}

- (void)i_uninitFields
{
    [super i_uninitFields];
}

- (void)i_createViews
{
    [super i_createViews];
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
    
    // 取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
