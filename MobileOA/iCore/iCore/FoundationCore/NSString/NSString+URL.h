//
//  NSString+URL.h
//  iCore 
//
//  Created by renqingyang on 2017/11/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-11-20  20:08
 *
 *  @brief  string关于URL的处理
 *
 *  @since  1.0
 */
@interface NSString (URL)

#pragma mark - URL编码

// URL整体编码，将URL中的特殊符号都转换成相应16进制符号
// 适合要加载URL前对没有编码的URL进行
// 其中,/?:$@&=+#-_.!~*'()这些符号不会进行编码
+ (NSString *)i_encodeURLWithUTF8:(NSString *)url;

/**
 *  将URL中Query部分中单个参数的值进行编码或者整个串需要全部都被编码
 *  in the URL http://www.example.com/index.php?key1=value1#jumpLink, query的值部分是指value1.
 *  例如：埋点中参数u对应的值为v=3.0&et=transfer&pf=app&reach_id=sms_12312
 *  改部分还有需要编码的符号&，那么使用该方法进行编码，编码结果为：v=3.0%26et=transfer%26pf=app%26reach_id=sms_12312
 *  !!!: 此方法只适合传入Query字符串单个参数的值，如果传入整个url，会导致url被错误编码，无法使用
 */
+ (NSString *)i_encodeQueryValueWithUTF8:(NSString *)queryValue;

// 转换为URL格式的Base64编码
+ (NSString *)i_base64EncodedURLString:(NSString *)url;


#pragma mark - URL解码

// URL解码，将URL中的16进制符号都转换成相应特殊符号
+ (NSString *)i_decodeURLWithUTF8:(NSString *)url;


#pragma mark - URL内容提取

// 获取URL的参数，以字典形式返回
+ (NSDictionary *)i_getQueryComponentWithURL:(NSString *)url;

// 获取URL节点数组
+ (NSArray *)i_getPathComponentsFromURL:(NSString *)url;

#pragma mark - URL拼接

// 根据baseURL和参数拼接好的URL，并且参数部分已经进行了编码处理，该URL是可以直接被加载的，不再需要进行编码处理
+ (NSString *)i_getEncodedURLWithBaseURL:(NSString *)baseURL
                              queryParams:(NSDictionary *)queryDic;

// URL是否有效
+ (BOOL)checkURLIsValid:(NSURL*)url;
@end
