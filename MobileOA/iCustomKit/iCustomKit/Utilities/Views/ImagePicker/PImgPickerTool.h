//
//  PImgPickerTool.h
//  MTCustomKit
//
//  Created by 任清阳 on 2016/8/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 访问权限状态枚举
typedef NS_ENUM(NSUInteger, PE_ImgPickerAuthoritionType) {
    /// 相机授权
    PE_ImgPickerAuthoritionType_Camera = 0,
    /// 相册授权
    PE_ImgPickerAuthoritionType_ImgPicker
};

/// 最终获取到的图片
typedef void (^PImgPickerDidSelectedBlock)(UIImage * _Nullable image);

/// 相机授权回调,该回调只有在授权失败时会返回
typedef void (^PImgPickerAuthoritionBlock)(E_AuthorizationStatus authoritionStatus, PE_ImgPickerAuthoritionType authoritionType);

/*!
 *  @author renqingyang, 16-08-28 17:04:29
 *
 *  @brief  相机、相册选择控件，仅限单张图片处理
 *
 *  @since  1.0
 */


@interface PImgPickerTool : NSObject

kSingleton_h

/*!
 *  @author renqingyang, 16-08-28 17:15:11
 *
 *  @brief 设置基本信息
 *
 *  @param presentVC       设置presentVC
 *  @param infoDictionaryKeyIndex   需要的图片模式,nil为 UIImagePickerControllerEditedImage
 *
UIImagePickerControllerMediaType = 0
UIImagePickerControllerOriginalImage = 1
UIImagePickerControllerEditedImage = 2
UIImagePickerControllerCropRect = 3
UIImagePickerControllerMediaURL = 4
UIImagePickerControllerReferenceURL = 5
UIImagePickerControllerMediaMetadata = 6
UIImagePickerControllerLivePhoto = 7
 *
 *  @param allowsEditing   是否允许编辑
 *
 *  @since 1.0
 */
- (void)i_setPresentDelegateVC:(UIViewController *_Nullable)presentVC
        infoDictionaryKeyIndex:(NSInteger)infoDictionaryKeyIndex
                 allowsEditing:(BOOL)allowsEditing;

/*!
 *  @author renqingyang, 16-08-28 17:15:11
 *
 *  @brief 设置回调
 *
 *  @param selectedBlock           图片选择回调
 *
 *  @since 1.0
 */
- (void)i_imgPickerDidSelectedBlock:(PImgPickerDidSelectedBlock _Nullable )selectedBlock;

/*!
 *  @author renqingyang, 16-08-28 17:15:11
 *
 *  @brief 设置回调
 *
 *  @param authoritionBlock           授权结果回调
 *
 *  @since 1.0
 */
- (void)i_imgPickerAuthoritionResult:(PImgPickerAuthoritionBlock _Nullable )authoritionBlock;

@property (nonatomic, copy) PImgPickerDidSelectedBlock _Nullable selectedBlock;

@property (nonatomic, copy) PImgPickerAuthoritionBlock _Nullable authoritionBlock;

@end
