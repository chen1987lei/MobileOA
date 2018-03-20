//
//  NSObject+Model.h
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN int32_t const kModel_IntType_Max_Number;

/// 归档使用的宏
#define Code                                           \
-(instancetype) initWithCoder : (NSCoder *)decoder \
{                                                    \
if (self = [super init])                         \
{                                                \
[self i_modelDecode:decoder];              \
}                                                \
return self;                                     \
}                                                    \
-(void) encodeWithCoder : (NSCoder *)encoder         \
{                                                    \
[self i_modelEncode:encoder];                    \
}

@protocol ModelDelegate <NSObject>

@optional

/// 获取数组类型变量映射字典，属性name为key，映射类为value
+ (NSDictionary *)i_getArrayMappingDic;

/// 本地model所要替换的服务器的key,属性name为key，服务端key为value
+ (NSDictionary *)i_getReplaceKeyDic;

/// 校验参数赋值情况，使用在服务器端参数赋值之后
- (void)i_doSelfHandlerAfterMaping;

@end


@interface NSObject (Model) <ModelDelegate>

/**
 *  @author renqingyang 将json数据转换成模型
 *
 *  @brief 可接受数据类型: NSDictionary、NSString、NSData
 *
 *  @param json 需要解析的对象
 *
 *  @return 实例化对象
 *
 *  @since 1.0
 */

+ (instancetype)i_initModelWithJSON:(id)json;

/**
 *  @author renqingyang 将NSDictionary字典转换成模型
 *
 *  @brief 可接受数据类型: NSDictionary
 *
 *  @param dic 需要解析的对象
 *
 *  @return 实例化对象
 *
 *  @since 1.0
 */

+ (instancetype)i_initModelWithDictionary:(NSDictionary *)dic;

/**
 *  @author renqingyang 字典转模型,对model进行赋值
 *
 *  @brief 通过字典获取model对象
 *
 *  @param jsonDic  需要解析的对象
 *
 *  @since 1.0
 */

- (void)i_getModelObjectWithDictJson:(NSDictionary *)jsonDic;

/**
 *  @author renqingyang 数组转模型,对数组model进行赋值
 *
 *  @brief 通过数组获取model对象
 *
 *  @param arrayJson 需要解析的对象
 *
 *  @return NSArray
 *
 *  @since 1.0
 */

- (NSArray *)i_getModelObjectsWithArrayJson:(NSArray *)arrayJson;

/**
 *  @author renqingyang
 *
 *  @brief model转字典
 *
 *  @return dic
 *
 *  @since 1.0
 */

- (NSMutableDictionary *)i_getJsonDictWithModelObject;

/// 检测是不是框架的类型  no is model  yse is Foundation
- (BOOL)isFounationClass;


/// 编码
- (void)i_modelEncode:(NSCoder *)encode;
/// 解码
- (void)i_modelDecode:(NSCoder *)decode;
@end
