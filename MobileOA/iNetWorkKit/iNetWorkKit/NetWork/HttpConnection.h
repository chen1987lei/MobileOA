//
//  HttpConnection.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/14.

//

#import <Foundation/Foundation.h>

#import "BaseRequest.h"

@class HttpConnection;

// 连接成功block
typedef void (^HttpConnectionSuccessBlock)(HttpConnection *connection, id responseJsonObject);
// 连接失败block
typedef void (^HttpConnectionFailureBlock)(HttpConnection *connection, NSError *error);

/*!
 *  @author 任清阳, 2017-11-14  10:06:19
 *
 *  @brief  网络请求的连接扩展
 *
 *  @since  1.0
 */
@interface BaseRequest (HttpConnection)

@property (nonatomic, assign, readonly) HttpConnection *connection;

@end

/*!
 *  @author 任清阳, 2017-11-14  10:05:19
 *
 *  @brief  网络连接类
 *
 *  @since  1.0
 */

@interface HttpConnection : NSObject

@property (nonatomic, strong, readonly) BaseRequest *request;

// 对应的sessionTask,请求的开始与取消都是task操控
@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

- (void)i_connectWithRequest:(BaseRequest *)request
                      success:(HttpConnectionSuccessBlock)successBlock
                      failure:(HttpConnectionFailureBlock)failureBlock;

@end
