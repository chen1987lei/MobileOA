//
//  NSString+CheckRule.h
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-11-08  09:34:15
 *
 *  @brief  字符串校验
 *
 *  @since  1.0
 */
@interface NSString (CheckRule)

#pragma mark - ******************************************* 通用的校验方法，判断字符串是否符合传入的正则表达式

- (BOOL)i_regexCheck:(NSString *)regexString;

#pragma mark - ******************************************* 校验公共方法 与业务 无关 ********************

// 检验在输入过程中手机号是否符号规则
- (BOOL)i_checkCharIsMobileNumber;

// 检验身份证号码
- (BOOL)i_checkIdentityCard;

// 校验香港的身份证号
- (BOOL)i_checkHKIDCard;

// 检查护照是否合法
- (BOOL)i_checkPassportCard;

// 校验是否为字母、数字、下划线
- (BOOL)i_checkOnlyNumAndLetterAnd_;

// 检查用户名 正则匹配用户姓名,20位的中文或英文
- (BOOL)i_checkUserName;

// 校验是否只有汉字
- (BOOL)i_checkChineseCharacter;

// 校验邮箱
- (BOOL)i_checkEmail;

// 校验URL
- (BOOL)i_checkURL;

// 字母、中文正则判断（不包括空格）
- (BOOL)i_isInputRuleNotBlank;

// 字母、中文正则判断（包括空格）
- (BOOL)i_isInputRuleAndBlank;

// 排除输入emoji表情
- (NSString *)i_disable_emoji:(NSString *)text;

@end
