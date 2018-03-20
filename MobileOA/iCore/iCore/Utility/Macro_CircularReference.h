//
//  Macro_CircularReference.h
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_CircularReference_h
#define Macro_CircularReference_h

#pragma mark - ******************************************* self 强弱引用转换宏定义 *********************

#define kWeakifySelf kWeakifyObject(self)
#define kStrongifySelf kStrongifyObject(self)


#pragma mark - ******************************************* object 强弱引用转换宏定义 *******************

#define kWeakifyObject(object) @kWeakify(object)
#define kStrongifyObject(object) @kStrongify(object)


#pragma mark - ******************************************* 使用Demo *********************************

/**
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `kWeakifyObject(object)`实现弱引用转换，`kStrongifyObject(object)`实现强引用转换
 * 使用时不要忘记添加非空判断保护。
 *
 * 示例：
 * kWeakifyObject(object)
 * [obj block:^{
 * kStrongifyObject(object)
 * if (object)
 * {
 *      object = something;
 * }
 * }];
 */


#pragma mark - ******************************************* 具体定义 **********************************

#ifndef kWeakify
#if __has_feature(objc_arc)
#define kWeakify(object) \
autoreleasepool        \
{                      \
}                      \
__weak __typeof__(object) weak##_##object = object;
#else
#define kWeakify(object) \
autoreleasepool        \
{                      \
}                      \
__block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define kWeakify(object) \
try                    \
{                      \
}                      \
@finally               \
{                      \
}                      \
{                      \
}                      \
__weak __typeof__(object) weak##_##object = object;
#else
#define kWeakify(object) \
try                    \
{                      \
}                      \
@finally               \
{                      \
}                      \
{                      \
}                      \
__block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef kStrongify
#if __has_feature(objc_arc)
#define kStrongify(object) \
autoreleasepool          \
{                        \
}                        \
__typeof__(object) object = weak##_##object;
#else
#define kStrongify(object) \
autoreleasepool          \
{                        \
}                        \
__typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define kStrongify(object) \
try                      \
{                        \
}                        \
@finally                 \
{                        \
}                        \
__typeof__(object) object = weak##_##object;
#else
#define kStrongify(object) \
try                      \
{                        \
}                        \
@finally                 \
{                        \
}                        \
__typeof__(object) object = block##_##object;
#endif
#endif

#endif /* Macro_CircularReference_h */
