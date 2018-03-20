//
//  NetWorkConfig.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/14.

//

#import <Foundation/Foundation.h>

#import <iCore/iCore.h>

/*!
 *  @author renqingyang, 16-07-15 11:30:17
 *
 *  @brief  初始化网络配置
 *
 *  @since  1.0
 */
@interface NetWorkConfig : NSObject


// 获取单例
kSingleton_h

// 基本地址
@property (nonatomic, copy) NSString *baseUrl;

// 请求头添加的内容
@property (nonatomic, copy) NSDictionary *additionalHeaderFields;

// 请求超时时间
@property (nonatomic, assign) NSTimeInterval defaultTimeOutInterval;

@property (nonatomic, strong) NSIndexSet *defaultAcceptableStatusCodes;

@property (nonatomic, strong) NSSet *defaultAcceptableContentTypes;

@end
