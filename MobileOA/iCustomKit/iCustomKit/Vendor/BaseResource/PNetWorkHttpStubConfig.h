//
//  PNetWorkHttpStubConfig.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/18.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <iNetWorkKit/iNetWorkKit.h>

/*!
 *  @author 任清阳, 2017-11-18  16:10:20
 *
 *  @brief  模拟网络请求配置文件
 *
 *  @since  1.0
 */
@interface PNetWorkHttpStubConfig : NSObject

/// 是否模拟请求
@property (nonatomic, assign) BOOL isNeedRequestStub;
/// 模拟请求文件名称
@property (nonatomic, copy) NSString *stubFileName;
/// 模拟网络的速度
@property (nonatomic, assign) E_StubNetworkSpeed stubNetworkSpeed;
/// 模拟网络请求返回状态
@property (nonatomic, assign) E_StubRequestResult stubRequestResult;

@end
