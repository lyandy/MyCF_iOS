//
//  AndyNewsDetailViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UIWebView+Clean.h"

@interface AndyNewsDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AndyNewsDetailViewController

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
    
    self.title = @"详情";
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [webView loadRequest:request];
    
    [self removeTimer];
    [self addTimer];
    
    //[webView.scrollView addSubview:nil];
    
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
    NSString *js = @"var as = document.getElementsByTagName('div');for(i = 0;i < as.length;i++){if (as[i].className  == 'qt_bottom_bar'){ as[i].style.visibility = 'hidden';break;}}";
    NSString *result = [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js];
    if ([result.lowercaseString isEqualToString:@"hidden"])
    {
        [self removeTimer];
        [MBProgressHUD hideHUDForView:self.view];
    }
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
        [MBProgressHUD showError:LoadingError toView:self.view];
    }
    else
    {
        [MBProgressHUD showError:NetWorkOffline toView:self.view];
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
