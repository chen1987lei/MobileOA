//
//  BaseRequest+HttpStub.m
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/18.

//

#import "BaseRequest+HttpStub.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import <libkern/OSAtomic.h>

#import <objc/runtime.h>

/// 是否开启模拟
static char const *const kIsNeedRequestStub = "kIsNeedRequestStub";
/// 模拟请求文件名称
static char const *const kStubFileName = "kStubFileName";
/// 网络速度
static char const *const kStubNetworkSpeed = "kStubNetworkSpeed";
/// 返回结果
static char const *const kStubRequestResult = "kStubRequestResult";

static NSMutableDictionary *_stubsDic = nil;

@implementation BaseRequest (HttpStub)

#pragma mark - ******************************Private Method*****************************************
/// 添加网络请求模拟对象
- (void)addRequestStub
{
    if (self.stubFileName.length == 0)
    {
        return;
    }

    // 保证只创建一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stubsDic = [NSMutableDictionary dictionary];
    });

    // 添加线程安全
    @synchronized(_stubsDic)
    {
        id<OHHTTPStubsDescriptor> requestStub = [_stubsDic objectForKey:self.stubFileName];
        
        if (requestStub != nil)
        {
            return;
        }

        CGFloat networkSpeedDuration = [self getRequestTimeByNetworkSpeed:self.stubNetworkSpeed];

        int httpCode = [self getHttpCodeByStubResult:self.stubRequestResult];

        NSError *error = nil;

        // 生成模拟对象，此方法有两个block，第一个block是返回请求是否被模拟，第二个返回接口的模拟响应
        requestStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return self.isNeedRequestStub;
        }
                                          withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {

                                             NSString *OHPath = [[NSBundle mainBundle] pathForResource:[self.stubFileName stringByDeletingPathExtension]
                                                                                                ofType:[self.stubFileName pathExtension]];

                                              OHHTTPStubsResponse *stubResponse = [OHHTTPStubsResponse responseWithFileAtPath:OHPath
                                                                                                                   statusCode:httpCode
                                                                                                                      headers:@{@"Content-Type":@"text/json"}];
                                              stubResponse.error = error;
                                              return [stubResponse requestTime:networkSpeedDuration
                                                                  responseTime:OHHTTPStubsDownloadSpeedWifi];
                                          }];

        requestStub.name = self.stubFileName;

        [_stubsDic setObject:requestStub forKey:self.stubFileName];
    }
}

/// 移除网络请求模拟对象
- (void)removeRequestStub
{
    if (self.stubFileName.length == 0)
    {
        return;
    }

    // 保证只创建一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stubsDic = [NSMutableDictionary dictionary];
    });

    // 添加线程安全
    @synchronized(_stubsDic)
    {
        id<OHHTTPStubsDescriptor> requestStub = [_stubsDic objectForKey:self.stubFileName];

        if (requestStub != nil)
        {
            [OHHTTPStubs removeStub:requestStub];

            [_stubsDic removeObjectForKey:self.stubFileName];
        }
    }
}

#pragma mark - 把模拟网速转换为请求时间

- (CGFloat)getRequestTimeByNetworkSpeed:(E_StubNetworkSpeed)stubNetworkSpeed
{
    switch (stubNetworkSpeed)
    {
        case E_StubNetworkSpeed_High:
            return 0.15;

        case E_StubNetworkSpeed_Middle:
            return 2;

        case E_StubNetworkSpeed_Low:
            return 7;

        default:
            return 0.15;

    }
}

/// 把模拟请求结果转换为http code
- (int)getHttpCodeByStubResult:(E_StubRequestResult)stubRequestResult
{
    switch (stubRequestResult)
    {
        case E_StubRequestResult_Success:
            return 200;

            /// 简化处理，把服务端错误统一为404，如果需要细化 以后优化
        case E_StubRequestResult_FailedByServer:
            return 404;

        case E_StubRequestResult_FailedByNetwork:
            return -1;

        default:
            return 0;
    }
}

#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

#pragma mark - Getters

- (BOOL)isNeedRequestStub
{
    // 只在debug版本开启，release版本即使设置了也无效
#ifdef DEBUG
    NSNumber *needRequestStub = objc_getAssociatedObject(self, kIsNeedRequestStub);

    return [needRequestStub boolValue];
#else
    return NO;
#endif
}

- (NSString *)stubFileName
{
    return objc_getAssociatedObject(self, kStubFileName);
}

- (E_StubNetworkSpeed)stubNetworkSpeed
{
    NSNumber *stubNetworkSpeed = objc_getAssociatedObject(self, kStubNetworkSpeed);

    return [stubNetworkSpeed integerValue];
}

- (E_StubRequestResult)stubRequestResult
{
    NSNumber *stubRequestResult = objc_getAssociatedObject(self, kStubRequestResult);

    return [stubRequestResult integerValue];
}

#pragma mark - Setters

- (void)setIsNeedRequestStub:(BOOL)isNeedRequestStub
{
#ifdef DEBUG

    NSNumber *isNeedRequestStubNumber = [NSNumber numberWithBool:isNeedRequestStub];

    objc_setAssociatedObject(self, kIsNeedRequestStub, isNeedRequestStubNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (isNeedRequestStub)
    {
        [self addRequestStub];
    }
    else
    {
        [self removeRequestStub];
    }
    
#endif
}

- (void)setStubFileName:(NSString *)stubFileName
{
    objc_setAssociatedObject(self, kStubFileName, stubFileName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setStubNetworkSpeed:(E_StubNetworkSpeed)stubNetworkSpeed
{
    NSNumber *stubNetworkSpeedNumber = [NSNumber numberWithInteger:stubNetworkSpeed];

    objc_setAssociatedObject(self, kStubNetworkSpeed, stubNetworkSpeedNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setStubRequestResult:(E_StubRequestResult)stubRequestResult
{
    NSNumber *stubRequestResultNumber = [NSNumber numberWithInteger:stubRequestResult];

    objc_setAssociatedObject(self, kStubRequestResult, stubRequestResultNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
