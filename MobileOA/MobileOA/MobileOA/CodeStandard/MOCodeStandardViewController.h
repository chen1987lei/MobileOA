//
//  MOCodeStandardViewController.h
//  MobileOA
//
//  Created by renqingyang on 2018/3/20.
//  Copyright © 2018年 renqingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#if 0

/*
 备注：这个类是演示使用的，里面标注“备注”的标示是演讲使用，除此之外都是Demo实例
 代码规范：
 1、用的舒服、看着舒服、养成习惯
 2、多用空格，多用回车（这个类里面的东西都是用了大量的空格和回车，大家仔细看看）
 3、命名规范，简单的用英文，复杂的用中文，长度要控制好，别太长了，别用太复杂的英文，免得再麻烦有道、词霸等工具
 4、多用已经定义好的公共方法
 5、尽量消灭警告，如果是第三方代码，原则上就别动了
 6、注意内存管理，做完工具跟一遍dealloc函数是否被执行
 7、XCODE使用通用的第三方控件，如何自动显示注释、自动对齐
 8、XCODE显示一行的字符，100字符，打开XCode的行数标示
 9、能用block、代理搞定的，就少用消息机制
 10、版本的API要考虑到兼容到最低版本，如果API有变动要增加版本控制，不要在低版本上Crash
 11、如果建立文件夹要先建立物理文件夹，然后拖入到工程里面，禁止在工程里面建立逻辑文件夹
 12、此项目中所有代码建议优先纯代码实现，Xib坑爹的地方太多了
 13、项目的图片资源，要定期使用工具压缩一下，并且清理一下将不用的图片删除掉
 14、基本类型，首先考虑使用NS框架的类型，不要用C类型
 15、创建Button时，注意button的点击有效区域，要尽量大一些；
 16、注意数据类型在可变和不可变之间的赋值，尽量避免直接赋值，会引起异常；
 */

/*
 工程级别：
 不同工程的前缀

 i开头表示iCore等基类工程
 MO开头表示OA工程
 */

/*
 备注：自定义枚举类型 前缀以‘MOE_’起头，后面用大家熟悉的驼峰法，便于区分
 这里注意要指定所声明枚举的“数据类型”，还有就是给枚举成员“添加注释”
 NS_ENUM与后面的左括号有一个空格
 起始枚举的数字要有指定的值，养成习惯
 */
typedef NS_ENUM (NSInteger, MOE_Demo)
{
    // 枚举demo1注释
    MOE_Demo_ = 0,

    // 枚举demo1注释
    MOE_Demo1,

    // 枚举demo2注释
    MOE_Demo2,
};


/*
 备注：代理类，放在上面引用，而实现放在下面
 */
@protocol MODemoDelegate;

@class MODemoModel;

/*
 备注：Router宏
 */
extern NSString *const kMORouterDemo;


// XXX的Block回调
typedef void (^MODemoBolck)(NSInteger param);

/*
 备注：注意空格
 */

/*!
 *  @author 任清阳, 2018-03-12  17:13:29
 *
 *  @brief  此文件的描述，本文件是iOS开发的演示文档，主要包括命名方式、代码规范、代理、通知等
 *
 *  @since  从哪个版本开始，比如1.0.1
 */

@interface MOCodeStandardVC : UIViewController

/*
 备注：注意空格，把nonatomic放在前面
 */
/*
 备注：外部变量属性，要注意使用哪个属性格式
 */
/*
 备注：不希望外部因非法操作更改了数组内容，用 只读属性 readonly
 */
/*
 备注：基本类型用 assign 属性，这个也都写上，格式上能保持一致
 */

// 变量的意义
@property (nonatomic, assign, readonly) NSInteger demo;

@property (nonatomic, assign, readonly) NSSArry *demo;

@property (nonatomic, assign, getter = isStaticMethod, readonly) BOOL staticMethod;

@property (nonatomic, copy, readonly) NSArray <NSString *> *stringArray;
@property (nonatomic, copy, readonly) NSDictionary <NSString *,NSString *> *queryParameters;

/*
 备注：代理用 weak 属性
 */

// 变量的意义
@property (nonatomic, weak) id<MODemoDelegate> delegate;

/*
 备注：代码块用 copy 属性
 */

// 变量的意义
@property (nonatomic, copy) MODemoBlock demoBlock;


/*
 备注：方法有两种，如果是基类里面对外暴露的方法，需要加MO_开头，如果是给子类使用，就正常使用即可
 */

// 子类要重写的方法
- (void)o_demo;

// 对外方法，以m*_开头（当然子类也可以用哈）
- (void)mo_demo;

@end

@protocol MODemoDelegate <NSObject>

- (void)d_method;

@end

#endif

@interface MOCodeStandardViewController : UIViewController

@end
