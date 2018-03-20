//
//  NSObject+Model.m
//  iCore 
//
//  Created by renqingyang on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSObject+Model.h"

#import "ModelProperty.h"
#import "ModelPropertiesManager.h"

int32_t const kModel_IntType_Max_Number = INT32_MAX;

#pragma mark - 通过PropertyName获取字典中所对应的value

static id propertyKey(ModelProperty *property, id dict)
{
    id value = nil;
    
    // 获取属性所对应的key
    NSString *key = property.propertyName;
    
    // 是否存在替换key
    if (property.needReplaceKey)
    {
        key = property.propertyReplaceName;
    }
    
    // 从字典中取值
    value = dict[key];
    
    return value;
}


@implementation NSObject (Model)

#pragma mark - 字典转模型,返回一个实例化对象

+ (instancetype)i_initModelWithJSON:(id)json
{
    // 将数据解析成字典
    NSDictionary *jsonDic = [self i_dictoryWithJSON:json];
    // 将字典解析成模型
    return [self i_initModelWithDictionary:jsonDic];
}

/**
 *  将json数据解析成字典
 *  可接受类型：NSDictionary、NSString、NSData
 
 *  nil: 指向一个       (实例)对象           的空指针
 *  Nil: 指向一个           类              的空指针
 *  NULL: 指向  其它类型(基本数据类型、C类型)  的空指针
 *  NSNull: 数组中元素的占位符，数组中的元素不能为nil，但是可以为空即NSNull
 *  kCFNull: NSNull的单例
 
 typedef const struct CF_BRIDGED_TYPE(NSNull) __CFNull * CFNullRef;
 
 CF_EXPORT
 CFTypeID CFNullGetTypeID(void);
 
 CF_EXPORT
 const CFNullRef kCFNull;
 
 所以: NSNull *null = (id)kCFnull 与 NSNull *null = [NSNull null]
 */

+ (NSDictionary *)i_dictoryWithJSON:(id)json
{
    // 检查输入合法性
    if (!json || json == (id) kCFNull)
        return nil;
    // jsonDic 存储转换完成后的字典、jsonData 如果输入的json是NSString类，则需要先转换成NSData
    NSDictionary *jsonDic = nil;
    NSData *jsonData = nil;
    // 如果输入的json是字典，则无需经过转换
    if ([json isKindOfClass:[NSDictionary class]])
    {
        jsonDic = json;
    }
    else if ([json isKindOfClass:[NSString class]])
    {
        // 如果输入的是json字符串，则需要先转换成NSData,在调用系统方法转换成NSDictionary
        jsonData = [(NSString *) json dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([json isKindOfClass:[NSData class]])
    {
        // 如果输入的是json的二进制，则可以直接存储，用于转换
        jsonData = json;
    }
    if (jsonData)
    {
        // 如果json二进制存在的话需要将此二进制转换成NSDictionary
        jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        // 检查转换是否成功
        if (![jsonDic isKindOfClass:[NSDictionary class]])
        {
            jsonDic = nil;
        }
    }
    return jsonDic;
}

#pragma mark - 字典转模型,返回一个实例化对象

+ (instancetype)i_initModelWithDictionary:(NSDictionary *)aDic
{
    // 检查输入合法性
    if (!aDic || aDic == (id) kCFNull)
        return nil;
    if (![aDic isKindOfClass:[NSDictionary class]])
        return nil;
    
    id self_ = [[self alloc] init];
    
    [self_ i_getModelObjectWithDictJson:aDic];
    
    return self_;
}

#pragma mark - 字典转模型,对model进行赋值

- (void)i_getModelObjectWithDictJson:(NSDictionary *)dic
{
    [self objctKeyValue:dic];
}

#pragma mark - model 数组转模型 ,对数组model进行赋值

- (NSArray *)i_getModelObjectsWithArrayJson:(NSArray *)array;
{
    if ([self isFounationClass])
        return nil;
    
    @try
    {
        Class modelClass = [self class];
        
        return objectValuesFromArray(array, modelClass);
    }
    @catch (NSException *exception)
    {
        NSLog(@"MTModelRen is error %@", exception);
    }
}

#pragma mark - 强转string类型为number

static  id numberValueFromStringValue(NSString *value){

    static NSDictionary *valueKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        valueKeys = @{
                      @"1"   :@YES,
                      @"YES" :@YES,
                      @"yes" :@YES,
                      @"TRUE":@YES,
                      @"true":@YES,
                      @"FALSE":@NO,
                      @"false":@NO,
                      @"NO" :@NO,
                      @"no" :@NO,
                      @"No" :@NO,
                      @"0"  :@NO,
                      };
    });

    if ([valueKeys.allKeys containsObject:value])return valueKeys[value];
    return value;
}

#pragma mark - model的属性key字典

// 缓存属性key字段
static NSMutableDictionary *_propertyKeysDic = nil;

