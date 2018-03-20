//
//  BaseRequest.m
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/13.

//

#import "BaseRequest.h"

#import "HttpConnection.h"
#import "NetWorkManager.h"

// 请求超时时间
static NSTimeInterval requestTimeoutInterval  = 30.0;

@implementation BaseRequest

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
    [self i_cancleRequest];
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

#pragma mark - ******************************Public Method******************************************

// 开始请求
- (void)i_startRequest
{
    [[NetWorkManager shared] i_addRequest:self];
}

// 设置请求block回调
- (void)i_startWithSuccess:(NetWorkSuccessBlock)successBlock
                    failure:(NetWorkFailureBlock)failureBlock
{
    self.netWorkSuccessBlock = successBlock;
    self.netWorkFailureBlock = failureBlock;

    [self i_startRequest];
}

// 取消请求
- (void)i_cancleRequest
{
    [[NetWorkManager shared] i_cancleRequest:self];
}

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

- (NSTimeInterval)timeoutInterval
{
    return requestTimeoutInterval;
}

- (NSInteger)responseStatusCode
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.connection.task.response;
    return response.statusCode;
}

- (NSDictionary *)responseHeaderFieldValueDictionary
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.connection.task.response;
    return response.allHeaderFields;
}

@end
