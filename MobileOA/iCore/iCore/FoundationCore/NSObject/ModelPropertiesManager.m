//
//  ModelPropertiesManager.m
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "ModelPropertiesManager.h"

#import "NSObject+Model.h"
#import "ModelProperty.h"

@implementation ModelPropertiesManager

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (instancetype)initWithModelClass:(Class)modelClass
{
    if (self = [super init])
    {
        /// 通过检测代理方法判断是否存在array映射
        if ([modelClass respondsToSelector:@selector(i_getArrayMappingDic)])
        {
            /// 存在映射代理
            self.arrayMappingDic = [modelClass i_getArrayMappingDic];
            
            /// 标记状态
            self.containsArrayMapping = YES;
        }
        
        /// 通过检测代理方法判断是否存在替换key映射
        if ([modelClass respondsToSelector:@selector(i_getReplaceKeyDic)])
        {
            /// 存在映射代理
            self.replaceKeyDic = [modelClass i_getReplaceKeyDic];
        }
        
        self.propertiesArry = [NSMutableArray new];
        
        // 解析类不为空
        while (modelClass != nil)
        {
            // 如果是基本类型，不再向下一层遍历
            if ([modelClass isFounationClass])
            {
                break;
            }

            // 解析property
            [self doMappingWithClass:modelClass];
            
            modelClass = class_getSuperclass(modelClass);
        }
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************
// mapping
- (void)doMappingWithClass:(Class)mappingClass
{
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(mappingClass, &ivarCount);
    
    /// 遍历变量数组
    for (int i = 0; i < ivarCount; i++)
    {
        /// 获取变量
        Ivar ivar = ivars[i];
        
        /// 属性变量模型
        ModelProperty *property = [[ModelProperty alloc] initWithIvar:ivar
                                                               ownerClass:mappingClass];
        
        if (self.replaceKeyDic)
        {
            NSString *replaceName = self.replaceKeyDic[property.propertyName];
            
            /// 存在替换名称
            if (replaceName)
            {
                property.needReplaceKey = YES;
                property.propertyReplaceName = replaceName;
            }
        }
        
        /// 添加属性对象到数组
        [self.propertiesArry addObject:property];
    }
    
    /// 记得释放
    free(ivars);
}
#pragma mark - ******************************Public Method******************************************

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

@end
