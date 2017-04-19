//
//  AppDelegate.h
//  MyCF
//
//  Created by 李扬 on 15/12/14.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyNewsMainViewController.h"
#import "AndyVideoCollectionViewController.h"
#import "AndyPictureCollectionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isCanCapture;

@property (nonatomic, strong) AndyNewsMainViewController *news;

@property (nonatomic, strong) AndyVideoCollectionViewController *video;

@property (nonatomic, strong) AndyPictureCollectionViewController *picture;


@end

