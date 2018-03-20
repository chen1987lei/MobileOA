//
//  ModelPropertiesManager.h
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelProperty;

/*!
 *  @author renqingyang, 16-11-29 16:29:17
 *
 *  @brief  ModelProperties管理类
 *
 *  @since  9.4.0
 */


@interface ModelPropertiesManager : NSObject

/// 通过modelClass初始化
- (instancetype)initWithModelClass:(Class)modelClass;

/// array映射的字典
@property (nonatomic, copy) NSDictionary *arrayMappingDic;

/// 需要替换的属性字典
@property (nonatomic, copy) NSDictionary *replaceKeyDic;

/// 属性数组
@property (nonatomic, strong) NSMutableArray<ModelProperty *> *propertiesArry;

/// properties中是否存在array的映射
@property (nonatomic, getter = isContainsArrayMapping, assign) BOOL containsArrayMapping;

@end
