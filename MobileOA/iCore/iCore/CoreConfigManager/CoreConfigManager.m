//
//  iCore ConfigManager.m
//  iCore
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "CoreConfigManager.h"

#import "UIView+Toast.h"

#import "ZIKCellularAuthorization.h"

// 本地国际化发生变化通知
NSString *const kLocalizdLanguageChangedNotication = @"kLocalizdLanguageChanged";

// 英文
E_LocalizedLanguage const E_LocalizedLanguage_En = @"en";
// 中文繁体
E_LocalizedLanguage const E_LocalizedLanguage_Zh_Hant = @"zh-Hant";

@implementation CoreConfigManager

kSingleton_m(CoreConfigManager)

#pragma mark - ******************************Init and Uninit****************************************

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 修改iOS设置网络bug
        [ZIKCellularAuthorization requestCellularAuthorization];
    }
    
    return self;
}

#pragma mark - ******************************Setter & Getter****************************************

- (void)setLocalizedLanguage:(E_LocalizedLanguage)localizedLanguage
{
    _localizedLanguage = localizedLanguage;
    
    [[NSUserDefaults standardUserDefaults] setObject:@[localizedLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 发出本地化语言改变通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocalizdLanguageChangedNotication
                                                        object:localizedLanguage];
}
#pragma mark - ******************************对外方法************************************************

#pragma mark - ******************************类方法**************************************************

@end
