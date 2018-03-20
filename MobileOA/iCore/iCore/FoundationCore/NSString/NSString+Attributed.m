//
//  NSString+Attributed.m
//  iCore 
//
//  Created by renqingyang on 2017/12/15.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSString+Attributed.h"

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "NSMutableString+TagReplace.h"

NSString* kAttributedMarkupLinkName = @"AttributedMarkupLinkName";

@implementation NSString (Attributed)

- (NSAttributedString *)i_attributedStringWithStyleDic:(NSDictionary *)configDic
{
    /// 查找字符串中每个字符的位置
    NSMutableArray *tags = [NSMutableArray array];

    NSMutableString *mSelf = [self mutableCopy];
    // 过滤标签字符串，替换标签为空
//    [mSelf replaceOccurrencesOfString:@"<br>"
//                               withString:@"\n"
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, mSelf.length)];
//    [mSelf replaceOccurrencesOfString:@"<br />"
//                               withString:@"\n"
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, mSelf.length)];

    [mSelf i_replaceAllTagsIntoArray:tags];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mSelf];

    // Setup base attributes
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}
                         range:NSMakeRange(0, [attributedString length])];

    /// 判断主标签，默认body为最外层标签
    NSObject *objectBodyStyle = configDic[@"body"];

    if (objectBodyStyle)
    {
        [self styleAttributedString:attributedString
                              range:NSMakeRange(0, attributedString.length)
                          withStyle:objectBodyStyle
                      withStyleBook:configDic];
    }

    for (NSDictionary *dicTag in tags)
    {
        /// 读取每一段字符串的标签数组，数组包括标签名称，字符串开始位置，字符串结束位置
        NSString *stringTag = dicTag[@"tag"];
        NSNumber *numberLocation = dicTag[@"loc"];
        NSNumber *numberendLoc = dicTag[@"endloc"];
        if (numberLocation != nil && numberendLoc != nil)
        {
            NSRange range = NSMakeRange([numberLocation integerValue],
                                        [numberendLoc integerValue] - [numberLocation integerValue]);
            NSObject *objectStyle = configDic[stringTag];
            if (objectStyle)
            {
                /// 设置该段字符串的富文本格式
                [self styleAttributedString:attributedString
                                      range:range
                                  withStyle:objectStyle
                              withStyleBook:configDic];
            }
        }
    }

    return attributedString;
}

- (void)styleAttributedString:(NSMutableAttributedString*)aMAttrString range:(NSRange)range withStyle:(NSObject*)style withStyleBook:(NSDictionary*)styleBook
{
    if ([style isKindOfClass:[NSArray class]]) {
        for (NSObject* subStyle in (NSArray*)style) {
            [self styleAttributedString:aMAttrString range:range withStyle:subStyle withStyleBook:styleBook];
        }
    }
    else if ([style isKindOfClass:[NSDictionary class]]) {
        [self setStyle:(NSDictionary*)style range:range onAttributedString:aMAttrString];
    }
    else if ([style isKindOfClass:[UIFont class]]) {
        [self setFont:(UIFont*)style range:range onAttributedString:aMAttrString];
    }
    else if ([style isKindOfClass:[UIColor class]]) {
        if([styleBook objectForKey:@"backGroundColor"]){
            UIColor *color = styleBook[@"backGroundColor"];
            if ([color isEqual:style]) {
                [self setBackGroundColor:(UIColor*)style range:range onAttributedString:aMAttrString];
            }
            else
                [self setTextColor:(UIColor*)style range:range onAttributedString:aMAttrString];
        }
        else
            [self setTextColor:(UIColor*)style range:range onAttributedString:aMAttrString];

    } else if ([style isKindOfClass:[NSURL class]]) {
        [self setLink:(NSURL*)style range:range onAttributedString:aMAttrString];
    } else if ([style isKindOfClass:[NSString class]]) {
        [self styleAttributedString:aMAttrString range:range withStyle:styleBook[(NSString*)style] withStyleBook:styleBook];
    } else if ([style isKindOfClass:[UIImage class]]) {
#warning 图片类型的解析
    }
}

-(void)setStyle:(NSDictionary*)style range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    for (NSString* key in [style allKeys]) {
        [self setTextStyle:key withValue:style[key] range:range onAttributedString:as];
    }
}

-(void)setFont:(UIFont*)font range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [self setFontName:font.fontName size:font.pointSize range:range onAttributedString:as];
}


-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTFontAttributeName
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)fontName, size, NULL);
    if (aFont)
    {
        [as removeAttribute:(__bridge NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
        [as addAttribute:(__bridge NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
        CFRelease(aFont);
    }
}

-(void)setTextColor:(UIColor*)color range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTForegroundColorAttributeName
    [as removeAttribute:NSForegroundColorAttributeName range:range];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
}
-(void)setBackGroundColor:(UIColor*)color range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kNSBackgroundColorAttributeName
    [as removeAttribute:NSBackgroundColorAttributeName range:range];
    [as addAttribute:NSBackgroundColorAttributeName value:color range:range];
}
-(void)setTextStyle:(NSString*)styleName withValue:(NSObject*)value range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:styleName range:range]; // Work around for Apple leak
    [as addAttribute:styleName value:value range:range];
}

-(void)setLink:(NSURL*)url range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:kAttributedMarkupLinkName range:range]; // Work around for Apple leak
    if (&link)
    {
        [as addAttribute:kAttributedMarkupLinkName value:[url absoluteString] range:range];
    }
}

@end
