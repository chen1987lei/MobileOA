//
//  PLoadStatusViewSetSource.h
//  zhongan
//
//  Created by 任清阳 on 2017/4/13.
//  Copyright © 2017年 zhongan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 
 @brief 作为空数据集的数据源的对象。
 
 @discussion 数据源必须采用PLoadStatusViewSetSource协议。 数据源不保留。 所有数据源方法都是可选的。
 
 @author renqingyang 2017-04-13 15:02:19.
 
 @copyright  zhongan.
 
 @version  10.0.0.
 
 */

@protocol PLoadStatusViewSetSource <NSObject>

@optional

/*!
 
 @brief 展示内容的标题。
 
 @discussion 默认情况下，数据集使用固定字体样式。 如果你想要一个不同的字体样式，返回一个富文本字符串.
 
 @param  view 通知数据源的UIView子类.
 
 @return 数据集标题的一个富文本字符串.
 
 */
- (NSAttributedString *)i_titleForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief 展示内容的描述。
 
 @discussion 默认情况下，数据集使用固定字体样式。 如果你想要一个不同的字体样式，返回一个富文本字符串.
 
 @param  view 通知数据源的UIView子类.
 
 @return 数据集描述的一个富文本字符串.
 
 */
- (NSAttributedString *)i_descriptionForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief 空数据展示的图片。

 @param  view 通知数据源的UIView子类.
 
 @return 一个图片.
 
 */
- (__kindof UIImage *)i_imgForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief 空数据展示的按钮。
 
 @param  view通知数据源的UIView子类.
 
 @return 一个按钮.
 
 */
- (__kindof UIButton *)i_btnForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief 空数据展示按钮上显示的富文本文字。
 
 @param  view通知数据源的UIView子类.
 
 @return 一个富文本字符串.
 
 */
- (NSAttributedString *)i_btnTitleForLoadStatusViewSet:(__kindof UIView *)view
                                               forState:(UIControlState)state;

/*!
 
 @brief  空数据展示按钮上显示的图片。
 
 @param  view通知数据源的UIView子类.
 
 @return img.
 
 */
- (UIImage *)i_btnImgForLoadStatusViewSet:(__kindof UIView *)view
                                  forState:(UIControlState)state;

/*!
 
 @brief  空数据展示按钮上显示的背景图片图片。
 
 @param  view通知数据源的UIView子类.
 
 @return img.
 
 */
- (UIImage *)i_btnBackgroundImageForLoadStatusViewSet:(__kindof UIView *)view
                                              forState:(UIControlState)state;


/*!
 
 @brief 展示内容的垂直方向的偏移量。 默认为0.0。-------由于咱们项目中每个页面的偏移量不尽相同，故此代理不需要实现
 
 @param  view通知数据源的UIView子类.
 
 @return 偏移量.
 
 */
- (CGFloat)i_verticalOffsetForLoadStatusViewSet:(__kindof UIView *)view NS_UNAVAILABLE;

/*!
 
 @brief 展示内容的图片的size。 默认为CGSizeZero。
 
 @param  view通知数据源的UIView子类.
 
 @return 加载图片size.
 
 */
- (CGSize)i_imageViewSizeForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief  展示view的背景色。
 
 @param  view通知数据源的UIView子类.
 
 @return color.
 
 */
- (UIColor *)i_backgroundColorForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief  自定义展示view。
 
 @param  view通知数据源的UIView子类.
 
 @return customView.
 
 */
- (UIView *)i_customViewForLoadStatusViewSet:(__kindof UIView *)view;

/*!
 
 @brief 展示内容的各元素之间的间距。 默认11像素。
 
 @param  view通知数据源的UIView子类.
 
 @return 间距.
 
 */
- (CGFloat)i_spaceHeightForLoadStatusViewSet:(__kindof UIView *)view;

@end
