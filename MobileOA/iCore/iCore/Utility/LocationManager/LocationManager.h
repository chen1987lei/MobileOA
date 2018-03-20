//
//  LocationManager.h
//  iCore 
//
//  Created by renqingyang on 2017/12/5.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

// 定位
typedef void(^UpdateLocationSuccessBlock) (CLLocation * _Nullable location, CLPlacemark * _Nullable placemark);
typedef void(^UpdateLocationErrorBlock) (CLRegion * _Nonnull region, NSError * _Nullable error);
// 地理编码:地名—>经纬度坐标
typedef void(^GeocodeSuccessBlock) (CLLocation * _Nullable location, CLPlacemark * _Nullable placmark, NSString * _Nullable geocodingAddressName);
typedef void(^GeocodeFailureBlock) (NSError * _Nullable error);
// 反地理编码:经纬度坐标—>地名
typedef void(^RegeocodeSuccessBlock) (CLLocation * _Nullable regeocodeLocation, CLPlacemark * _Nullable placmark);
typedef void(^RegeocodeFailureBlock) (NSError * _Nullable error);

@interface LocationManager : NSObject

// 返回单例信息
kSingleton_h

/*
 * isAlwaysUse  是否后台定位 持续定位（NSLocationAlwaysUsageDescription）
 */
@property (nonatomic, assign, getter=isAlwaysUse) BOOL alwaysUse;

/*
 * isRealTime 是否实时定位
 */
@property (nonatomic, assign, getter=isRealTime) BOOL realTime;

/*
 * 精度 默认 kCLLocationAccuracyKilometer
 */
@property (nonatomic, assign) CGFloat desiredAccuracy;

/*
 * 更新距离 默认1000米
 */
@property (nonatomic, assign) CGFloat distanceFilter;

// 开始定位
- (void)i_startUpdatingLocationWithSuccess:(UpdateLocationSuccessBlock _Nullable )success
                                    failure:(UpdateLocationErrorBlock _Nullable )error;

// 根据地址得到经纬度
- (void)i_geocodeAddress:(NSString *_Nonnull)address
                  success:(GeocodeSuccessBlock _Nullable )success
                  failure:(GeocodeFailureBlock _Nullable )failure;

// 根据经纬度得到地址
- (void)i_regeocodeLocation:(CLLocation *_Nonnull)location
                     success:(RegeocodeSuccessBlock _Nullable )success
                     failure:(RegeocodeFailureBlock _Nullable )failure;

@end
