//
//  AndyLiveWebViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyLiveWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AndyLiveFutureWebViewController.h"
#import "AndyNavigationController.h"
#import "UIWebView+Clean.h"

@interface AndyLiveWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *liveId;

@end

@implementation AndyLiveWebViewController

- (void)loadView
{
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIWebView *webView = (UIWebView *)self.view;
    [webView cleanForDealloc];
    webView = nil;
    self.view = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"直播详情";
    
    NSArray *array = [self.url componentsSeparatedByString:@"/"];
    self.liveId = (NSString *)[array lastObject];
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [webView loadRequest:request];
    
    [MBProgressHUD showMessage:LoadingInfo toView:self.view];
}

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(removeBottomBanner) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)removeTimer
{
    @try {
        [self.timer invalidate];
        self.timer = nil;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)removeBottomBanner
{
    NSString *js1 = @"var as = document.getElementsByTagName('footer');for(i = 0;i < as.length;i++){if (as[i].className  == 'footer'){ as[i].style.visibility = 'hidden';break;}}";
    NSString *result1 = [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js1];
    
    NSString *js2 = @"var as = document.getElementsByTagName('section');for(i = 0;i < as.length;i++){if (as[i].className  == 'app-banner'){ as[i].style.visibility= 'hidden';break;}}";
    NSString *result2 = [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js2];
    
    NSString *js3 = @"var as = document.getElementsByTagName('button');for(i = 0;i < as.length;i++){if (as[i].className  == 'feed-button'){ as[i].style.visibility= 'hidden';break;}}";
    NSString *result3 = [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js3];
    
    if ([result1.lowercaseString isEqualToString:@"hidden"] && [result2.lowercaseString isEqualToString:@"hidden"] && [result3.lowercaseString isEqualToString:@"hidden"])
    {
        [self removeTimer];
        [MBProgressHUD hideHUDForView:self.view];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[self removeTimer];
    //[self addTimer];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    AndyLog(@"%@", request.URL.description);

//    NSString *navigateUrl = request.URL.description;
//    
//    NSArray *array = [navigateUrl componentsSeparatedByString:@"/"];
//    NSString *liveId = (NSString *)[array lastObject];
//    
//    if (![navigateUrl containsString:@"http://star.longzhu.com"] || ![liveId isEqualToString:self.liveId])
//    {
//        AndyLog(@"我已取消导航");
//        
//        AndyLiveFutureWebViewController *liveFutureWebVc = [[AndyLiveFutureWebViewController alloc] init];
//        liveFutureWebVc.futureUrl = navigateUrl;
//        
//        AndyNavigationController *nav = [[AndyNavigationController alloc] initWithRootViewController:liveFutureWebVc];
//        
//        [self presentViewController:nav animated:YES completion:nil];
//        
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeBottomBanner];
    
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if([AndyCommonFunction isNetworkConnected])
    {
        if (error.userInfo.count == 0)
        {
            [MBProgressHUD showError:LoadingError toView:self.view];
        }
    }
    else
    {
        [MBProgressHUD showError:NetWorkOffline toView:self.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
