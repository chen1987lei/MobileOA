//
//  PWKWebView.m
//  WKWebViewJS
//
//  Created by 任清阳 on 2017/5/10.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "PWKWebView.h"

@interface PWKWebView ()

@end


@implementation PWKWebView

- (instancetype)initWithURLString:(NSString *)url
{
    self = [super init];

    if (self)
    {
        [self setDefaultValue];

        self.url = url;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    self = [super initWithFrame:frame configuration:configuration];

    if (self)
    {
        [self setDefaultValue];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self setDefaultValue];
    }

    return self;
}

- (void)setUrl:(NSString *)url
{
    _url = url;

    NSURL *URL = [NSURL URLWithString:url];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    [self loadRequest:request];
}

- (void)setDefaultValue
{
    /// 导航代理
    self.UIDelegate = self;
    /// 与webview UI交互代理
    self.navigationDelegate = self;

    ///打开左划回退功能
    self.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)loadLocalHTMLWithFileName:(NSString *)htmlName
{
    NSString *path = [[NSBundle mainBundle] bundlePath];

    NSURL *URL = [NSURL fileURLWithPath:path];

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlName

                                                               ofType:@"html"];
    /// 判断是否加载文件
    if (htmlPath == NULL)
    {
        [self loadHTMLString:htmlName
                     baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }
    else
    {
        NSString *htmlPathContent = [NSString stringWithContentsOfFile:htmlPath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];

        [self loadHTMLString:htmlPathContent baseURL:URL];
    }
}

/// 加载一个链接
- (void)loadRequestWithUrl:(NSString *)url
{
    if (kString_Not_Valid(url))
    {
        return;
    }

    NSURL *URL = [NSURL URLWithString:url];
    if (url == nil)
    {
        return;
    }
    else
    {
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:15];

    NSString *cookie = [self getCookiesFromHttpCookieStorage:url];

    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
    [self loadRequest:request];
    
}

- (void)setJsHandlersArray:(NSArray<NSString *> *)JsHandlersArray
{
    _JsHandlersArray = JsHandlersArray;

    for (NSString *handler in JsHandlersArray)
    {
        /// 注入JS方法
        [self.configuration.userContentController addScriptMessageHandler:self
                                                                     name:handler];
    }
}

#pragma mark - js调用原生方法 可在此方法中获得传递回来的参数

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.scriptMessageHandlerDelegate &&
        [self.scriptMessageHandlerDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    {
        [self.scriptMessageHandlerDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

#pragma mark - 检查cookie及页面HTML元素    页面加载完成后调用

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.webViewDelegate &&
        [self.webViewDelegate respondsToSelector:@selector(webView:didFinishNavigation:)])
    {
        [self.webViewDelegate webView:webView didFinishNavigation:navigation];
    }
}

#pragma mark - 页面开始加载就调用

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (self.webViewDelegate &&
        [self.webViewDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)])
    {
        [self.webViewDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

#pragma mark - 页面开始加载时失败调用
- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error
{
    SEL selector = @selector(webView:didFailProvisionalNavigation:withError:);
    
    if (self.webViewDelegate &&
        [self.webViewDelegate respondsToSelector:selector])
    {
        [self.webViewDelegate webView:webView
         didFailProvisionalNavigation:navigation
                            withError:error];
    }
}

#pragma mark - 开始接收数据时失败调用

- (void)webView:(WKWebView *)webView
didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error
{
    SEL selector = @selector(webView:didFailNavigation:withError:);
    
    if (self.webViewDelegate &&
        [self.webViewDelegate respondsToSelector:selector])
    {
        [self.webViewDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}


#pragma mark - 导航每次跳转调用跳转

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (self.webViewDelegate &&
        [self.webViewDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)])
    {
        [self.webViewDelegate webView:webView
            decidePolicyForNavigationAction:navigationAction
                            decisionHandler:decisionHandler];
    }
    else
    {
        //下面这句话一定不能少一少就报错
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - 在收到响应时调用，让调用方决定是否允许加载数据

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    // 获取cookie,并设置到本地
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields]
                                                             forURL:response.URL];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
                      initiatedByFrame:(WKFrameInfo *)frame
                     completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s", __FUNCTION__);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView
    runJavaScriptConfirmPanelWithMessage:(NSString *)message
                        initiatedByFrame:(WKFrameInfo *)frame
                       completionHandler:(void (^)(BOOL result))completionHandler
{
}


// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView
    runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
                              defaultText:(nullable NSString *)defaultText
                         initiatedByFrame:(WKFrameInfo *)frame
                        completionHandler:(void (^)(NSString *__nullable result))completionHandler
{
}

#pragma mark - 移除 _arrayJsHandlers 定义的jsHandler

- (void)removejsHandlers
{
    if (_JsHandlersArray.count)
    {
        for (NSString *handler in _JsHandlersArray)
        {
            /// 移除JS注入方法
            [self.configuration.userContentController removeScriptMessageHandlerForName:handler];
        }
    }
}

#pragma mark - 清除cookie

- (void)removeCookies
{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];

    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> *__nonnull records) {
                         for (WKWebsiteDataRecord *record in records)
                         {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[ record ]
                                                                    completionHandler:^{
//                                                                        NSLog(@"Cookies  %@ 移除成功", record.displayName);
                                                                    }];
                         }
                     }];
}

- (void)removeCookieWithHostName:(NSString *)hostName
{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];

    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> *__nonnull records) {
                         for (WKWebsiteDataRecord *record in records)
                         {
                             if ([record.displayName containsString:hostName])
                             {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[ record ]
                                                                        completionHandler:^{
//                                                                            NSLog(@"Cookies  %@ 移除成功", record.displayName);
                                                                        }];
                             }
                         }
                     }];
}

- (NSString *)getCookiesFromHttpCookieStorage:(NSString *)url
{
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSURL *URL = [NSURL URLWithString:url];
    NSArray *cookies = [cookieJar cookiesForURL:URL];

    NSMutableString *cookieString= [[NSMutableString alloc] init];

    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }

    if (cookieString.length > 0)
    {
        /// 删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        return cookieString;
    }
    else
    {
        return @"";
    }
}

#pragma mark - 调用JS方法

- (void)callJavaScript:(NSString *)stringJsMethodName
{
    [self callJavaScript:stringJsMethodName handler:nil];
}

- (void)callJavaScript:(NSString *)stringJsMethodName handler:(void (^)(id _Nullable))blockHandler
{
//    NSLog(@"call js:%@", stringJsMethodName);

    [self evaluateJavaScript:stringJsMethodName
           completionHandler:^(id _Nullable response, NSError *_Nullable error) {
               if (blockHandler)
               {
                   blockHandler(response);
               }
           }];

    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    [self evaluateJavaScript:jsToGetHTMLSource
           completionHandler:^(id _Nullable HTMLsource, NSError *_Nullable error) {
//               NSLog(@"%@", HTMLsource);
           }];
}

//这里需要注意，要调用 [self.configuration.userContentController removeAllUserScripts];  才会执行dealloc。
- (void)dealloc
{
//    [self removeCookies];
}

@end
