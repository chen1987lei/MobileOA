//
//  PLoadStatusView.h
//
//  Created by 任清阳 on 15/11/5.
//  Copyright © 2015年 zhongan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLoadStatusViewSet;
@protocol PLoadStatusViewSetSource;

/*!
 *  @author 任清阳, 15-11-05
 *
 *  @brief  加载页 PLoadStatusView
 *
 *  @since  1.0.1
 */
@interface PLoadStatusView : UIView

/// contetView在最外层View上的Y轴偏移量
@property (nonatomic, assign) CGFloat offsetY;

/** 空数据数据源. */
@property (nonatomic, weak) id<PLoadStatusViewSetSource> loadStatusViewSetSourceDelegate;
/** 空数据代理协议 */
@property (nonatomic, weak) id<PLoadStatusViewSet> loadStatusViewSetDelegate;

/** 刷新数据 */
- (void)reloadLoadStatusView;

/** 刷新复用数据 */
- (void)prepareForReuse;

@end
