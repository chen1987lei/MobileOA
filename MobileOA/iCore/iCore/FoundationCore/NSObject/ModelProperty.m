//
//  ModelProperty.m
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "ModelProperty.h"

#import "NSObject+Model.h"

#define sqinline __inline__ __attribute__((always_inline))

static inline E_ModelPropertyType propertyType(const char *type)
{
    E_ModelPropertyType tempPropertyType;
    switch (*type)
    {
        case 'i':
            tempPropertyType = E_ModelPropertyType_Int;
            break;
        case 'I':
            tempPropertyType = E_ModelPropertyType_UnsignedInt;
            break;
        case 'b':
            tempPropertyType = E_ModelPropertyType_Bool;
            break;
        case 'B':
            tempPropertyType = E_ModelPropertyType_bool;
            break;
        case 's':
            tempPropertyType = E_ModelPropertyType_Short;
            break;
        case 'c':
            tempPropertyType = E_ModelPropertyType_Char;
            break;
        case 'l':
            tempPropertyType = E_ModelPropertyType_Long;
            break;
        case 'f':
            tempPropertyType = E_ModelPropertyType_Float;
            break;
        case 'd':
            tempPropertyType = E_ModelPropertyType_Double;
            break;
        case 'q':
            tempPropertyType = E_ModelPropertyType_LongLong;
            break;
        case 'L':
            tempPropertyType = E_ModelPropertyType_UnsignedLong;
            break;
        case 'Q':
            tempPropertyType = E_ModelPropertyType_UnsignedLongLong;
            break;
        default:
        {
            tempPropertyType = E_ModelPropertyType_UNKnown;
        }
            break;
    }
    
    return tempPropertyType;
}

@implementation ModelProperty

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (instancetype)initWithIvar:(Ivar)ivar ownerClass:(Class)ownerClass
{
    self = [super init];
    if (self)
    {
        _ownerClass = ownerClass;
        
        const char *charType = ivar_getTypeEncoding(ivar);
        
        ///属性类型
        NSMutableString *propertyCode = [NSMutableString stringWithUTF8String:charType];
        
        ///对象类型
        if ([propertyCode hasPrefix:@"@"])
        {
            /// 获取属性类名
            NSString *type = [propertyCode substringWithRange:NSMakeRange(2, propertyCode.length - 3)];
            
            _propertyClass = NSClassFromString(type);
            
            _model = ![_propertyClass isFounationClass];
        }
        else
        {
            /// C的属性类型
            _propertyType = propertyType(charType);
        }
        
        /// 属性名字
        NSMutableString *key = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        
        /// 过滤@字符,对于@synthesize属性变量，需要去掉@synthesize，否则会crash
        [key replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
        _propertyName = [key copy];
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

#pragma mark - ******************************Public Method******************************************

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

@end
