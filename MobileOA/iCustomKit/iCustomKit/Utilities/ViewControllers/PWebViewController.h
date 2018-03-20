//
//  PWebViewController.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PBaseViewController.h"

/*!
 *  @author 任清阳, 2017-11-20  19:40:29
 *
 *  @brief  webVC基类
 *
 *  @since  1.0
 */
@interface PWebViewController : PBaseViewController

@property (nonatomic, copy, readonly) NSURL *URL;

/*!
 *
 *  @brief 初始化。
 *
 *  @discussion 初始化.
 *
 *  @param url 需要加载的url.
 *
 *  @return 初始化对象.
 *
 *  @since  1.0
 *
 */
- (instancetype)initWithUrl:(id)url NS_DESIGNATED_INITIALIZER;

// 加载一个链接
- (void)i_loadRequestWithUrl:(NSString *)url;

@end
