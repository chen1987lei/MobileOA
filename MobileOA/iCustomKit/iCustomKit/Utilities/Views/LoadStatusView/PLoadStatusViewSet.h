//
//  PLoadStatusViewSet.h
//  zhongan
//
//  Created by 任清阳 on 2017/4/13.
//  Copyright © 2017年 zhongan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 
 @brief 作为空数据集的委托对象。
 
 @discussion 数据源必须采用PLoadStatusViewSet协议。 使用此委托来接收动作回调。
 
 @author renqingyang 2017-04-13 15:02:19.
 
 @copyright  zhongan.
 
 @version  10.0.0.
 
 */
@protocol PLoadStatusViewSet <NSObject>

@optional

/*!
 
 @brief 空数据View展示时是否展示淡入效果。默认为YES

 @param  view通知数据源的UIView子类.
 
 @return 数据集标题的一个富文本字符串.
 
 */
- (BOOL)i_loadStatusViewSetShouldFadeIn:(__kindof UIView *)view;

/*!
 
 @brief 是否允许touch。默认为YES
 
 @param  view通知数据源的UIView子类.
 
 @return YES.
 
 */
- (BOOL)i_loadStatusViewSetShouldAllowTouch:(__kindof UIView *)view;

/*!
 
 @brief 空视图被点击回调
 
 @param  view 通知数据源的UIView子类. tapView 被点击空视图View
 
 */
- (void)i_loadStatusViewSet:(__kindof UIView *)view
                  didTapView:(__kindof UIView *)tapView;

/*!
 
 @brief 空视图按钮被点击回调
 
 @param  view通知数据源的UIView子类. tapBtn被点击btn
 
 */
- (void)i_loadStatusViewSet:(__kindof UIView *)view
                didTapButton:(__kindof UIButton *)tapBtn;

@end
