//
//  DeviceAuthorizationManager.h
//  iCore 
//
//  Created by renqingyang on 2017/11/16.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

// 访问权限状态枚举
typedef NS_ENUM(NSUInteger, E_AuthorizationStatus) {
    // 已授权
    E_AuthorizationStatus_Authorized = 0,
    // 拒绝
    E_AuthorizationStatus_Denied,
    // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    E_AuthorizationStatus_Restricted,
    // 硬件等不支持
    E_AuthorizationStatus_NotSupport
};

// 授权返回block
typedef void (^DeviceAuthorizationStatusBlock)(E_AuthorizationStatus status);

@interface DeviceAuthorizationManager : NSObject

/*
 * isAlwaysUse  是否后台定位 持续定位（NSLocationAlwaysUsageDescription）
 */
@property (nonatomic, assign, getter=isAlwaysUse) BOOL alwaysUse;

// 返回单例信息
kSingleton_h

// 请求定位访问权限
- (void)i_requestLocationAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;

// 请求麦克风访问权限
- (void)i_requestAudioAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;

// 请求相册访问权限
- (void)i_requestImagePickerAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;

// 请求相机访问权限
- (void)i_requestCameraAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;

// 请求健康的步数访问权限
- (void)i_requestHKTypeStepCountAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;

// 请求运动与健康访问权限
- (void)i_requestCMPedometerAuthorization:(DeviceAuthorizationStatusBlock _Nullable )AuthorizationStatusBlock;
@end
