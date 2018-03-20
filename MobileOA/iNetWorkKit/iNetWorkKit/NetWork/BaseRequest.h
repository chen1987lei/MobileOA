//
//  BaseRequest.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/13.

//

#import <Foundation/Foundation.h>

#import "Macro_NetWorkEnum.h"

@class BaseRequest;

@protocol RequestDelegate;

#pragma mark - callBack

// 成功block
typedef void (^NetWorkSuccessBlock)(BaseRequest *request, id responseObject);
// 失败block
typedef void (^NetWorkFailureBlock)(BaseRequest *request, NSError *error);

/*!
 *  @author 任清阳, 2017-11-14  10:08:20
 *
 *  @brief  基础网络请求类
 *
 *  @since  1.0
 */

@interface BaseRequest : NSObject

@property (nonatomic, assign) E_RequestMethodType requestMethodType;

#pragma mark - request param

//基本地址
@property (nonatomic, copy) NSString *baseUrlString;

// requestUrl
@property (nonatomic, copy) NSString *requestUrlString;

// 最终请求时传的Url，根据baseUrl的有无来生成
@property (nonatomic, copy, readonly) NSURL *url;

// 请求参数字典
@property (nonatomic, strong) id requestArgument;

// 上传文件数组
@property (nonatomic, strong) NSArray *uploadDataArray;

// 向请求头中添加的附加信息
@property (nonatomic, copy) NSDictionary *requestHeaderFieldValueDictionary;

// 请求序列化类型
@property (nonatomic, assign) E_RequestSerializerType requestSerializerType;

// 请求超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

#pragma mark - response param

// 响应序列化类型
@property (nonatomic, assign) E_ResponseSerializerType responseSerializerType;

// 响应状态码，如403
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

// 响应头
@property (nonatomic, copy, readonly) NSDictionary *responseHeaderFieldValueDictionary;

#pragma mark - callback param

// 返回成功回调
@property (nonatomic, copy) NetWorkSuccessBlock netWorkSuccessBlock;

// 返回失败回调
@property (nonatomic, copy) NetWorkFailureBlock netWorkFailureBlock;

// 代理
@property (nonatomic, weak) id<RequestDelegate> delegate;

#pragma mark - public mthod

// 开始请求
- (void)i_startRequest;

// 设置请求block回调
- (void)i_startWithSuccess:(NetWorkSuccessBlock)successBlock
                    failure:(NetWorkFailureBlock)failureBlock;

// 取消请求
- (void)i_cancleRequest;

@end

#pragma mark - RequestDelegate

@protocol RequestDelegate <NSObject>

@optional

- (void)i_requestSuccess:(BaseRequest *)request;
- (void)i_requestFailed:(BaseRequest *)request;

@end
