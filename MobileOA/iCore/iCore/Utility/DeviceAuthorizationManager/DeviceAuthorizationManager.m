//
//  DeviceAuthorizationManager.m
//  iCore 
//
//  Created by renqingyang on 2017/11/16.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "DeviceAuthorizationManager.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <HealthKit/HealthKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import "Macro_DeviceInfo.h"

@interface DeviceAuthorizationManager ()<CLLocationManagerDelegate>

@property (nonatomic, copy) DeviceAuthorizationStatusBlock statusBlock;

@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) HKHealthStore *healthStore;

@property (nonatomic, strong) CLLocationManager * locationManager;//定位管理器

@end
@implementation DeviceAuthorizationManager

kSingleton_m(DeviceAuthorizationManager)

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.pedometer = [[CMPedometer alloc] init];

        self.healthStore = [[HKHealthStore alloc] init];
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

- (void)fetchHKDataCompelete:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    // 设置类型为步数
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];

    // 设置索引类型，按天索引
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.day = 1;

    HKStatisticsCollectionQuery *collectionQuery =
    [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                      quantitySamplePredicate:nil
                                                      options:HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource
                                                   anchorDate:[NSDate date]
                                           intervalComponents:intervalComponents];

    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error){
        if (error || result.statistics.count == 0)
        {
            /// 授权拒绝
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
        }
        else
        {
            /// 授权
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
        }
    };
    [self.healthStore executeQuery:collectionQuery];
}
#pragma mark-  根据不同状态处理 callback 回调

- (void)executeCallback:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
                 status:(E_AuthorizationStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (AuthorizationStatusBlock) {
            AuthorizationStatusBlock(status);
        }
    });
}

#pragma mark - ******************************Public Method******************************************

#pragma mark - 请求定位访问权限

- (void)i_requestLocationAuthorization:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    //判断定位是否开启
    if ([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

        // 还未开启授权
        if (status == kCLAuthorizationStatusNotDetermined)
        {
            self.statusBlock = AuthorizationStatusBlock;
            // 授权状态处理
            self.locationManager.delegate = self;

            if (self.alwaysUse)
            {
                [self.locationManager requestAlwaysAuthorization];
                self.locationManager.allowsBackgroundLocationUpdates = YES;
            }
            else
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
        // 已授权
        else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            // 授权状态处理
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
        }
        else
        {
            // 系统没有授权
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
        }
    }
    else
    {
        /// 系统定位没有打开，设置为关闭状态
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
    }
}

#pragma mark - 请求麦克风访问权限

- (void)i_requestAudioAuthorization:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    /// 系统授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];

    /// 从来没有设置过权限
    if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        /// 用户选择状态回调
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted)
         {
             if (granted)
             {
                 [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
             }
             else
             {
                 [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
             }
         }];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Restricted];
    }
}

#pragma mark - 请求相册访问权限

- (void)i_requestImagePickerAuthorization:(void(^)(E_AuthorizationStatus status))callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // 系统授权状态
        PHAuthorizationStatus authStatus = [PHPhotoLibrary  authorizationStatus];

        // 从来没有设置过权限
        if (authStatus == PHAuthorizationStatusNotDetermined)
        {
            // 8.0以上会有用户选择状态，获取用户选择状态回调
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
             {
                 if (status == PHAuthorizationStatusAuthorized)
                 {
                     [self executeCallback:callback status:E_AuthorizationStatus_Authorized];
                 }
                 else if (status == PHAuthorizationStatusDenied)
                 {
                     [self executeCallback:callback status:E_AuthorizationStatus_Denied];
                 }
                 else if (status == PHAuthorizationStatusRestricted)
                 {
                     [self executeCallback:callback status:E_AuthorizationStatus_Restricted];
                 }
             }];
        }
        else if (authStatus == PHAuthorizationStatusAuthorized)
        {
            [self executeCallback:callback status:E_AuthorizationStatus_Authorized];
        }
        else if (authStatus == PHAuthorizationStatusDenied)
        {
            [self executeCallback:callback status:E_AuthorizationStatus_Denied];
        }
        else if (authStatus == PHAuthorizationStatusRestricted)
        {
            [self executeCallback:callback status:E_AuthorizationStatus_Restricted];
        }
    }
    else
    {
        /// 硬件不支持
        [self executeCallback:callback status:E_AuthorizationStatus_NotSupport];
    }
}

