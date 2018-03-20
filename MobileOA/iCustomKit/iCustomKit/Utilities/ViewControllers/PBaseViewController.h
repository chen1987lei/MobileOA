//
//  PBaseViewController.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

/*!
 *  @author 任清阳, 2017-11-08  11:18:29
 *
 *  @brief  项目通用VC基类
 *
 *  @since  1.0
 */
@interface PBaseViewController : BaseViewController

#pragma mark - VC属性

// 是否显示TabBarView，目前只有主界面显示，所以默认是不现实的
@property (nonatomic, assign, getter = isShowTabBar) BOOL showTabBar;

// 埋点中使用的每个页面的标识，需要每个埋点页面自己设置
@property (nonatomic, copy) NSString *pageID;

#pragma mark - ******************************************* ScrollView 属性 **************************

// 设置ScrollView种类的属性
@property (nonatomic, assign, getter = isScrollToTop) BOOL scrollToTop;

// 设置ScrollView种类的ScrollsToTop属性
- (void)i_setScrollViewScrollToTop:(BOOL)scrollToTop;

#pragma mark - ******************************************* 对外方法 **********************************

@end
