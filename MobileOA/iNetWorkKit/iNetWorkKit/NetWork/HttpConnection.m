//
//  HttpConnection.m
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/14.

//

#import "HttpConnection.h"

#import "NetWorkConfig.h"

#import "AFNetworking.h"

#import <objc/runtime.h>

// 请求超时时间
static NSTimeInterval requestTimeoutInterval  = 30.0;

// requestConnectionKey
static const char kBaseRequestConnectionKey;

@implementation BaseRequest (HttpConnection)

- (HttpConnection *)connection
{
    return objc_getAssociatedObject(self, &kBaseRequestConnectionKey);
}

- (void)setConnection:(HttpConnection *)connection
{
    objc_setAssociatedObject(self, &kBaseRequestConnectionKey, connection, OBJC_ASSOCIATION_RETAIN);
}

@end

@interface HttpConnection ()

@property (nonatomic, strong, readwrite) BaseRequest *request;

@property (nonatomic, strong, readwrite) NSURLSessionDataTask *task;

@property (nonatomic, copy) HttpConnectionSuccessBlock httpConnectionSuccessBlock;

@property (nonatomic, copy) HttpConnectionFailureBlock httpConnectionFailtureBlock;

@end

@implementation HttpConnection

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

/**
 *  生成headerFieldValueDic
 *
 *  @param request 处理的请求
 *
 */
- (NSDictionary *)headerFieldsValueWithRequest:(BaseRequest *)request
{
    NSMutableDictionary *headers = [[NetWorkConfig shared].additionalHeaderFields mutableCopy];
    
    [request.requestHeaderFieldValueDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [headers setObject:obj forKey:key];
    }];
    
    return headers;
}

#pragma mark - ******************************Public Method******************************************

- (void)i_connectWithRequest:(BaseRequest *)request
                      success:(HttpConnectionSuccessBlock)successBlock
                      failure:(HttpConnectionFailureBlock)failureBlock
{
    self.request = request;
    
    self.httpConnectionSuccessBlock = successBlock;
    self.httpConnectionFailtureBlock = successBlock;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
#pragma mark - 设置请求数据序列化类型
    if (request.requestSerializerType == E_RequestSerializerType_HTTP)
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestSerializerType == E_RequestSerializerType_Json)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    manager.requestSerializer.timeoutInterval = request.timeoutInterval ?: [NetWorkConfig shared].defaultTimeOutInterval ?: requestTimeoutInterval;
    
    NSDictionary *headers = [self headerFieldsValueWithRequest:request];
    [headers enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [manager.requestSerializer setValue:value forHTTPHeaderField:field];
    }];
    
#pragma mark - 设置响应数据序列化类型
    if (request.responseSerializerType == E_ResponseSerializerType_HTTP)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    else if (request.responseSerializerType == E_ResponseSerializerType_Json)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    manager.responseSerializer.acceptableStatusCodes = [NetWorkConfig shared].defaultAcceptableStatusCodes;
    manager.responseSerializer.acceptableContentTypes = [NetWorkConfig shared].defaultAcceptableContentTypes;
   
    NSString *urlString = @"";
    
    if (request.baseUrlString.length)
    {
        urlString = [NSURL URLWithString:request.requestUrlString
                           relativeToURL:
                     [NSURL URLWithString:request.baseUrlString]].absoluteString;
    }
    else
    {
        urlString = [NSURL URLWithString:request.requestUrlString relativeToURL:[NSURL URLWithString:[NetWorkConfig shared].baseUrl]].absoluteString;
    }
    
    NSDictionary *parameters = request.requestArgument;
    
    NSURLSessionDataTask *task = nil;
    switch (request.requestMethodType)
    {
        case E_RequestMethodType_Get:
        {
            task = [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
            break;
        case E_RequestMethodType_Patch:
        {
            task = [manager PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
            break;
        case E_RequestMethodType_Post:
        {
            task = [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
            break;
        case E_RequestMethodType_PostFile:
        {

            [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];

            task = [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (UIImage * image in _request.uploadDataArray) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
                    [formData appendPartWithFileData:imageData name:@"files" fileName:@"files1.jpg" mimeType:@"image/jpeg"];
                }
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
            break;
        case E_RequestMethodType_Put:
        {
            task = [manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
            break;
        case E_RequestMethodType_Delete:
        {
            task = [manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailure:request error:error];
            }];
        }
        default:{
            NSLog(@"不支持的请求类型");
        }
            break;
    }
    self.task = task;
    request.connection = self;
}

// 请求成功
- (void)requestHandleSuccess:(BaseRequest *)request responseObject:(id)object
{
    if (self.httpConnectionSuccessBlock)
    {
        self.httpConnectionFailtureBlock(self,object);
    }
}

// 请求失败
- (void)requestHandleFailure:(BaseRequest *)request error:(NSError *)error
{
    if (self.httpConnectionFailtureBlock)
    {
        self.httpConnectionFailtureBlock(self,error);
    }
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

@end
