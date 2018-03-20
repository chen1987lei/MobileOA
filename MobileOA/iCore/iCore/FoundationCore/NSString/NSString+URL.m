//
//  NSString+URL.m
//  iCore 
//
//  Created by renqingyang on 2017/11/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSString+URL.h"

#import "Macro_NSString.h"
#import "Macro_NSObject.h"
// Url规则校验，标准Url格式
static NSString *const URLPattern=@"^([\\w-_]+\\:\\/)?\\/([\\w-_]+\\/)+[\\w-_]+(\\?([\\w-_]+\\=[\\w-_]+\\&)*[\\w-_]+\\=[\\w-_]+)?$";

static NSString * const kURLslash=@"/";

@implementation NSString (URL)

#pragma mark - URL编码

// URL编码，将url中的特殊符号都转换成相应16进制符号
+ (NSString *)i_encodeURLWithUTF8:(NSString *)url
{
    if (kString_Is_Valid(url))
    {
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];

        NSString *escapedString = [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

        return escapedString;
    }
    else
    {
        return @"";
    }
}

/**
 *  将URL中Query部分中单个参数的值进行编码或者整个串需要全部都被编码
 *  in the URL http://www.example.com/index.php?key1=value1#jumpLink, query的值部分是指value1.
 *  例如：埋点中参数u对应的值为v=3.0&et=transfer&pf=app&reach_id=sms_12312
 *  改部分还有需要编码的符号&，那么使用该方法进行编码，编码结果为：v=3.0%26et=transfer%26pf=app%26reach_id=sms_12312
 *  !!!: 此方法只适合传入Query字符串单个参数的值，如果传入整个url，会导致url被错误编码，无法使用
 */
+ (NSString *)i_encodeQueryValueWithUTF8:(NSString *)queryValue
{
    if (kString_Is_Valid(queryValue))
    {
        NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];

        NSString *outString = [queryValue stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

        return outString;
    }
    else
    {
        return @"";
    }
}

/// 转换为url格式的Base64编码
+ (NSString *)i_base64EncodedURLString:(NSString *)url
{
    if (kString_Is_Valid(url))
    {
        NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
        NSString *stringEncoded = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        stringEncoded = [stringEncoded stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        stringEncoded = [stringEncoded stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        stringEncoded = [stringEncoded stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];

        return stringEncoded;
    }
    else
    {
        return @"";
    }
}


#pragma mark - URL解码

/// URL解码，将url中的16进制符号都转换成相应特殊符号
+ (NSString *)i_decodeURLWithUTF8:(NSString *)url
{
    if (kString_Is_Valid(url))
    {
        NSMutableString *outString = [NSMutableString stringWithString:url];
        [outString replaceOccurrencesOfString:@"+"
                                      withString:@" "
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [outString length])];

        return [outString stringByRemovingPercentEncoding];
    }
    else
    {
        return @"";
    }
}


#pragma mark - URL内容提取

/// 通过URL字符串获取带的参数
+ (NSDictionary *)i_getQueryComponentWithURL:(NSString *)url
{
    NSURLComponents *urlComp = [NSURLComponents componentsWithString:url];

    /// 若urlComp不为空，说明传入的是一个有效的url
    if (urlComp != nil)
    {
        NSArray<NSURLQueryItem *> *querysArray = [urlComp queryItems];

        if (!querysArray.count)
        {
            return nil;
        }
        else
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            for (NSURLQueryItem *queryItem in querysArray)
            {
                [dic setObject:queryItem.value forKey:queryItem.name];
            }

            return dic;
        }
    }

    return nil;
}

#pragma mark - 获取URL节点数组

+ (NSArray *)i_getPathComponentsFromURL:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];

    NSMutableArray *pathComponents = [NSMutableArray array];

    /// 若urlComp不为空，说明传入的是一个有效的url
    if ([NSString checkURLIsValid:URL])
    {
        [[URL pathComponents] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![kURLslash isEqualToString:obj]) {
                [pathComponents addObject:obj];
            }
        }];

        return pathComponents;
    }

    return nil;
}

#pragma mark - URL拼接

/// 根据baseURL和参数拼接好的URL，并且参数部分已经进行了编码处理，该URL是可以直接被加载的，不再需要进行编码处理
+ (NSString *)i_getEncodedURLWithBaseURL:(NSString *)baseURL
                              queryParams:(NSDictionary *)queryDic;
{
    NSURLComponents *urlComonents = [[NSURLComponents alloc] initWithString:baseURL];
    /// 当 base URL 无效时不再进行后续处理，直接返回nil
    if (urlComonents == nil)
    {
        return nil;
    }

    NSMutableArray<NSURLQueryItem *> *queryItemsArray = [NSMutableArray array];

    /// 将参数转换为URL的Query部分
    for (NSString *key in queryDic.allKeys)
    {
        NSString *value = [queryDic objectForKey:key];

        if (kString_Not_Valid(value))
        {
            continue;
        }
        else
        {
            NSString *valueEncode = [self i_encodeQueryValueWithUTF8:value];

            NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key
                                                                  value:valueEncode];
            [queryItemsArray addObject:item];
        }
    }

    /// Query数组有效时才进行设置
    if (queryItemsArray.count)
    {
        [urlComonents setQueryItems:[queryItemsArray copy]];
    }

    NSString *url = [urlComonents string];

    return url;
}
#pragma mark - URL是否有效
+ (BOOL)checkURLIsValid:(NSURL*)url
{
    if (kString_Not_Valid(url.absoluteString))
    {
        return NO;
    }

    NSError *err;

    NSRegularExpression * patternEx = [NSRegularExpression regularExpressionWithPattern:URLPattern
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&err];

    if (kObject_Is_Null(err))
    {
        NSString *matchStr = url.absoluteString;

        if ([patternEx firstMatchInString:matchStr options:0 range:NSMakeRange(0, matchStr.length)])
        {
            return YES;
        }
    }
    return NO;
}
@end
