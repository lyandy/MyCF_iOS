//
//  AndyVideoPlayViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoPlayViewController.h"
#import "AndyTabBarController.h"
#import "KRVideoPlayerController.h"

@interface AndyVideoPlayViewController ()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@property (nonatomic, assign) double currentBrightness;

@end

@implementation AndyVideoPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    AndyTabBarController *tabVC = (AndyTabBarController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    [tabVC roateLandscapeLeft];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.currentBrightness = [UIScreen mainScreen].brightness;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self playVideoWithURL:[NSURL URLWithString:self.playUrl] withTitle:self.videoTitle withDesc:self.videoDesc withImage:self.imageUrl withQualityArray:nil];
}

- (void)playVideoWithURL:(NSURL *)url withTitle:(NSString *)videoTitle withDesc:(NSString *)videoDesc withImage:(NSString *)imageUrl withQualityArray:(NSArray *)qualityArray
{
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.height)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
            
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
            
            [UIScreen mainScreen].brightness = weakSelf.currentBrightness;
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
    self.videoController.videoTitle = videoTitle;
    self.videoController.videoDesc = videoDesc;
    self.videoController.imageUrl = imageUrl;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
