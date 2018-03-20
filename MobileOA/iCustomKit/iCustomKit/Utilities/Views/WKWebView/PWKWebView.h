//
//  PWKWebView.h
//  WKWebViewJS
//
//  Created by 任清阳 on 2017/5/10.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <WebKit/WebKit.h>

/*!
 
 @brief PWKWebView 处理JS交互基类
 
 @discussion PWKWebView 处理JS交互基类.
 
 @author renqingyang 2017-05-10  17:43:19.

 @version    1.0.0.
 
 */


@interface PWKWebView : WKWebView <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

/*!
 
 @brief 根据URL初始化。
 
 @discussion 根据URL初始化.
 
 @code 
 加载url资源
 
 self.webView = [[PWKWebView alloc] initWithURLString:@"http://192.168.209.232/html.html"];
 self.webView.frame = self.view.bounds;
 self.webView.delegateWebView = self;
 self.webView.arrayJsHandlers = @[@"openBigPicture"];
 //    self.webView.delegateScriptMessageHandler = self;
 
 [self.view addSubview:self.webView];
 
 加载本地资源
 
 WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
 config.userContentController = [[WKUserContentController alloc] init];
 
 self.webView = [[PWKWebView alloc] initWithFrame:self.view.bounds configuration:config];
 
 self.webView.delegateWebView = self;
 
 self.webView.arrayJsHandlers = @[@"testMessage"];
 
 [self.view addSubview:self.webView];
 
 [self.webView loadLocalHTMLWithFileName:@"index"];
 
 @encode
 
 @param  aStringUrl 需要加载的url地址.
 
 @return PWKWebView 实例.
 
 */
- (instancetype _Nullable)initWithURLString:(NSString *_Nullable)url;


/**
 需要加载的urlString
 */
@property (nonatomic, copy) NSString *_Nullable url;

/**
 进度条
 */
@property (strong, nonatomic) UIProgressView *_Nullable progressView;

/**
 webView的标题、如果navigationItemTitle需要和webView保持一致、直接getter方法即可
 */
@property (nonatomic, copy) NSString *_Nullable webViewtitle;

/**
 注入H5页面的交互模型
 */
@property (nonatomic, copy) NSArray<NSString *> *_Nullable JsHandlersArray;

/**
 获取交互的参数代理
 */
@property (nonatomic, weak) id<WKUIDelegate, WKNavigationDelegate> _Nullable webViewDelegate;
/**
 获取JS交互的参数代理
 */
@property (nonatomic, weak) id<WKScriptMessageHandler> _Nullable scriptMessageHandlerDelegate;

/**
 *  加载本地HTML页面
 *
 *  @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName;

/**
 加载一个链接

 @param url 要加载url
 */
- (void)loadRequestWithUrl:(nonnull NSString *)url;

/**
 移除jsHandler
 */
- (void)removejsHandlers;

/**
 清除所有cookie
 */
- (void)removeCookies;

/**
 清除指定域名中的cookie
 
 @param hostName 域名
 */
- (void)removeCookieWithHostName:(NSString *_Nullable)hostName;

/**
 *  调用JS方法（无返回值）
 *
 *  @param JSMethodName JS方法名称
 */
- (void)callJavaScript:(nonnull NSString *)JSMethodName;

/**
 *  调用JS方法（可处理返回值）
 *
 *  @param JavaScript JS方法名称
 *  @param blockHandler  回调block
 */
- (void)callJavaScript:(nonnull NSString *)JavaScript
               handler:(nullable void (^)(__nullable id response))blockHandler;

@end
