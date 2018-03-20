//
//  MOCodeStandardViewController.m
//  MobileOA
//
//  Created by renqingyang on 2018/3/20.
//  Copyright © 2018年 renqingyang. All rights reserved.
//

#import "MOCodeStandardViewController.h"

#if 0

/*
 备注：引用的头文件，尽量放到.m文件里面引入，上面是系统头文件，下面工程头文件，也可以按照 M、V、P 形式继续细分
 */
#import <AddressBook/AddressBook.h>

/*
 备注：宏定义，kMO_起始，表示宏，后面的字符用驼峰法，便于识别，并且要加入本模块名称，尽量避免与其他模块有命名冲突
 */
/*
 备注：控件的tag值，用当前时间（年月日时分）表示
 */
/*
 备注：后面的定义内容记得使用‘（）’，避免不必要的错误，养成习惯
 */

// view的tag
#define kMOCodeStandard_AlertView_Tag (1403241642)

// Demo通知
#define kMOCodeStandard_Demo_Notification @"kMOCodeStandard_Demo_Notification"


/*
 备注：Delegate要一个一行，<和>符号要单独一行，并且经历区分系统和自定义代理
 */
@interface MOCodeStandardVC : UIViewController
<
UIAlertViewDelegate
>
{
    /*
     备注：类实例变量用_开头
     */
    /*
     备注：*号与变量挨着
     */
    /*
     备注：命名使用驼峰法，以10个字母以内最佳，但要保证语义明确，特殊情况特殊处理
     */

    NSObject *_objectDemo;
}

/*
 备注：属性变量使用方式：由于每个同学使用属性使用习惯不同，所以使用.方法时最靠谱的
 .方法调用：调用set/get方法
 _方法调用：直接访问内存，效率高，但是不走set/get方法
 属性都不用实现属性 @synthesize
 */
// 变量要有注释
@property (nonatomic, strong) UIButton *demoBtn;

@end


@implementation MOCodeStandardVC

// 子类使用方法demo
- (void)o_demo
{
}

// 对外方法demo（当前子类也可以用哈）
- (void)mo_demo
{
}

@end

#endif

@interface MOCodeStandardViewController ()

@end

@implementation MOCodeStandardViewController

#pragma mark - ******************************LifeCycle Method***************************************

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - ******************************Public Method******************************************

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

@end
