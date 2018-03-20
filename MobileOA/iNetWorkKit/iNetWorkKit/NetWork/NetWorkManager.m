//
//  NetWorkManager.m
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/14.

//

#import "NetWorkManager.h"

#import "HttpConnection.h"

#import "AFNetworking.h"

#import <objc/runtime.h>

// requestResponseModelKey
static const char kBaseRequestResponseModelKey;

// requestErrorKey;
static const char kBaseRequestErrorKey;

@implementation BaseRequest (NetworkManager)

// getter
- (id)responseObject
{
    return objc_getAssociatedObject(self, &kBaseRequestResponseModelKey);
}

- (NSError *)error
{
    return objc_getAssociatedObject(self, &kBaseRequestErrorKey);
}

// setter
- (void)setResponseObject:(id)responseObject
{
    objc_setAssociatedObject(self, &kBaseRequestResponseModelKey, responseObject, OBJC_ASSOCIATION_RETAIN);
}

- (void)setError:(NSError *)error
{
    objc_setAssociatedObject(self, &kBaseRequestErrorKey, error, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation NetWorkManager

kSingleton_m(NetWorkManager)

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
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

// 处理请求连接
- (void)processConnection:(HttpConnection *)connection
   withResponseJsonObject:(id)responseJsonObject
{
    BaseRequest *request = connection.request;
    request.responseObject = responseJsonObject;
    [self callBackRequestSuccess:request];
}

// 处理错误连接
- (void)processConnection:(HttpConnection *)connection withError:(NSError *)error
{
    BaseRequest *request = connection.request;
    request.error = error;
    [self callBackRequestFailure:request];
}

// 响应成功回调
- (void)callBackRequestSuccess:(BaseRequest *)request
{
    // 回调block
    if (request.netWorkSuccessBlock)
    {
        // 成功默认回调
        [self defaultMethodRequestSuccessWithRequest:request];
        
        request.netWorkSuccessBlock(request,request.responseObject);
    }
    
    // 回调delegate
    if (request.delegate && [request.delegate respondsToSelector:@selector(i_requestSuccess:)])
    {
        [request.delegate i_requestSuccess:request];
    }
    
    // 清除block
    [self clearRequestBlock:request];
}

// 响应失败回调
- (void)callBackRequestFailure:(BaseRequest *)request
{
    // 回调block
    if (request.netWorkFailureBlock)
    {
        // 失败默认回调
        [self defaultMethodRequestFaulureWithRequest:request];
        request.netWorkFailureBlock(request,request.error);
    }
    
    // 回调delegate
    if ([request.delegate respondsToSelector:@selector(i_requestFailed:)])
    {
        [request.delegate i_requestFailed:request];
    }
    
    // 清除block
    [self clearRequestBlock:request];
}

- (void)clearRequestBlock:(BaseRequest *)request
{
    request.netWorkSuccessBlock = nil;
    request.netWorkFailureBlock = nil;
}

// 底层默认成功回调，用来做些统计等基础操作
- (void)defaultMethodRequestSuccessWithRequest:(BaseRequest *)request
{
    NSLog(@"request -------%@请求成功",request.url.absoluteString);
}

// 底层默认失败回调，用来做些统计等基础操作
- (void)defaultMethodRequestFaulureWithRequest:(BaseRequest *)request
{
    NSLog(@"request -------%@请求失败",request.url.absoluteString);
}
#pragma mark - ******************************Public Method******************************************

- (void)i_addRequest:(BaseRequest *)request
{
    __weak typeof(self) weakSelf = self;
    
    HttpConnection *connection = [HttpConnection new];
    
    [connection i_connectWithRequest:request success:^(HttpConnection *connection, id responseJsonObject)
    {
        [weakSelf processConnection:connection withResponseJsonObject:responseJsonObject];
    }
                           failure:^(HttpConnection *connection, NSError *error){
        [weakSelf processConnection:connection withError:error];
    }];
}

// 取消请求
- (void)i_cancleRequest:(BaseRequest *)request
{
    [request.connection.task cancel];

    // 清除block
    [self clearRequestBlock:request];
}

// 取消所有网络请求
- (void)i_cancleAllRequest
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];

    // 停止所有操作
    [manager.operationQueue  cancelAllOperations];

    // 取消所有任务
    [manager.tasks  makeObjectsPerformSelector:@selector(cancel)];
    // 不要关闭session session一旦关闭，就不会发请求了
//    [manager invalidateSessionCancelingTasks:YES];
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

#pragma mark - ******************************类方法**************************************************

@end
