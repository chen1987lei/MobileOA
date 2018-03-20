//
//  Macro_DeviceInfo.h
//  iCore 
//
//  Created by renqingyang on 2017/11/6.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_DeviceInfo_h
#define Macro_DeviceInfo_h

#pragma mark - ******************************************* 设备信息宏 ********************************

#pragma mark -设备型号

// 是否模拟器
#define kDevice_is_simulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#pragma mark -设备型号

// 设备是否是iPad
#define kDevice_is_iPad     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 设备是否是iPhone
#define kDevice_is_iPhone   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
// 设备是否是iPhone4/iPhone4s
#define kDevice_is_iPhone_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 设备是否是iPhone5/iPhone5s
#define kDevice_is_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 设备是否是iPhone6/iPhone6s/iPhone7/iPhone8
#define kDevice_is_iPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 设备是否是iPhone6 plus/iPhone6s plus/iPhone7 plus/iPhone8 plus
#define kDevice_is_iPhone_6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
// 设备是否是iPhoneX
#define kDevice_is_iPhone_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark -适配宏

// 状态栏高度
#define kStatusBar_Height (kDevice_is_iPhone_X ? 44.f : 20.f)
// 导航栏高度
#define kNavBar_Height (kDevice_is_iPhone_X ? 88.f : 64.f)
// tabBar高度
#define kTabBar_Height (kDevice_is_iPhone_X ? (50.f + 34.f) : 50.f)
// home indicator
#define kHomeIndicator_Height (kDevice_is_iPhone_X ? 34.f : 0.f)


#pragma mark -系统版本

// 当前设备系统版本
#define kDevice_System_Version   floorf([[UIDevice currentDevice].systemVersion floatValue]
// 设备系统版本是否等于某版本
#define kDevice_System_Version_EqualL_To(v)   ([[[UIDevice currentDevice] systemVersion] compare:v \
                                                                                           options:\
                                                                    NSNumericSearch] == NSOrderedSame)
// 设备系统版本是否大于某版本
#define kDevice_System_Version_Greater_Than(v)   ([[[UIDevice currentDevice] systemVersion] compare:v \
                                                                                              options:\
                                                                    NSNumericSearch] == NSOrderedDescending)
// 设备系统版本是否大于等于某版本
#define kDevice_System_Version_Greater_Than_Or_Equal_To(v)  ([[[UIDevice currentDevice] systemVersion] compare:v \
                                                                                                    options:\
                                                                    NSNumericSearch] != NSOrderedAscending)
// 设备系统版本是否小于某版本
#define kDevice_System_Version_Less_Than(v)   ([[[UIDevice currentDevice] systemVersion] compare:v \
                                                                                           options:\
                                                                    NSNumericSearch] == NSOrderedAscending)
// 设备系统版本是否小于等于某版本
#define kDevice_System_Version_Less_Than_Or_Equal_To(v)    ([[[UIDevice currentDevice] systemVersion] compare:v \
                                                                                                        options:\
                                                                    NSNumericSearch] != NSOrderedDescending)

// 设备物理尺寸
#define kDdevice_Screen_Height    [[UIScreen mainScreen] bounds].size.height
#define kDdevice_Screen_Width     [[UIScreen mainScreen] bounds].size.width

// 屏幕宽度比例，参数为参考标准
#define kScreenWidthScale(v) kDdevice_Screen_Height / (v)

#endif /* Macro_DeviceInfo_h */