- (ModelPropertiesManager *)propertiesManager
{
    Class modelClass = self.class;
    
    // 保证只创建一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _propertyKeysDic = [NSMutableDictionary dictionary];
    });
    
    // 添加线程安全
    @synchronized(_propertyKeysDic)
    {
        // 获取模型对象属性管理类
        ModelPropertiesManager *propertiesManager = _propertyKeysDic[NSStringFromClass(modelClass)];
        
        // 缓存中没有对应属性数组
        if (propertiesManager == nil)
        {
            propertiesManager = [[ModelPropertiesManager alloc] initWithModelClass:modelClass];
            
            _propertyKeysDic[NSStringFromClass(modelClass)] = propertiesManager;
        }
        
        return propertiesManager;
    }
}

#pragma mark - 对value为array类型的做序列化处理

static NSMutableArray *objectValuesFromArray(NSArray *array, Class modelClass)
{
    if (array == nil)
        return nil;
    
    NSMutableArray *mArrayModels = [NSMutableArray new];
    
    for (id dict in array)
    {
        if (![dict isKindOfClass:[NSDictionary class]])
            break;
        
        // 初始化映射model类
        id model = [modelClass i_initModelWithDictionary:dict];
        
        [mArrayModels addObject:model];
    }
    return mArrayModels.count ? mArrayModels : nil;
}

#pragma mark - 解析字典，给model属性赋值

static void objectValueFromDict(id self, id dict)
{
    ModelPropertiesManager *propertiesManager = [self propertiesManager];
    
    // 变量属性数组
    [propertiesManager.propertiesArry enumerateObjectsUsingBlock:^(ModelProperty *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        // 为内存优化考虑
        @autoreleasepool
        {
            // 属性名称为key
            NSString *key = obj.propertyName;
            
            // 获取属性类
            Class propertyClass = obj.propertyClass;
            
            // 从服务器返回字段中取值取值
            id value = propertyKey(obj, dict);
            
            if (value == nil || value == [NSNull null])
            {
                /*
                 * 此处可以做默认值处理
                 */
                // 属性类为NSString 做默认值处理
                if ([propertyClass isSubclassOfClass:[NSString class]])
                {
                    [self setValue:@"" forKey:key];
                }
                // 初始化为最大值(为了防止枚举类型数据初始值为0问题，枚举类型赋值为kModel_IntType_Max_Number便于定位问题)
                else if ((obj.propertyType == E_ModelPropertyType_Int)
                         || (obj.propertyType == E_ModelPropertyType_UnsignedInt)
                         || (obj.propertyType == E_ModelPropertyType_LongLong)
                         || (obj.propertyType == E_ModelPropertyType_UnsignedLongLong))
                {
                    [self setValue:@(kModel_IntType_Max_Number) forKey:key];
                }
                else
                {
                }
                
                return;
            }
            
            // 如果是一个classProperty
            if (propertyClass)
            {
                // 是模型类型
                if (obj.model)
                {
                    // 如果是存在下一层字典解析，
                    if ([value isKindOfClass:[NSDictionary class]])
                    {
                        id obj = [propertyClass new];
                        // 解析下一层级
                        [obj objctKeyValue:value];
                        
                        value = obj;
                    }
                }
                else
                {
                    // 如果property是字符串类型
                    if ([propertyClass isSubclassOfClass:[NSString class]])
                    {
                        // 如果返回value类型为url和number，客户端要进行强转
                        if ([value isKindOfClass:[NSURL class]])
                        {
                            // NSURL
                            NSURL *urlStirngValue = (NSURL *)value;
                            value = urlStirngValue.absoluteString;
                        }
                        else if ([value isKindOfClass:[NSNumber class]])
                        {
                            // NSNumber
                            NSNumber *numberValue = value;
                            value = numberValue.description;
                        }
                    }
                    // 如果property是NSURL类型
                    else if (propertyClass == [NSURL class])
                    {
                        // 如果返回value类型为NSString
                        if ([value isKindOfClass:[NSString class]])
                        {
                            value = [NSURL URLWithString:value];
                        }
                    }
                    // 如果是数组类型
                    else if(propertyClass==[NSArray class]||
                            propertyClass==[NSMutableArray class])
                    {
                        // 如果属性管理类中存在数组模型映射
                        if (propertiesManager.containsArrayMapping)
                        {
                            // 用于获取数组中存放的对象类型
                            Class modelClass = propertiesManager.arrayMappingDic[key];

                            if (modelClass)
                            {
                                NSMutableArray *classesArray = objectValuesFromArray(value, modelClass);

                                value = !classesArray ? value : classesArray;
                            }
                        }
                    }
                }
            }
            // 如果是C的数据类型做number处理
            else
            {
                // 如果value是NSString类型对BOOL,bool,int类型做强转处理
                if ([value isKindOfClass:[NSString class]])
                {
                    if (obj.propertyType&E_ModelPropertyType_Bool ||
                         obj.propertyType&E_ModelPropertyType_bool ||
                         obj.propertyType&E_ModelPropertyType_Int)
                    {
                        value = numberValueFromStringValue(value);
                    }
                    else
                    {
                        static NSNumberFormatter *numberFormatter =  nil;
                        numberFormatter = [NSNumberFormatter new];
                        value =  [numberFormatter numberFromString:value];
                    }
                }
                else
                {

                }
            }
            
            // 如果服务器返回的类型和本地声明类型不匹配，做为空处理
            if (propertyClass && ![value isKindOfClass:propertyClass])
            {
                value = nil;
            }
            
            [self setValue:value forKey:key];
        }
    }];
    
    // 通过方法名获取方法SEL
    SEL selector = NSSelectorFromString(@"i_doSelfHandlerAfterMaping");
    
    // 检查是否存在 i_doSelfHandlerAfterMaping 方法
    if ([self respondsToSelector:selector])
    {
        IMP imp = [self methodForSelector:selector];
        
        if (imp)
        {
            void (*func)(id, SEL) = (void *) imp;
            func(self, selector);
        }
    }
}
#pragma mark - 执行set

