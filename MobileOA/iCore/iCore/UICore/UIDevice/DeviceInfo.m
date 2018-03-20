//
//  DeviceInfo.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "DeviceInfo.h"

#import "Macro_NSString.h"
#import "Macro_DeviceInfo.h"
#import "NSObject+Invocation.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#include <sys/socket.h>
#import <arpa/inet.h>

E_NetworkType const E_NetworkType_None = @"None";
E_NetworkType const E_NetworkType_2G = @"2G";
E_NetworkType const E_NetworkType_3G = @"3G";
E_NetworkType const E_NetworkType_4G = @"4G";
E_NetworkType const E_NetworkType_WIFI = @"WIFI";
E_NetworkType const E_NetworkType_NoDisplay = @"NO DISPLAY";

// 对于不常使用的单例类，建议使用 weak singleton
static __weak DeviceInfo *weakInstance = nil;

static NSString *const appService = @"ren.qingyang";
static NSString *const appInfo_UDID = @"AppInfo_UDID";

@implementation DeviceInfo

#pragma mark - ******************************Init and Uninit****************************************

- (instancetype)init
{
    self = [super init];

    if (self)
    {

    }

    return self;
}

- (void)dealloc
{

}

#pragma mark - 苹果官方单例类写法

+ (id)allocWithZone:(NSZone *)zone
{
    DeviceInfo *strongInstance = weakInstance;

    @synchronized(self)
    {
        if (!strongInstance)
        {
            strongInstance = [super allocWithZone:zone];
            weakInstance = strongInstance;
        }
    }

    return strongInstance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - ******************************Setter & Getter****************************************

#pragma mark - disk info

// 总的磁盘空间
- (NSString *)totalDiskSpace
{
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory()
                                                                                error:nil]
                        objectForKey:NSFileSystemSize] longLongValue];

    return [NSByteCountFormatter stringFromByteCount:space countStyle:NSByteCountFormatterCountStyleMemory];
}

// 剩余磁盘空间
- (NSString *)freeDiskSpace
{
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory()
                                                                                error:nil]
                        objectForKey:NSFileSystemSize] longLongValue];
    
    return [NSByteCountFormatter stringFromByteCount:space countStyle:NSByteCountFormatterCountStyleMemory];
}

// 获取当前ip地址
- (NSString *)currentIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                
                kLog_Print(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                }
                else
                {
                    if([name isEqualToString:@"pdp_ip0"])
                    {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    kLog_Print(@"addr=%@",@"%@", addr);
    
    return addr ? addr : @"0.0.0.0";
}

// 是否允许推送;
- (BOOL)isAllowedNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if(UIUserNotificationTypeNone != setting.types)
    {
        return YES;
    }
    return NO;
}
#pragma mark - app info

#pragma mark 系统的语言

- (NSString *)appSystemLanguage
{
    // en:英文、zh-Hans:简体中文、zh-Hant:繁体中文、ja:日本 ......
    NSArray *arrayLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *stringSystemLanguage = [arrayLanguages objectAtIndex:0];
    return stringSystemLanguage;
}

#pragma mark - 系统时区

- (NSString *)appSystemTimezone
{
    return [[NSTimeZone systemTimeZone] name];
}
#pragma mark - App的版本号

- (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

#pragma mark - ******************************对外方法************************************************

#pragma mark - ******************************私有方法************************************************

#pragma mark - ******************************类方法**************************************************

// 返回单例信息
+ (DeviceInfo *)shared
{
    DeviceInfo *strongInstance = weakInstance;

    @synchronized(self)
    {
        if (!strongInstance)
        {
            strongInstance = [[[self class] alloc] init];
            weakInstance = strongInstance;
        }
    }
    
    return strongInstance;
}

#pragma mark - 获取appstore上应用版本

+(void)getAppStoreVersion:(NSString *)appId completionHandler:(void (^)(NSString *, NSError *))completionHandler
{
    NSAssert(appId.length > 0, @"appId长度要大于零");
    
    NSString *URL = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",appId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];;
                                      
                                      NSArray *infoArray = [infoDic objectForKey:@"results"];

                                      if ([infoArray count])
                                      {
                                          NSDictionary *releaseInfo = [infoArray firstObject];
                                          
                                          NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                                          
                                          if (completionHandler)
                                          {
                                              completionHandler(lastVersion, error);
                                          }
                                      }
                                      if (completionHandler)
                                      {
                                          completionHandler(nil, error);
                                      }
                                  }];
    
    [task resume];
}

#pragma mark - 系统设置

// 系统设置
+(void)i_gotoSystemSettingPage
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    [[UIApplication sharedApplication] openURL:url];
}

