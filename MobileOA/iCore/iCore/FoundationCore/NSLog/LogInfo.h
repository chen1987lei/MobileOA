//
//  LogInfo.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-11-07  10:50
 *
 *  @brief  Log单例
 *
 *  @since  1.0
 */

@interface LogInfo : NSObject

// 返回单例信息
kSingleton_h

/*!
 *  @author renqingyang, 17-11-07 10:52:59
 *
 *  @brief  打印 LOG 信息
 *
 *  @param userInfoString 用户个人信息，具有标志性，便于识别
 *  @param comInfoString  公共信息，比如文件、函数名字
 *  @param info 显示的 LOG
 *
 *  @since 1.0
 */
- (void)i_printLogWithUserInfo:(NSString *_Nullable)userInfoString
                       comInfo:(NSString *_Nullable)comInfoString
                      showInfo:(id _Nullable )info;

/*!
 *  @author 任清阳, 17-11-07 10:54:17
 *
 *  @brief  打印 控制台 LOG 信息
 *  控制台信息，原来是将printf做个映射，让App拿到printf的信息，供开发者使用
 *  为了不影响正常的开发，此处只是负责判断是否自嗨模式，而控制台信息在真机且Release模式下有效的条件是在App中控制的
 *
 *  @param info 显示的 LOG
 *
 *  @since 10.1.0
 */
- (void)i_printTerminalLogInfo:(id _Nullable )info;

// log 打印时间戳
@property (nonatomic, strong) NSDateFormatter * _Nullable printLogDateFormatter;

@end
