//
//  Macro_NetWorkEnum.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/13.

//

#ifndef Macro_NetWorkEnum_h
#define Macro_NetWorkEnum_h

#pragma mark - 请求Http数据类型

typedef NS_ENUM(NSInteger, E_RequestDataType)
{
    // 请求数据类型，normal类型
    E_RequestDataType_Normal,
    // 请求数据类型，multipart类型，适用于上传图片和文件等多媒体操作
    E_RequestDataType_Multipart,
};

#pragma mark - 请求方法类型

typedef NS_ENUM(NSInteger, E_RequestMethodType)
{
    E_RequestMethodType_Get = 0,
    E_RequestMethodType_Patch,
    E_RequestMethodType_Post,
    E_RequestMethodType_Put,
    E_RequestMethodType_Delete,
    E_RequestMethodType_PostFile,
};

#pragma mark - 请求数据序列化类型

typedef NS_ENUM(NSInteger, E_RequestSerializerType)
{
    E_RequestSerializerType_HTTP = 0,
    E_RequestSerializerType_Json,
};

#pragma mark - 响应数据序列化类型

typedef NS_ENUM(NSInteger, E_ResponseSerializerType)
{
    E_ResponseSerializerType_HTTP = 0,
    E_ResponseSerializerType_Json,
};

typedef NS_ENUM(NSInteger, E_ServerCodeStatus)
{
    // success
    E_ServerCodeSuccess = 1,
};

typedef NS_ENUM(NSInteger, E_NewtworkType)
{
    E_NewtworkTypeNone = 0, // No wifi or cellular
    E_NewtworkType2G,
    E_NewtworkType3G,
    E_NewtworkType4G,
    E_NewtworkTypeLTE,
    E_NewtworkTypeWifi,
};

typedef NS_ENUM(NSInteger, E_MediaType)
{
    E_MediaTypeNone, //未知类型
    E_MediaTypeImage, //图片类型
    E_MediaTypeAudio, //音频类型
    E_MediaTypeVideo, //视频类型
};

#endif /* Macro_NetWorkEnum_h */