// 关于本机
+ (void)i_gotoAbout
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=General&path=About"];

    [DeviceInfo p_routerSystemUrl:url];
}

// Accessibility 辅助功能
+ (void)i_gotoAccessibility
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=General&path=ACCESSIBILITY"];

    [DeviceInfo p_routerSystemUrl:url];
}

// 通用
+ (void)i_gotoGeneral
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=General"];

    [DeviceInfo p_routerSystemUrl:url];
}

// wifi列表
+(void)i_gotoWifiList
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=WIFI"];

    [DeviceInfo p_routerSystemUrl:url];
}

// 定位服务
+(void)i_gotoLocation
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=LOCATION_SERVICES"];

    [DeviceInfo p_routerSystemUrl:url];
}

// 蓝牙设置界面
+(void)i_gotoBluetoothSetting
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=Bluetooth"];

    [DeviceInfo p_routerSystemUrl:url];
}

// 通知设置
+(void)i_gotoNotification
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=NOTIFICATIONS_ID"];

    [DeviceInfo p_routerSystemUrl:url];
}

// 照片与相机
+(void)i_gotoCamera
{
    NSURL *url = [NSURL URLWithString:@"Prefs:root=Photos"];

    [DeviceInfo p_routerSystemUrl:url];
}

#pragma mark - 私有方法
+(void)p_routerSystemUrl:(NSURL *)URL
{
    // ASCII 对私有方法做混淆
    NSData *methodData = [NSData dataWithBytes:(unsigned char []){0x6F,0x70,0x65,0x6E,0x53,0x65,0x6E,0x73,0x69,0x74,0x69,0x76,0x65,0x55,0x52,0x4C,0x3A,0x77,0x69,0x74,0x68,0x4F,0x70,0x74,0x69,0x6F,0x6E,0x73,0x3A} length:29];

    NSString *methodName = [[NSString alloc] initWithData:methodData encoding:NSASCIIStringEncoding];

    Class applicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");

    id target = [NSObject i_invocationSelector:NSSelectorFromString(@"defaultWorkspace") withObjects:nil addTarget:applicationWorkspace];

    if (target)
    {
        [NSObject i_invocationSelector:NSSelectorFromString(methodName) withObjects:@[URL] addTarget:target];
    }
}

#pragma mark - 网络相关

#pragma mark 获取当前网络类型
+ (E_NetworkType)i_getNetworkType
{
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = [app valueForKeyPath:@"statusBar"];
    NSString *network = @"";

    // iPhone X
    if (kDevice_is_iPhone_X)
    {
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];

        NSArray *subviews = [[foregroundView subviews][2] subviews];

        for (id subview in subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                network = E_NetworkType_WIFI;
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                network = [subview valueForKeyPath:@"originalText"];
            }
        }
    }
    // 非 iPhone X
    else
    {
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];

        for (id subview in subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
            {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = E_NetworkType_None;
                        break;
                    case 1:
                        network = E_NetworkType_2G;
                        break;
                    case 2:
                        network = E_NetworkType_3G;
                        break;
                    case 3:
                        network = E_NetworkType_4G;
                        break;
                    case 5:
                        network = E_NetworkType_WIFI;
                        break;
                    default:
                        break;
                }
            }
        }
    }

    if ([network isEqualToString:@""]) {
        network = E_NetworkType_NoDisplay;
    }
    return network;
}

#pragma mark 获取Wifi信息
+ (id)i_fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);

        if (info && [info count]) {
            break;
        }
    }
    return info;
}
#pragma mark 获取WIFI名字
+ (NSString *)i_getWifiSSID
{
    return (NSString *)[self i_fetchSSIDInfo][@"SSID"];
}
#pragma mark 获取WIFI的MAC地址
+ (NSString *)i_getWifiBSSID
{
    return (NSString *)[self i_fetchSSIDInfo][@"BSSID"];
}
#pragma mark 获取Wifi信号强度
+ (int)i_getWifiSignalStrength{

    int signalStrength = 0;
    //    判断类型是否为WIFI
    if ([[self i_getNetworkType]isEqualToString:E_NetworkType_WIFI])
    {
        UIApplication *app = [UIApplication sharedApplication];
        id statusBar = [app valueForKey:@"statusBar"];

        // iPhone X
        if (kDevice_is_iPhone_X)
        {
            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
            NSArray *subviews = [[foregroundView subviews][2] subviews];

            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                }
            }
        }
        // 非 iPhone X
        else
        {
            UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];

            NSArray *subviews = [foregroundView subviews];
            NSString *dataNetworkItemView = nil;

            for (id subview in subviews) {
                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    dataNetworkItemView = subview;
                    break;
                }
            }

            signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];

            return signalStrength;
        }
    }
    return signalStrength;
}

@end
