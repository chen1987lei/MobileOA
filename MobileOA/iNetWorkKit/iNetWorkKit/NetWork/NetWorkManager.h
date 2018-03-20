//
//  NetWorkManager.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/14.

//

#import <Foundation/Foundation.h>

#import <iCore/iCore.h>

#import "BaseRequest.h"

@class NetWorkManager;

@interface BaseRequest (NetworkManager)

@property (nonatomic, strong, readonly) id _Nullable responseObject;

@property (nonatomic, strong, readonly) NSError * _Nullable error;

@end


@interface NetWorkManager : NSObject

// 单例
kSingleton_h

// 添加请求
- (void)i_addRequest:(BaseRequest *_Nullable)request;

// 取消请求
- (void)i_cancleRequest:(BaseRequest *_Nullable)request;

// 取消所有网络请求
- (void)i_cancleAllRequest;

@end