#pragma mark - 请求相机的访问权限

- (void)i_requestCameraAuthorization:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        /// 系统授权状态
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        /// 从来没有设置过权限
        if (authStatus == AVAuthorizationStatusNotDetermined)
        {
            /// 用户选择状态回调
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if (granted)
                 {
                     [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
                 } else {
                     [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
                 }
             }];
        }
        else if (authStatus == AVAuthorizationStatusAuthorized)
        {
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
        }
        else if (authStatus == AVAuthorizationStatusDenied)
        {
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
        }
        else if (authStatus == AVAuthorizationStatusRestricted)
        {
            [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Restricted];
        }
    }
    else
    {
        /// 硬件不支持
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_NotSupport];
    }
}

#pragma mark - 请求健康访问权限
- (void)i_requestHKTypeStepCountAuthorization:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    // 判断设备是否支持HealthKit
    if ([HKHealthStore isHealthDataAvailable])
    {
        // 样本类型获取
        HKObjectType *stepsType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];

        // 步数授权状态
        HKAuthorizationStatus authStatus = [self.healthStore authorizationStatusForType:stepsType];

        // 从来没有设置过权限
        if (authStatus == HKAuthorizationStatusNotDetermined)
        {
            NSSet *readType = [NSSet setWithObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]];

            [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readType completion:^(BOOL success, NSError * _Nullable error) {
                // 成功
                if (success)
                {
                    [self fetchHKDataCompelete:AuthorizationStatusBlock];
                }
                else
                {
                    /// 授权拒绝
                    [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
                }
            }];
        }
        else
        {
            [self fetchHKDataCompelete:AuthorizationStatusBlock];
        }
    }
    else
    {
        /// 硬件不支持
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_NotSupport];
    }
}

// 请求运动与健康访问权限
- (void)i_requestCMPedometerAuthorization:(DeviceAuthorizationStatusBlock)AuthorizationStatusBlock
{
    // 判断设备是否支持HealthKit
    if ([CMPedometer isStepCountingAvailable])
    {
        // iOS 11.0 以上
        if (@available(iOS 11.0, *)) {
            CMAuthorizationStatus authStatus = [CMPedometer authorizationStatus];

            // 从来没有设置过权限
            if (authStatus == CMAuthorizationStatusNotDetermined)
            {
                [self.pedometer queryPedometerDataFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]
                                                    toDate:[NSDate date]
                                               withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {

                    CMAuthorizationStatus authStatus = [CMPedometer authorizationStatus];

                    if (authStatus == CMAuthorizationStatusAuthorized)
                    {
                        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
                    }
                    else if (authStatus == CMAuthorizationStatusDenied)
                    {
                        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
                    }
                    else if (authStatus == CMAuthorizationStatusRestricted)
                    {
                        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Restricted];
                    }
                }];
            }
            else if (authStatus == CMAuthorizationStatusAuthorized)
            {
                [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
            }
            else if (authStatus == CMAuthorizationStatusDenied)
            {
                [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
            }
            else if (authStatus == CMAuthorizationStatusRestricted)
            {
                [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Restricted];
            }
        } else {

            [self.pedometer queryPedometerDataFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]
                                                toDate:[NSDate date]
                                           withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {

                // 用户手动拒绝
                if (error.code == 105)
                {
                    [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Denied];
                }
                // 用户允许
                else if (error.code == 0)
                {
                    [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_Authorized];
                }
            }];
        }
    }
    else
    {
        /// 硬件不支持
        [self executeCallback:AuthorizationStatusBlock status:E_AuthorizationStatus_NotSupport];
    }
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - 状态改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //是否具有定位权限
    if (status == kCLAuthorizationStatusDenied )
    {
        // 授权被拒绝状态处理
        [self executeCallback:self.statusBlock status:E_AuthorizationStatus_Denied];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
             status == kCLAuthorizationStatusAuthorizedAlways)
    {
        // 授权状态处理
        [self executeCallback:self.statusBlock status:E_AuthorizationStatus_Authorized];
    }

    self.locationManager.delegate = nil;
}

#pragma mark - ******************************Setter & Getter****************************************

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

#pragma mark - ******************************类方法**************************************************

@end
