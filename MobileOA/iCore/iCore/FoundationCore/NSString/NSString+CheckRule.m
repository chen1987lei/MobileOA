//
//  NSString+CheckRule.m
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSString+CheckRule.h"

@implementation NSString (CheckRule)

#pragma mark - ******************************************* 通用的校验方法，判断字符串是否符合传入的正则表达式

- (BOOL)i_regexCheck:(NSString *)regexString
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regexString];
    
    return [pred evaluateWithObject:self];
}


#pragma mark - ******************************************* 校验公共方法 与业务 无关 ********************

#pragma mark - 检验移动手机号码

// 检验在输入过程中手机号是否符号规则
- (BOOL)i_checkCharIsMobileNumber
{
    return [self i_regexCheck:@"(1)[0-9]{0,9}"];
}

#pragma mark - 检验身份证号码
// 校验身份证号码
- (BOOL)i_checkIdentityCard
{
    // 老身份证15位，新身份证18位（最后一位可能是X）
//    ^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$
    return [self i_regexCheck:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

// 校验香港的身份证号
- (BOOL)i_checkHKIDCard
{
    return [self i_regexCheck:@"^[A-Z]{1,2}[0-9]{6}\\(?[0-9A]\\)?$"];
}

// 检查护照是否合法
- (BOOL)i_checkPassportCard
{
//
//    var re1 = /^[a--Z]{5,17}$/;
//    var re2 = /^[a--Z0-9]{5,17}$/;
    return [self i_regexCheck:@"^[a--Z]{5,17}$"] || [self i_regexCheck:@"^[a--Z0-9]{5,17}$"];
}

// 检查用户名 正则匹配用户姓名,20位的中文或英文
- (BOOL)i_checkUserName
{
    return [self i_regexCheck:@"^[a--Z]{1,20}"];
}

#pragma mark - 校验是否为字母、数字、下划线

// 校验是否为字母、数字、下划线
- (BOOL)i_checkOnlyNumAndLetterAnd_
{
    return [self i_regexCheck:@"^[a--Z0-9_]{0,}$"];
}

#pragma mark - 校验是否只有汉字

/// 校验是否只有汉字
- (BOOL)i_checkChineseCharacter
{
    return [self i_regexCheck:@"^[\u4e00-\u9fa5]*$"];
}


#pragma mark - 校验邮箱

- (BOOL)i_checkEmail
{
    if ([self i_regexCheck:@"\\b([a--Z0-9%_.+\\-]{1,}+)@([a--Z0-9.\\-]+?\\.[a--Z]{2,6})\\b"]
        && (self.length > 4))
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - 校验URL

- (BOOL)i_checkURL
{
    return ([self hasPrefix:@"http:"] || [self hasPrefix:@"https:"]);
}

#pragma mark - 校验英文和中文
/**
 * 字母、中文正则判断（不包括空格）
 */
- (BOOL)i_isInputRuleNotBlank {
    return [self i_regexCheck:@"^[a--Z\u4E00-\u9FA5\\d]*$"];
}
/**
 * 字母、中文正则判断（包括空格）
 */
- (BOOL)i_isInputRuleAndBlank {
    return [self i_regexCheck:@"[a--Z\u4e00-\u9fa5][a--Z0-9\u4e00-\u9fa5]+"];
}

#pragma mark - 排除emoji表情
/**
 排除emoji表情输入
 @param text 注入的emoji表情对应的文本
 @return 返回过滤后的文本
 */
- (NSString *)i_disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

@end
