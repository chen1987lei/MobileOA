//
//  PNetResourecManager.h
//  PCustomKit
//
//  Created by renqingyang on 2017/12/25.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PNetErrorCodeRet)(NSError *__nullable error);

typedef NS_ENUM(NSInteger,PE_NetErrorCode) {
    // 连接取消
    PE_NetErrorCode_Cancel = -999,
    // 连接超时
    PE_NetErrorCode_TimeOut = -1001,
    // 无网络连接
    PE_NetErrorCode_NoNetWork = -1009,
    // 返回结果无效，不是json结构
    PE_NetErrorCode_RetNotValid = 123,
    // 返回结果无效,服务器返回数据不是所定义的结构，解析不了
    PE_NetErrorCode_ServeNotValid = 124
};

/*!
 *  @author 任清阳, 2017-12-25  10:55
 *
 *  @brief  网络资源管理
 *
 *  @since  1.0 
 */
@interface PNetResourecManager : NSObject

// 单例
kSingleton_h

/*!
 *
 *  @brief 错误码响应回调
 *
 *  @discussion 错误码响应回调
 *
 *  @param errorCodeCallback 错误码统一响应回调.
 *
 */
- (void)i_performHandlerWithErrorCodeCallback:(PNetErrorCodeRet _Nullable )errorCodeCallback;

@property (nonatomic, strong) NSError * _Nullable error;

@end
