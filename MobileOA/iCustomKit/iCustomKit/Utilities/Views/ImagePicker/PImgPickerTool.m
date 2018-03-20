//
//  PImgPickerTool.m
//  MTCustomKit
//
//  Created by 任清阳 on 2016/8/29.
//
//

#import "PImgPickerTool.h"

@interface PImgPickerTool () <UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            UIActionSheetDelegate>
{
    UIImagePickerController *_picker;
}

/// 设置图片资源类型
@property (copy, nonatomic) NSString *imgPickerType;

/// 当前跳转VC
@property (weak, nonatomic) id presentVC;

/// 图片模式
@property (assign, nonatomic) NSInteger infoDictionaryKeyIndex;

/// 是否允许编辑
@property (nonatomic, assign, getter=isAllowsEditing) BOOL allowsEditing;
@end

@implementation PImgPickerTool

kSingleton_m(PImgPickerTool)

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];

    if (self)
    {

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

#pragma mark - 打开相机

- (void)openCamera
{
    [[DeviceAuthorizationManager shared] i_requestCameraAuthorization:^(E_AuthorizationStatus status) {
        switch (status)
        {
            case E_AuthorizationStatus_Authorized:
            {
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.presentVC presentViewController:_picker animated:YES completion:NULL];
            }
                break;
            case E_AuthorizationStatus_Denied:
            case E_AuthorizationStatus_Restricted:
            case E_AuthorizationStatus_NotSupport:
            default:
            {
                if (self.authoritionBlock)
                {
                    self.authoritionBlock(status, PE_ImgPickerAuthoritionType_Camera);
                }
            }
                break;
        }
    }];
}

#pragma mark - 打开imgPicker

- (void)openImgPicker
{
    [[DeviceAuthorizationManager shared] i_requestImagePickerAuthorization:^(E_AuthorizationStatus status) {
        switch (status)
        {
            case E_AuthorizationStatus_Authorized:
            {
                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.presentVC presentViewController:_picker animated:YES completion:NULL];
            }
                break;
            case E_AuthorizationStatus_Denied:
            case E_AuthorizationStatus_Restricted:
            case E_AuthorizationStatus_NotSupport:
            default:
            {
                if (self.authoritionBlock)
                {
                    self.authoritionBlock(status, PE_ImgPickerAuthoritionType_ImgPicker);
                }
            }
                break;
        }
    }];
}

#pragma mark - ******************************Public Method******************************************

#pragma mark - 设置根控制器 弹框添加视图位置 所需图片样式 默认为UIImagePickerControllerEditedImage
- (void)i_setPresentDelegateVC:(UIViewController *_Nullable)presentVC
         infoDictionaryKeyIndex:(NSInteger)infoDictionaryKeyIndex
                  allowsEditing:(BOOL)allowsEditing;
{
    _picker = [[UIImagePickerController alloc] init];

    _picker.delegate = self;

    self.infoDictionaryKeyIndex = infoDictionaryKeyIndex;
    self.allowsEditing = allowsEditing;
    self.presentVC = presentVC;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];

    UIAlertAction *imgPickerAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImgPicker];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:imgPickerAction];

    alertController.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;

    alertController.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);

    [presentVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark---获取设备支持的类型与选中之后的图片

- (void)i_imgPickerDidSelectedBlock:(PImgPickerDidSelectedBlock)selectedBlock
{
    self.selectedBlock = selectedBlock;
}

#pragma mark---设备授权结果回调

- (void)i_imgPickerAuthoritionResult:(PImgPickerAuthoritionBlock _Nullable )authoritionBlock
{
    self.authoritionBlock = authoritionBlock;
}

#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - delegate
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    UIImage *img = [[UIImage alloc] init];

    NSArray *array = @[ @"UIImagePickerControllerMediaType",
                        @"UIImagePickerControllerOriginalImage",
                        @"UIImagePickerControllerEditedImage",
                        @"UIImagePickerControllerCropRect",
                        @"UIImagePickerControllerMediaURL",
                        @"UIImagePickerControllerReferenceURL",
                        @"UIImagePickerControllerMediaMetadata",
                        @"UIImagePickerControllerLivePhoto" ];

    if (self.infoDictionaryKeyIndex)
    {
        img = [info objectForKey:array[self.infoDictionaryKeyIndex]];
    }
    else
    {
        /// 默认是编辑之后的图片
        img = [info objectForKey:array[2]];
    }

    if (self.selectedBlock)
    {
        self.selectedBlock(img);
    }

    [self.presentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ******************************Setter & Getter****************************************

#pragma mark - ******************************类方法**************************************************

#pragma mark - ******************************************* 类方法 ***********************************

- (void)setAllowsEditing:(BOOL)allowsEditing
{
    _allowsEditing = allowsEditing;
    _picker.allowsEditing = allowsEditing;
}
@end