- (void)objctKeyValue:(id)dict
{
    NSAssert([[dict class] isSubclassOfClass:[NSDictionary class]], @"不是字典");
    
    if ([self isFounationClass])
        return;
    @try
    {
        objectValueFromDict(self, dict);
    }
    @catch (NSException *exception)
    {
        NSLog(@"model键值对错误异常 %@", exception);
    }
}

#pragma mark - model 转字典对外方法

- (NSMutableDictionary *)i_getJsonDictWithModelObject
{
    if ([self isFounationClass])
        return nil;
    
    @try
    {
        return jsonObjectFormModelObject(self);
    }
    @catch (NSException *exception)
    {
        NSLog(@"Model is error %@", exception);

        return nil;
    }
}

#pragma mark - model转字典

#pragma mark - model结构类转换为json类型

static NSMutableDictionary *jsonObjectFormModelObject(id self)
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    /// 获取model属性管理类
    ModelPropertiesManager *propertiesManager = [self propertiesManager];

    /// 变量属性数组
    for (ModelProperty *property in propertiesManager.propertiesArry)
    {
        __block NSString *key = property.propertyName;

        /// 获取属性所对应的value
        id value = [self valueForKey:key];

        if (value == nil || value == [NSNull null])
        {
            continue;
        }

        if ([value isKindOfClass:[NSDate class]])
        {
            value = ((NSDate *) value).description;
        }
        /// 如果是字典类型，向下一级解析
        else if ([value isKindOfClass:[NSDictionary class]] ||
                 [value isKindOfClass:[NSMutableDictionary class]])
        {
            value = [NSMutableDictionary dictionaryWithDictionary:value];

            NSMutableDictionary *superDict = [NSMutableDictionary new];

            [(NSMutableDictionary *) value enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
                /// 如果不是基本类型
                if (![obj isFounationClass])
                {
                    id json = [obj i_getJsonDictWithModelObject];

                    if (json)
                    {
                        superDict[key] = json;
                    }
                }
                else
                {
                    *stop = YES;
                }
            }];

            if (superDict.count)
            {
                value = superDict;
            }
        }
        else if ([value isKindOfClass:[NSArray class]] ||
                 [value isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *models = i_getJsonDicFormArrayObjects(value);

            if (models)
            {
                value = models;
            }
        }
        else
        {
            //模型类型
            if (property.isModel)
            {
                value = [value i_getJsonDictWithModelObject];
            }
        }

        if (value)
        {
            dict[key] = value;
        }
    }
    return dict;
}

#pragma mark - 数组结构类转换为json类型

static NSMutableArray *i_getJsonDicFormArrayObjects(NSArray *objs)
{
    NSMutableArray *jsons = [NSMutableArray new];
    
    for (id model in objs)
    {
        if ([model isFounationClass])
        {
            break;
        }
        
        NSMutableDictionary *dict = [model i_getJsonDictWithModelObject];
        
        [jsons addObject:dict];
    }
    return jsons.count ? jsons : nil;
}

#pragma mark - 检测是不是框架的类型  no is model  yse is Foundation

- (BOOL)isFounationClass
{
    static NSArray *classes = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        classes = @[ [NSString class],
                     [NSMutableString class],
                     [NSMutableArray class],
                     [NSArray class],
                     [NSMutableDictionary class],
                     [NSDictionary class],
                     [NSMutableSet class],
                     [NSSet class],
                     [NSNumber class],
                     [NSURL class],
                     [NSData class],
                     [NSMutableData class],
                     [NSDate class] ];
    });
    
    return [classes containsObject:self.class];
}

// 编码
- (void)i_modelEncode:(NSCoder *)encode
{
    for (ModelProperty *property in [self propertiesManager].propertiesArry)
    {
        NSString *key = property.propertyName;
        
        id value = [self valueForKey:key];
        
        if (value != nil)
        {
            [encode encodeObject:value forKey:key];
        }
    }
}
// 解码
- (void)i_modelDecode:(NSCoder *)decode
{
    for (ModelProperty *property in [self propertiesManager].propertiesArry)
    {
        NSString *key = property.propertyName;
        
        id value = [decode decodeObjectForKey:key];
        
        if (value != nil)
        {
            [self setValue:value forKey:key];
        }
    }
}

#pragma mark - 键值编码异常保证程序不崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end

