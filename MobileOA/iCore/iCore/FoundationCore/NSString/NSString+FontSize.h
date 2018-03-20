//
//  NSString+FontSize.h
//  iCore 
//
//  Created by 任清阳 on 2017/3/13.
//
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (FontSize)

/*!
 
 @brief 计算string文字size。
 
 @discussion 计算string文字size.
 
 @code
 
 [self i_getStringSizeWithMaxWidth:maxWidth font:font];
 
 @endcode
 
 @param maxWidth  字符串显示最大宽度
 @param font           字符串字体大小
 
 @return 实际size

 */
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                                  font:(UIFont *)font;

/*!
 
 @brief  获取文本内容最大size。
 
 @discussion 获取文本内容最大size.
 
 @code
 
 [self i_getStringSizeWithMaxWidth:maxWidth
 lineSpacing:lineSpacing
 font:font];
 
 @endcode
 
 @param maxWidth  字符串显示最大宽度
 @param lineSpacing       字符串行间距
 @param font           字符串字体大小
 
 @return 字符串内容size
 
 */
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                           lineSpacing:(CGFloat)lineSpacing
                                  font:(UIFont *)font;

/*!
 
 @brief 计算string文字size。
 
 @discussion 计算string文字size.
 
 @code
 
 [self i_getStringSizeWithMaxWidth:maxWidth
                        lineSpacing:aFloatLineSpacing
                           maxLines:0
                               font:aFont];
 
 @endcode
 
 @param maxWidth  字符串显示最大宽度
 @param maxLines       字符串最大显示行数
 @param lineSpacing       字符串行间距
 @param font           字符串字体大小
 
 @return 实际size
 
 @remark maxLines = 0行表示不限行高.
 
 */
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                           lineSpacing:(CGFloat)lineSpacing
                              maxLines:(NSInteger)maxLines
                                  font:(UIFont *)font;

/*!
 
 @brief 计算string文字size。
 
 @discussion 计算string文字size.
 
 @code
 
 
 @endcode
 
 @param maxWidth  字符串显示最大宽度
 @param paragraphStyle       富文本段落风格
 @param font           字符串字体大小
 
 @return 字符串内容size
 
 */
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                        paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
                                  font:(UIFont*)font;

/*!
 
 @brief 计算string文字size。
 
 @discussion 计算string文字size.
 
 @code
 
 
 @endcode
 
 @param maxWidth  字符串显示最大宽度
 @param paragraphStyle       富文本段落风格
 @param maxLines       字符串最大显示行数
 @param font           字符串字体大小
 
 @return 实际size
 
 @remark maxLines = 0行表示不限行高.
 
 */
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                        paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
                              maxLines:(NSInteger)maxLines
                                  font:(UIFont*)font;
@end
