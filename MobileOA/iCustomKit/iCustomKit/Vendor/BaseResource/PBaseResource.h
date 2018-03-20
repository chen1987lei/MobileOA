//
//  PBaseResource.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <iNetWorkKit/iNetWorkKit.h>

@class PNetWorkHttpStubConfig;

// 监听网络请求状态路径
FOUNDATION_EXPORT NSString * const kResourceLoadingStatusKeyPath;

@interface PBaseResource : NSObject

@property (nonatomic, readonly) BaseRequest *request;

@property (nonatomic, readonly) NSError *error;

// 用来判断网络是否已经加载完成
@property (nonatomic, readonly, getter = isLoaded, assign) BOOL loaded;

@property (nonatomic, readonly, getter = isLoading, assign) BOOL loading;

/**
 *  @author renqingyang 初始化
 *
 *  @brief 初始化网络资源对象
 *
 *  @param url hostUrl地址
 *
 *  @param path 路径
 *
 *  @return PBaseResource
 *
 *  @since 1.0
 */
- (instancetype)initWithBaseURL:(NSString *)url path:(NSString *)path;

/**
 *  @author renqingyang 初始化
 *
 *  @brief 初始化网络资源对象
 *
 *  @param path 路径
 *
 *  @return PBaseResource
 *
 *  @since 1.0
 */
- (instancetype)initWithPath:(NSString *)path;

/**
 *  @author renqingyang 初始化
 *
 *  @brief 通过字典初始化
 *
 *  @param values 字典
 *
 *  @return PBaseResource
 *
 *  @since 1.0
 */
- (instancetype)initWithValues:(id)values;

/**
 *  @author renqingyang 加载网络数据
 *
 *  @brief 通过默认请求加载网络数据
 *
 *  @param parameters 网络请求参数
 *
 *  @since 1.0
 */
- (void)i_loadDataWithParameters:(NSDictionary*)parameters;

/**
 *  @author renqingyang 加载网络数据
 *
 *  @brief 通过指定请求方式加载网络数据
 *
 *  @param parameters 网络请求参数
 *
 *  @param methodType 网络请求类型
 *
 *  @since 1.0
 */
- (void)i_loadDataWithRequestMethodType:(E_RequestMethodType)methodType
                              parameters:(NSDictionary*)parameters;

/**
 *  @author renqingyang 加载网络数据
 *
 *  @brief 通过指定请求方式加载网络数据
 *
 *  @param parameters 网络请求参数
 *
 *  @param dataType 网络请求数据类型
 *
 *  @param methodType 网络请求类型
 *
 *  @since 1.0
 */
- (void)i_loadDataWithRequestMethodType:(E_RequestMethodType)methodType
                              parameters:(NSDictionary*)parameters
                                dataType:(E_RequestDataType)dataType;

- (void)i_needsReload NS_REQUIRES_SUPER;

- (void)i_needsload NS_REQUIRES_SUPER;

- (void)i_cancel;

#ifdef DEBUG
- (void)i_setHttpStubConfig:(PNetWorkHttpStubConfig *)httpStubConfig;
#endif

@end
