//
//  NSString+FontSize.m
//  iCore 
//
//  Created by 任清阳 on 2017/3/13.
//
//

#import "NSString+FontSize.h"

#import "NSString+CheckRule.h"

@implementation NSString (FontSize)

#pragma mark - 计算string文字size。

- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                                  font:(UIFont *)font
{
    return [self i_getStringSizeWithMaxWidth:maxWidth lineSpacing:0.0 maxLines:0 font:font];
}

#pragma mark - 计算string文字size。
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                           lineSpacing:(CGFloat)lineSpacing
                              maxLines:(NSInteger)maxLines
                                  font:(UIFont *)font
{
    if (self.length == 0)
    {
        return CGSizeZero;
    }
    /// 根据行数，行间距，预估最大高度
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxWidth - 1);
    
    /// 获取原始高度
    CGSize orginalSize = [self getStringBoundingRectWithMaxWidth:maxWidth font:font lineSpacing:lineSpacing];
    
    /// 如果原始高度大于预估最大高度
    if ( orginalSize.height >= maxHeight && maxLines > 0)
    {
        return CGSizeMake(maxWidth, maxHeight);
    }
    else
    {
        return orginalSize;
    }
}

- (CGSize)getStringBoundingRectWithMaxWidth:(CGFloat)maxWidth
                                       font:(UIFont*)font
                                lineSpacing:(CGFloat)lineSpacing
{
    if (self.length == 0)
    {
        return CGSizeZero;
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = lineSpacing;
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(maxWidth, 1000000) options:options context:nil];

    /// 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing)
    {
        /// 如果包含中文
        if ([self i_checkChineseCharacter])
        {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }

    return rect.size;
}

#pragma mark - 获取文本内容最大高度。
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                            lineSpacing:(CGFloat)lineSpacing
                                   font:(UIFont *)font
{
   return  [self i_getStringSizeWithMaxWidth:maxWidth
                                  lineSpacing:lineSpacing
                                     maxLines:0
                                         font:font];
}

#pragma mark - 计算string文字size。
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                        paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
                              maxLines:(NSInteger)maxLines
                                  font:(UIFont*)font
{
    if (self.length == 0)
    {
        return CGSizeZero;
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(maxWidth, 100000) options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing)
    {
        /// 如果包含中文
        if ([self i_checkChineseCharacter])
        {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    return rect.size;
}

#pragma mark - 计算string文字size。
- (CGSize)i_getStringSizeWithMaxWidth:(CGFloat)maxWidth
                        paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
                                  font:(UIFont*)font
{
    return [self i_getStringSizeWithMaxWidth:maxWidth paragraphStyle:paragraphStyle maxLines:0 font:font];
}
@end
