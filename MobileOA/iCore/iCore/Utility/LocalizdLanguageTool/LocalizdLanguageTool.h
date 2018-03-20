//
//  ZBLocalizdLanguageTool.h
//  AXABuBu
//
//  Created by renqingyang on 2017/11/10.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

// 获取本地化宏
#define kLocalizedString(key,table) [LocalizdLanguageTool i_getlocalizedStringForKey:(key) withTable:(table)]
// 获取framework里本地化宏
#define kBundleLocalizedString(name,key,table) [LocalizdLanguageTool i_getlocalizedStringForKey:(key) withTable:(table) withBundle:(name)]
// 指定语言本地化宏
#define kLanguageLocalizedString(key,language,table) \
[LocalizdLanguageTool i_getlocalizedStringForKey:(key) \
localLanguage:(language) \
withTable:(table)]

typedef NSString *E_LocalizedTable NS_STRING_ENUM;

/*!
 *  @author 任清阳, 2017-11-10  10:28:29
 *
 *  @brief  本地语言工具类
 *
 *  @since  1.0
 */
@interface LocalizdLanguageTool : NSObject

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param localizedTable table
 *
 *  @return 返回table中指定的key的值
 */
+(NSString *)i_getlocalizedStringForKey:(NSString *)key withTable:(E_LocalizedTable)localizedTable;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param localizedTable table bundle
 *  @param bundle bundle
 *
 *  @return 返回table中指定的key的值
 */
+(NSString *)i_getlocalizedStringForKey:(NSString *)key
                               withTable:(E_LocalizedTable)localizedTable
                              withBundle:(NSString *)bundle;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param localizedTable table
 *  @param language language
 *
 *  @return 返回table中指定的key的值
 */
+(NSString *)i_getlocalizedStringForKey:(NSString *)key
                           localLanguage:(E_LocalizedLanguage)language
                               withTable:(E_LocalizedTable)localizedTable;

@end
