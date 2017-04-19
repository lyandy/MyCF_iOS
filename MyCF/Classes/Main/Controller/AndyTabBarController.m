//
//  AndyTabBarViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/14.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyTabBarController.h"
#import "AndyNewsMainViewController.h"
#import "AndyVideoCollectionViewController.h"
#import "AndyPictureCollectionViewController.h"
#import "AndyAboutTableViewController.h"
#import "AndyNavigationController.h"

@interface AndyTabBarController ()

@property(nonatomic) UIInterfaceOrientationMask orietation;

@end

@implementation AndyTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.tintColor = AndyPerformanceColor;
    
    [self setupAllChildViewControllers];
}

-(void)roateLandscapeLeft
{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.orietation = UIInterfaceOrientationMaskLandscapeLeft;
}

-(void)roatePortrait
{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.orietation = UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self roatePortrait];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.orietation;
}

- (void)setupAllChildViewControllers
{
    AndyNewsMainViewController *news = [[AndyNewsMainViewController alloc] init];
    [self setupChildViewController:news title:@"情报" imageName:@"tabbar_news" selectedImageName:nil];
    XAppDelegate.news = news;
    
    AndyVideoCollectionViewController *video = [[AndyVideoCollectionViewController alloc] init];
    [self setupChildViewController:video title:@"视频" imageName:@"tabbar_video" selectedImageName:nil];
    XAppDelegate.video =video;
    
    AndyPictureCollectionViewController *picture = [[AndyPictureCollectionViewController alloc] init];
    [self setupChildViewController:picture title:@"直播" imageName:@"tabbar_pics" selectedImageName:nil];
    XAppDelegate.picture = picture;
    
    AndyAboutTableViewController *about = [[AndyAboutTableViewController alloc] init];
    [self setupChildViewController:about title:@"关于" imageName:@"tabbar_about" selectedImageName:nil];
}


- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (selectedImageName != nil)
    {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    childVc.tabBarItem.image = image;
    
    childVc.title = title;
    
    AndyNavigationController *nav = [[AndyNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


@end
