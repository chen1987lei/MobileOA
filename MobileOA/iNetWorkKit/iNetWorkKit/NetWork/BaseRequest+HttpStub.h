//
//  BaseRequest+HttpStub.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/18.

//

#import <iNetWorkKit/iNetWorkKit.h>

// 模拟网速
typedef NS_ENUM(NSInteger, E_StubNetworkSpeed)
{
    // 模拟高速网络 150毫秒返回网络请求结果
    E_StubNetworkSpeed_High = 0,
    // 模拟中速网络 2秒返回网络请求结果
    E_StubNetworkSpeed_Middle,
    // 模拟低速网络 7秒返回网络请求结果
    E_StubNetworkSpeed_Low,
};

// 模拟请求结果
typedef NS_ENUM(NSInteger, E_StubRequestResult)
{
    // 模拟请求成功
    E_StubRequestResult_Success = 0,
    // 模拟服务器错误
    E_StubRequestResult_FailedByServer,
    // 模拟网络异常
    E_StubRequestResult_FailedByNetwork
};

/* 这个类别用Stub方式模拟网络请求，模拟的原理是：NSURLProtocol能够让你去重新定义苹果的URL加载系统
 (URL Loading System)的行为，URL Loading System里有许多类用于处理URL请求，比如NSURL，NSURLRequest，
 NSURLConnection和NSURLSession等，当URL Loading System使用NSURLRequest去获取资源的时候，它会创建一个
 NSURLProtocol子类的实例。不管你是通过UIWebView, NSURLConnection 或者第三方库 (AFNetworking,
 MKNetworkKit等)，他们都是基于NSURLConnection或者 NSURLSession实现的，因此你可以通过NSURLProtocol做自定义的
 操作。

 重定向网络请求
 忽略网络请求，使用本地缓存
 自定义网络请求的返回结果
 一些全局的网络请求设置
 */

/*!
 *  @author 任清阳, 2017-11-18  15:16:29
 *
 *  @brief  模拟网络请求扩展
 *
 *  @since  1.0
 */
@interface BaseRequest (HttpStub)

/// 是否模拟请求
@property (nonatomic, assign) BOOL isNeedRequestStub;
/// 模拟请求文件名称
@property (nonatomic, copy) NSString *stubFileName ;
/// 模拟网络的速度
@property (nonatomic, assign) E_StubNetworkSpeed stubNetworkSpeed;
/// 模拟网络请求返回状态
@property (nonatomic, assign) E_StubRequestResult stubRequestResult;

@end
