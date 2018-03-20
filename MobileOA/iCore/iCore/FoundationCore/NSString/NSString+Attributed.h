//
//  NSString+Attributed.h
//  iCore 
//
//  Created by renqingyang on 2017/12/15.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-12-14  14:49:20
 *
 *  @brief  通过配置字典获取富文本字符串
 *
 *  @since  1.0 
 */
@interface NSString (Attributed)

- (NSAttributedString *)i_attributedStringWithStyleDic:(NSDictionary *)configDic;

@end
