//
//  AndyHeaderSliderDetailView.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyHeaderSliderDetailView.h"
#import "UIImageView+WebCache.h"
#import "AndyNewsModel.h"
#import "MBProgressHUD+MJ.h"
#import "AndyVideoPlayViewController.h"
#import "AndyTXVideoModel.h"
#import "AndyNewsDetailViewController.h"
#import "AndyTabBarController.h"

@interface AndyHeaderSliderDetailView ()

@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, weak) UIView *bottomBgView;

@property (nonatomic, weak) UIView *videoBgView;

@property (nonatomic, weak) UILabel *videoLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation AndyHeaderSliderDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    //bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    //bgImageView.clipsToBounds = YES;
    bgImageView.alpha = 0.0;
    bgImageView.userInteractionEnabled = YES;
    self.bgImageView = bgImageView;
    [self addSubview:self.bgImageView];
    
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.backgroundColor = AndyColor(0, 0, 0, 0.5);
    self.bottomBgView = bottomBgView;
    [self addSubview:self.bottomBgView];
    
    UIView *videoBgView = [[UIView alloc] init];
    videoBgView.alpha = 0.0;
    videoBgView.layer.cornerRadius = 3;
    videoBgView.backgroundColor = AndyColor(218, 93, 96, 1.0);
    self.videoBgView = videoBgView;
    [self.bottomBgView addSubview:self.videoBgView];
    
    UILabel *videoLabel = [[UILabel alloc] init];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    videoLabel.text = @"视频";
    videoLabel.textColor = [UIColor whiteColor];
    videoLabel.font = [UIFont systemFontOfSize:12];
    self.videoLabel = videoLabel;
    [self.videoBgView addSubview:self.videoLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:13.5];
    titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel = titleLabel;
    [self.bottomBgView addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        if ([AndyCommonFunction isNetworkConnected])
        {
            if ([AndyCommonFunction isWiFiEnabled])
            {
                if (self.newsModel.isVideo)
                {
                    [self decideJumpVideoPlayVcWithNewsModel:self.newsModel];
                }
                else
                {
                    AndyNewsDetailViewController *newsDetailVc = [[AndyNewsDetailViewController alloc] init];
                    newsDetailVc.url = self.newsModel.url;
                    
                    UIViewController *commonVc = self.isFromNews ? XAppDelegate.news : XAppDelegate.video;
                    [commonVc.navigationController pushViewController:newsDetailVc animated:YES];
                }
            }
            else
            {
                if (self.newsModel.isVideo)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"播放提示" message:@"当前为非WiFi网络，继续播放将消耗您的手机流量。确定要播放吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                    [alertView show];
                }
                else
                {
                    AndyNewsDetailViewController *newsDetailVc = [[AndyNewsDetailViewController alloc] init];
                    newsDetailVc.url = self.newsModel.url;
                    
                    UIViewController *commonVc = self.isFromNews ? XAppDelegate.news : XAppDelegate.video;
                    [commonVc.navigationController pushViewController:newsDetailVc animated:YES];
                }
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:NetWorkOffline delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)decideJumpVideoPlayVcWithNewsModel:(AndyNewsModel *)newsModel
{
    [MBProgressHUD showMessage:IsDecodingQVideoUrl toView:(self.isFromNews ? XAppDelegate.news : XAppDelegate.video).navigationController.view];
    
    [AndyQVideoTool decodeQVideoUrlWithSVID:newsModel.backup3.vid success:^(NSString *result){
        [MBProgressHUD hideHUDForView:(self.isFromNews ? XAppDelegate.news : XAppDelegate.video).navigationController.view];
        AndyVideoPlayViewController *videoPlayVc = [[AndyVideoPlayViewController alloc] init];
        videoPlayVc.playUrl = result;
        videoPlayVc.videoTitle = newsModel.title;
        videoPlayVc.videoDesc = newsModel.summary;
        videoPlayVc.imageUrl = newsModel.image_url;
        
        //尼玛当
        AndyTabBarController *tabVC = (AndyTabBarController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
        [tabVC roateLandscapeLeft];
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        [(self.isFromNews ? XAppDelegate.news : XAppDelegate.video).navigationController pushViewController:videoPlayVc animated:NO];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:DecodingQVideoUrlFailed toView:(self.isFromNews ? XAppDelegate.news : XAppDelegate.video).navigationController.view];
    }];
}

- (void)setNewsModel:(AndyNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    self.bgImageView.frame = self.bounds;
    [self.bgImageView setImageWithURL:[NSURL URLWithString:newsModel.image_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgImageView.alpha = 1.0;
        }];
    }];
    
    CGFloat bottomBgViewH = 28;
    CGFloat bottomBgViewW = self.bounds.size.width;
    CGFloat bottomBgViewX = 0;
    CGFloat bottomBgViewY = self.bounds.size.height - bottomBgViewH;
    self.bottomBgView.frame =CGRectMake(bottomBgViewX, bottomBgViewY, bottomBgViewW, bottomBgViewH);
    
    CGFloat topAndBottomMargin = 5;
    CGFloat leftAndRightMargin = 5;
    
    CGFloat videoBgViewW = 28;
    CGFloat videoBgViewH = bottomBgViewH - 2 * topAndBottomMargin;
    CGFloat videoBgViewX = leftAndRightMargin;
    CGFloat viewoBgViewY = topAndBottomMargin;
    self.videoBgView.frame =CGRectMake(videoBgViewX, viewoBgViewY, videoBgViewW, videoBgViewH);
    
    if (self.isFromNews)
    {
        self.videoBgView.alpha = newsModel.isVideo ? 1.0 : 0.0;
        //    NSMutableDictionary *videoLabelMD = [NSMutableDictionary dictionary];
        //    videoLabelMD[NSFontAttributeName] = [UIFont systemFontOfSize:17];
        //    CGSize videoLabelSize = [self.videoLabel.text sizeWithAttributes:videoLabelMD];
        //    self.videoLabel.bounds = (CGRect){CGPointZero, videoLabelSize};
        //    self.videoLabel.center = CGPointMake(CGRectGetMidX(self.videoBgView.frame), CGRectGetMidY(self.videoBgView.frame));
        
        self.videoLabel.frame = self.videoBgView.bounds;
    }
    
    self.titleLabel.text = newsModel.title;
    CGFloat titleLabelX = self.isFromNews ? (newsModel.isVideo ? (CGRectGetMaxX(self.videoBgView.frame) + leftAndRightMargin) : leftAndRightMargin) : leftAndRightMargin;
    CGFloat titleLabelY = topAndBottomMargin;
    CGFloat titleLabelW = self.bounds.size.width - CGRectGetMaxX(self.videoBgView.frame) - leftAndRightMargin;
    CGFloat titleLabelH = bottomBgViewH - 2 * topAndBottomMargin;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}


















@end
