//
//  LocationManager.m
//  iCore 
//
//  Created by renqingyang on 2017/12/5.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>
{
    UpdateLocationSuccessBlock _successBlock;
    UpdateLocationErrorBlock _errorBlock;
}

@property (nonatomic, strong) CLLocationManager * locationManager;//定位管理器

@end

@implementation LocationManager

kSingleton_m(LocationManager)

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.alwaysUse = NO;
        self.realTime = NO;
        _distanceFilter = 1000.f;
        _desiredAccuracy = kCLLocationAccuracyKilometer;
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

#pragma mark - ******************************Public Method******************************************

- (void)i_startUpdatingLocationWithSuccess:(UpdateLocationSuccessBlock)success
                                    failure:(UpdateLocationErrorBlock)error
{
    _successBlock = [success copy];
    _errorBlock = [error copy];

    // 定位服务是否可用
    if (![CLLocationManager locationServicesEnabled])
    {
        if (_errorBlock)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

            [userInfo setValue:@"定位服务没有打开" forKey:NSLocalizedFailureReasonErrorKey];

            NSError *error = [[NSError alloc] initWithDomain:@"com.ren.stepCount.error" code:-1 userInfo:nil];
            
            _errorBlock(nil,error);
        }
    }
    else
    {
        self.locationManager.delegate = self;

        self.locationManager.allowsBackgroundLocationUpdates = self.alwaysUse;
        //精度
        self.locationManager.desiredAccuracy = _desiredAccuracy;
        //更新距离
        self.locationManager.distanceFilter = _distanceFilter;
        //定位开始
        [self.locationManager startUpdatingLocation];
    }
}

- (void)i_geocodeAddress:(NSString *)address
                  success:(GeocodeSuccessBlock)success
                  failure:(GeocodeFailureBlock)failure
{
    if (address == nil || [address isEqualToString:@""])
    {
        return;
    }

    CLGeocoder * geocoder = [[CLGeocoder alloc] init];

    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"这个地址很坑爹啊，找不到");
            failure(error);
        } else {
            CLPlacemark * placemark = placemarks.firstObject;
            success(placemark.location,placemark,address);
        }
    }];
}

- (void)i_regeocodeLocation:(CLLocation *)location
                     success:(RegeocodeSuccessBlock)success
                     failure:(RegeocodeFailureBlock)failure
{
    if (!location)
    {
        return;
    }
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"木有找到");
            failure(error);
        } else {
            CLPlacemark * placemark = placemarks.firstObject;
            success(location,placemark);
        }
    }];
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = locations.firstObject;

    CLGeocoder * geocoder = [[CLGeocoder alloc] init];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks.firstObject;
        _successBlock(location,placemark);
    }];

    // 关闭定位
    if (!self.realTime)
    {
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    _errorBlock(region,error);
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
