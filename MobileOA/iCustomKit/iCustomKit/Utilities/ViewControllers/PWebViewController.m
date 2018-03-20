//
//  PWebViewController.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PWebViewController.h"

#import "PWKWebView.h"

@interface PWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy, readwrite) NSURL *URL;

@property (nonatomic, strong) PWKWebView *webView;

@end

@implementation PWebViewController

#pragma mark - ******************************LifeCycle Method***************************************

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

// 设置布局代码建议在此处完成，此方法会在needlayout中调用
- (void)updateViewConstraints
{
    [super updateViewConstraints];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)initWithUrl:(id)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        if ([url isKindOfClass:[NSURL class]])
        {
            _URL = [url copy];
        }
        else if ([url isKindOfClass:[NSString class]])
        {
            _URL = [self urlFromString:url];
        }
    }

    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithUrl:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithUrl:nil];
}

- (void)dealloc
{
    [self.webView stopLoading];

    [self.webView loadHTMLString:@"" baseURL:nil];

    self.webView.webViewDelegate = nil;
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

- (NSURL *)urlFromString:(NSString *)url
{
    // 加保护，去掉链接前后的空格
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSURL *URL = [NSURL URLWithString:url];

    // 防止url没有编过码，如果链接中包含中文等特殊字符时，无法生成url，加个保护
    if (URL == nil)
    {
        NSString *encodedUrl = [NSString i_encodeURLWithUTF8:url];
        URL = [NSURL URLWithString:encodedUrl];
    }

    return URL;
}

#pragma mark - Private
- (void)loadRequest
{
    if (self.webView.isLoading)
    {
        [self.webView stopLoading];
    }

    if (self.URL)
    {
        [self.webView loadHTMLString:@"" baseURL:nil];
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }
}
#pragma mark - ******************************Public Method******************************************

// 加载一个链接
- (void)i_loadRequestWithUrl:(NSString *)url
{
    [self.webView stopLoading];

    if (kString_Not_Valid(url))
    {
        return;
    }

    // 加保护，去掉链接前后的空格
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    self.URL = [NSURL URLWithString:url];

    [self loadRequest];
}
#pragma mark - ******************************Override Method****************************************

- (void)i_initFields
{
    [super i_initFields];
}

- (void)i_uninitFields
{
    [super i_uninitFields];
}

- (void)i_createViews
{
    [super i_createViews];

    // 加载webView
    [self.view addSubview:self.webView];
}

- (void)i_destroyViews
{
    [super i_destroyViews];
}

- (void)i_createEvents
{
    [super i_createEvents];
}

- (void)i_destroyEvents
{
    [super i_destroyEvents];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [self.webView stopLoading];
    self.webView.webViewDelegate = nil;
    self.webView = nil;
}

- (void)i_loadData
{
    [super i_loadData];

    // 加载链接
    [self loadRequest];
}

- (void)i_cancelLoadData
{
    [super i_cancelLoadData];

    // 取消每个网络请求，需要逐个列出来
    [self.webView stopLoading];
}

- (void)i_unload
{
    
}

#pragma mark - 处理影响引用计数的功能

- (void)i_releaseReferenceCount
{
    
}

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

// webView
- (PWKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[PWKWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.webViewDelegate = self;

        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
