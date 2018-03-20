//
//  iCore ConfigManager.h
//  iCore
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Macro_Singleton.h"

// 本地国际化发生变化通知
FOUNDATION_EXPORT NSString * _Nullable const kLocalizdLanguageChangedNotication;

typedef NSString *E_LocalizedLanguage NS_STRING_ENUM;

// 英文简体
FOUNDATION_EXPORT E_LocalizedLanguage _Nonnull const E_LocalizedLanguage_En;
// 繁体
FOUNDATION_EXPORT E_LocalizedLanguage _Nullable const E_LocalizedLanguage_Zh_Hant;

/*!
 *  @author 任清阳, 2017-11-07  10:50
 *
 *  @brief  iCore配置管理类
 *
 *  @since  1.0
 */

@interface CoreConfigManager : NSObject

// 返回单例信息
kSingleton_h

// 是否开启自嗨模式
@property(nonatomic, assign, getter = isHiMode) BOOL hiMode;

// 是否debugToast
@property(nonatomic, assign, getter = isShowDebugToast) BOOL showDebugToast;

// 是否开启自适应字体模式
@property(nonatomic, assign, getter = isJustFont) BOOL justFont;

// 是否开始NSArray&NSDictionary nil 保护
@property(nonatomic, assign, getter = isOpenNilProtect) BOOL openNilProtect;

// 国际化语言类型
@property(nonatomic, copy) E_LocalizedLanguage _Nullable localizedLanguage;

@end
