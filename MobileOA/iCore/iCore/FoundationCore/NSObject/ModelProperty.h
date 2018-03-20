//
//  ModelProperty.h
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/message.h>
#import <objc/runtime.h>

#define sqinline __inline__ __attribute__((always_inline))

/// C类型数据枚举
typedef NS_ENUM(NSInteger, E_ModelPropertyType) {
    /// << 没有
    E_ModelPropertyType_None,
    /// << BOOL
    E_ModelPropertyType_Bool,
    /// << bool
    E_ModelPropertyType_bool,
    /// << int
    E_ModelPropertyType_Int,
    /// << unsiged int
    E_ModelPropertyType_UnsignedInt,
    /// << float
    E_ModelPropertyType_Float,
    /// << double
    E_ModelPropertyType_Double,
    /// << long long
    E_ModelPropertyType_LongLong,
    /// << unsigedLong
    E_ModelPropertyType_UnsignedLong,
    /// <<  UnsignedLongLong
    E_ModelPropertyType_UnsignedLongLong,
    /// << long
    E_ModelPropertyType_Long,
    /// char
    E_ModelPropertyType_Char,
    /// short
    E_ModelPropertyType_Short,
    /// UNKnown
    E_ModelPropertyType_UNKnown
};

/*!
 *  @author renqingyang, 16-11-29 14:43:10
 *
 *  @brief  model属性变量
 *
 *  @since  1.0
 */


@interface ModelProperty : NSObject

/**
 *  @author renqingyang 2016-11-29 14:42:11
 *
 *  @brief 通过运行时属性初始化
 *
 *  @param ivar 属性变量
 *  @param ownerClass 所属模型类
 *
 *  @return 初始化对象
 *
 *  @since 1.0
 */

- (instancetype)initWithIvar:(Ivar)ivar
                  ownerClass:(Class)ownerClass;

/// 所属模型类
@property (nonatomic, readonly, assign) Class ownerClass;

/// 属性名称
@property (nonatomic, readonly, copy) NSString *propertyName;

/// 该属性所对应的class类
@property (nonatomic, readonly, assign) Class propertyClass;

/// 判断是否是一个Model
@property (nonatomic, readonly, getter=isModel, assign) BOOL model;

/// C的属性类型
@property (nonatomic, readonly, assign) E_ModelPropertyType propertyType;

/// 是否有替换的key
@property (nonatomic, getter=isNeedReplaceKey, assign) BOOL needReplaceKey;

/// 替换后的属性名称
@property (nonatomic, strong) NSString *propertyReplaceName;

@end
