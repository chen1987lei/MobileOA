//
//  DeviceInfo.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/// E_NetworkType枚举
typedef NSString *E_NetworkType NS_STRING_ENUM;

FOUNDATION_EXPORT E_NetworkType const E_NetworkType_None;
FOUNDATION_EXPORT E_NetworkType const E_NetworkType_2G;
FOUNDATION_EXPORT E_NetworkType const E_NetworkType_3G;
FOUNDATION_EXPORT E_NetworkType const E_NetworkType_4G;
FOUNDATION_EXPORT E_NetworkType const E_NetworkType_WIFI;
FOUNDATION_EXPORT E_NetworkType const E_NetworkType_NoDisplay;

/*!
 *  @author 任清阳, 2017-11-07  11:12
 *
 *  @brief  设备信息单例
 *
 *  @since  1.0
 */

@interface DeviceInfo : NSObject

// 返回单例信息
+ (DeviceInfo *)shared;

#pragma mark - app info

// App的版本号
@property (nonatomic, copy, readonly) NSString *appVersion;

// app系统的语言，zh_Hans表示简体中文
@property (nonatomic, copy, readonly) NSString *appSystemLanguage;

// 获取设备的时区   timezone
@property (nonatomic, copy, readonly) NSString *appSystemTimezone;

#pragma mark - disk info

// 总的磁盘空间
@property (nonatomic, copy, readonly) NSString *totalDiskSpace;

// 剩余磁盘空间
@property (nonatomic, copy, readonly) NSString *freeDiskSpace;

// 获取当前ip地址
@property (nonatomic, copy, readonly) NSString *currentIPAddress;

// 是否允许推送;
@property (nonatomic, assign, getter = isAllowedNotification, readonly) BOOL allowedNotification;

//获取appstore上应用版本
+(void)getAppStoreVersion:(NSString *)appId
        completionHandler:(void (^)(NSString *, NSError *))completionHandler;

#pragma mark - 系统设置

// 系统设置页
+(void)i_gotoSystemSettingPage;

// wifi列表
+(void)i_gotoWifiList;

// 关于本机
+ (void)i_gotoAbout;

// Accessibility 辅助功能
+ (void)i_gotoAccessibility;

// 通用
+ (void)i_gotoGeneral;

//定位服务
+(void)i_gotoLocation;

//蓝牙设置界面
+(void)i_gotoBluetoothSetting;

//通知设置
+(void)i_gotoNotification;

//照片与相机
+(void)i_gotoCamera;

#pragma mark - 网络相关

//获取当前网络类型
+ (E_NetworkType)i_getNetworkType;
//获取Wifi信息
+ (id)i_fetchSSIDInfo;
//获取WIFI名字
+ (NSString *)i_getWifiSSID;
//获取WIFi的MAC地址
+ (NSString *)i_getWifiBSSID;
//获取Wifi信号强度
+ (int)i_getWifiSignalStrength;

@end
