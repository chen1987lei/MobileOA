//
//  PBaseResource.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PBaseResource.h"

#import "PNetWorkHttpStubConfig.h"
#import "PNetResourecManager.h"

typedef NS_ENUM(NSInteger, PE_ResourceStatus)
{
    // 0000
    PE_ResourceStatus_NotProcessed = 0,

    // 0010
    PE_ResourceStatus_Processing = 1 << 1,

    // 0100
    PE_ResourceStatus_Processed = 1 << 2,

    // 0110
    PE_ResourceStatus_Cache = 6,
}; // & 2是处理中

NSString * const kResourceLoadingStatusKeyPath = @"loadingStatus";

NSString * const kResourceErrorDomain = @"com.ren.resource.request.error.response";

@interface PBaseResource ()

@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) BaseRequest *request;

@property (nonatomic, assign) PE_ResourceStatus loadingStatus;

// 服务返回的第一层code
@property (nonatomic, assign) E_ServerCodeStatus codeStatus;

@end


@implementation PBaseResource

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)url path:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.request.baseUrlString = url;
        self.request.requestUrlString = path;

        self.codeStatus = kModel_IntType_Max_Number;

        self.loadingStatus = PE_ResourceStatus_NotProcessed;
    }

    return self;
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.request.requestUrlString = path;

        self.codeStatus = kModel_IntType_Max_Number;

        self.loadingStatus = PE_ResourceStatus_NotProcessed;
    }

    return self;
}

- (instancetype)initWithValues:(id)values
{
    self = [super init];
    if (self)
    {
        [self i_getModelObjectWithDictJson:values];

        self.loadingStatus = PE_ResourceStatus_Processed;
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

// 加载成功回调
- (void)loadedResponseObject:(id)responseObject
{
    if (responseObject && [responseObject isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)responseObject;

        [self loadFailWithError:error];

        return;
    }
    if (responseObject && ![responseObject isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

        [userInfo setValue:@"服务端返回不是正确的json" forKey:NSLocalizedFailureReasonErrorKey];

        NSError *error = [[NSError alloc] initWithDomain:kResourceErrorDomain code:PE_NetErrorCode_RetNotValid userInfo:userInfo];

        [self loadFailWithError:error];

        return;
    }

    NSArray *allKeys = (NSArray *)[responseObject allKeys];

    // 服务端操作是否成功
    if ([allKeys containsObject:@"code"])
    {
        id code = responseObject[@"code"];
        id showMsg = responseObject[@"showMsg"];
        id value = [responseObject objectForKey:@"data"];

        if (self.codeStatus == E_ServerCodeSuccess)
        {
            if (!kObject_Is_Null(value))
            {
                [self i_getModelObjectWithDictJson:value];
            }
            self.loadingStatus = PE_ResourceStatus_Processed;
        }
        else
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

            if (showMsg)
            {
                [userInfo setValue:[NSString stringWithFormat:@"%@", showMsg] forKey:NSLocalizedFailureReasonErrorKey];
            }
            else
            {
                [userInfo setValue:@"服务器异常，请稍后再试" forKey:NSLocalizedFailureReasonErrorKey];
            }

            NSError *error = [[NSError alloc] initWithDomain:kResourceErrorDomain code:[code integerValue] userInfo:userInfo];

            [self loadFailWithError:error];

            [PNetResourecManager shared].error = error;
        }
    }
    else
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

        [userInfo setValue:@"返回结果无效,服务器返回数据不是所定义的结构，解析不了" forKey:NSLocalizedFailureReasonErrorKey];

        NSError *error = [[NSError alloc] initWithDomain:kResourceErrorDomain code:PE_NetErrorCode_ServeNotValid userInfo:userInfo];

        [self loadFailWithError:error];
    }
}

// 加载失败回调
- (void)loadFailWithError:(NSError *)error
{
    if (error.code == -999)
    {
        // 取消网络请求操作会进入到这里
        return;
    }

    self.error = error;

    self.loadingStatus = PE_ResourceStatus_NotProcessed;
}

#pragma mark - ******************************Public Method******************************************

- (void)i_loadDataWithParameters:(NSDictionary*)parameters
{
    [self i_loadDataWithRequestMethodType:E_RequestMethodType_Post parameters:parameters];
}


- (void)i_loadDataWithRequestMethodType:(E_RequestMethodType)methodType
                              parameters:(NSDictionary*)parameters
{
    [self i_loadDataWithRequestMethodType:methodType
                                parameters:parameters
                                  dataType:E_RequestDataType_Normal];
}

- (void)i_loadDataWithRequestMethodType:(E_RequestMethodType)methodType
                              parameters:(NSDictionary*)parameters
                                dataType:(E_RequestDataType)dataType
{
    if (self.loading)
    {
        return;
    };

    if ([[DeviceInfo i_getNetworkType] isEqualToString:E_NetworkType_None]
        || [[DeviceInfo i_getNetworkType] isEqualToString:E_NetworkType_NoDisplay])
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

        [userInfo setValue:@"无网络连接" forKey:NSLocalizedFailureReasonErrorKey];

        NSError *error = [[NSError alloc] initWithDomain:kResourceErrorDomain code:PE_NetErrorCode_NoNetWork userInfo:userInfo];

        [self loadFailWithError:error];

        return;
    }

    self.error = nil;

    self.loadingStatus = PE_ResourceStatus_Processing;

    if (dataType == E_RequestDataType_Normal)
    {
        //  设置请求类型
        self.request.requestMethodType = methodType;
        if (parameters)
        {
            self.request.requestArgument = parameters;
        }
        else
        {
            self.request.requestArgument = @{};
        }


        [self.request i_startWithSuccess:^(BaseRequest *request, id responseObject) {
            [self loadedResponseObject:responseObject];
        } failure:^(BaseRequest *request, NSError *error) {
            [self loadFailWithError:error];
        }];
    }
    else
    {
//        TODO 多媒体文件上传封装
    }
}

- (void)setHttpStubConfig:(PNetWorkHttpStubConfig *)httpStubConfig
{
    if (httpStubConfig.isNeedRequestStub)
    {
        self.request.stubFileName = httpStubConfig.stubFileName;
        self.request.stubNetworkSpeed = httpStubConfig.stubNetworkSpeed;
        self.request.stubRequestResult = httpStubConfig.stubRequestResult;
        self.request.isNeedRequestStub = httpStubConfig.isNeedRequestStub;
    }
}

- (void)i_cancel
{
    [self.request i_cancleRequest];
}
#pragma mark - ******************************Override Method****************************************

- (void)needsReload
{
    self.loadingStatus = PE_ResourceStatus_NotProcessed;
}

- (void)needsload
{
    self.loadingStatus = PE_ResourceStatus_NotProcessed;
}

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

- (BaseRequest *)request
{
    if (!_request)
    {
        _request = [BaseRequest new];
        _request.requestHeaderFieldValueDictionary = @{}.copy;
        _request.requestSerializerType = E_RequestSerializerType_Json;
        _request.responseSerializerType = E_ResponseSerializerType_Json;
        _request.timeoutInterval = 15.0;
    }
    return _request;
}
#pragma mark Convenience Accessors

- (BOOL)isLoading
{
    return self.loadingStatus & 2; //0010为loading
}

- (BOOL)isLoaded
{
    return (self.loadingStatus == PE_ResourceStatus_Processed) ||
           (self.loadingStatus == PE_ResourceStatus_Cache);
}
@end
