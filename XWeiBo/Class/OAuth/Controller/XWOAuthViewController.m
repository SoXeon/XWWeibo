//
//  XWOAuthViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWOAuthViewController.h"
#import "WeiBocfg.h"
#import "XWAccountTool.h"
#import "HttpTool.h"
#import "MBProgressHUD.h"
#import "XWTabBarController.h"

@interface XWOAuthViewController() <UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end


@implementation XWOAuthViewController

- (void)loadView
{
    _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlStr = [kAuthorizeURL stringByAppendingFormat:@"?display=mobile&client_id=%@&redirect_uri=%@",kAppKey,kRedirectURI];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    
    //2.设置代理方法
    _webView.delegate = self;
}

#pragma mark - webview代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"哥正在加载中...";
    hud.dimBackground = YES;
}

#pragma mark webview请求加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma  mark -webview代理方法
#pragma mark 拦截webview的所有请求

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    NSRange range = [urlStr rangeOfString:@"code="];
    
    if (range.length != 0) {
        int index = range.location + range.length;
        NSString *requestToken = [urlStr substringFromIndex:index];
        
        [self getAccessToken:requestToken];
        
        return  NO;
        
    }
    return YES;
}


#pragma mark 换取accessToken

- (void)getAccessToken:(NSString *)requestToken
{
    [HttpTool postWithpath:@"oauth2/access_token"
                    params:@{
                             @"client_id" : kAppKey,
                             @"client_secret" : kAppSecret,
                             @"grant_type" : @"authorization_code",
                             @"redirect_uri" : kRedirectURI,
                             @"code" : requestToken
                             } success:^(id JSON) {
                                 XWAccount *account = [[XWAccount alloc] init];
                                 account.accessToken = JSON[@"access_token"];
                                 account.uid = JSON[@"uid"];
                                 [[XWAccountTool sharedXWAccountTool]saveAccount:account];
                                 
                                 self.view.window.rootViewController = [[XWTabBarController alloc]init];
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                             } failure:^(NSError *error) {
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                             }];
    
}

@end
