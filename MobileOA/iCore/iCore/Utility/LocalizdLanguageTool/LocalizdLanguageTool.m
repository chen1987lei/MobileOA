//
//  LocalizdLanguageTool.m
//  AXABuBu
//
//  Created by renqingyang on 2017/11/10.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "LocalizdLanguageTool.h"

#import "NSBundle+Path.h"

// 获取国际化文件目录，中文版 app 不管什么情况下都显示中文，英文版 app 不管什么情况下都显示英文
#define kLocalizedPath(language) [[NSBundle mainBundle] pathForResource:(language) ofType:@"lproj"]
#define kBundleLocalizedPath(name,language) [name pathForResource:(language) ofType:@"lproj"]

@implementation LocalizdLanguageTool

#pragma mark - ******************************Initial Methods****************************************

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

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

#pragma mark - ******************************Public Method******************************************

+(NSString *)i_getlocalizedStringForKey:(NSString *)key
                               withTable:(E_LocalizedTable)localizedTable
{
    return [[NSBundle bundleWithPath:kLocalizedPath([CoreConfigManager shared].localizedLanguage)]
            localizedStringForKey:key
            value:@""
            table:localizedTable];
}

+(NSString *)i_getlocalizedStringForKey:(NSString *)key
                               withTable:(E_LocalizedTable)localizedTable
                              withBundle:(NSString *)bundle
{
    NSBundle *name = [NSBundle i_getBundleWithName:bundle];

    return [[NSBundle bundleWithPath:kBundleLocalizedPath(name, [CoreConfigManager shared].localizedLanguage)]
            localizedStringForKey:key
            value:@""
            table:localizedTable];
}
+(NSString *)i_getlocalizedStringForKey:(NSString *)key
                           localLanguage:(E_LocalizedLanguage)language
                               withTable:(E_LocalizedTable)localizedTable
{
    return [[NSBundle bundleWithPath:kLocalizedPath(language)]
            localizedStringForKey:key
            value:@""
            table:localizedTable];
}

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

#pragma mark - ******************************类方法**************************************************

@end
