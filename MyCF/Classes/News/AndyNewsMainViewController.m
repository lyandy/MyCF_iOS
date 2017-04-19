//
//  AndyNewsMainViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsMainViewController.h"
#import "AndySliderView.h"
#import "AndySliderBar.h"
#import "AndyCFNewsTableViewController.h"
#import "AndyChampionTableViewController.h"
#import "AndyStrategyTableViewController.h"

@interface AndyNewsMainViewController ()

@property (nonatomic, strong) AndySliderBar *sliderBar;

@property (nonatomic, strong) AndySliderView *sliderView;

@end

@implementation AndyNewsMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupSubviews
{
    AndySliderView *sliderView = [[AndySliderView alloc] initWithFrame:self.view.bounds];
    sliderView.backgroundColor = [UIColor whiteColor];
    self.sliderView = sliderView;
    [self.view addSubview:self.sliderView];
    
    AndyCFNewsTableViewController *CFNewsVc = [[AndyCFNewsTableViewController alloc] init];
    AndyChampionTableViewController *championVc = [[AndyChampionTableViewController alloc] init];
    AndyStrategyTableViewController *strategyVc = [[AndyStrategyTableViewController alloc] init];
    NSArray *vcArray = [NSArray arrayWithObjects:CFNewsVc, championVc, strategyVc, nil];
    
    [self.sliderView setupViewControllersArray:vcArray];
    
    
    AndySliderBar *sliderBar = [[AndySliderBar alloc] initWithFrame:CGRectMake(0, 0, AndyMainScreenSize.width, 40)];
    sliderBar.backgroundColor = [UIColor clearColor];
    self.sliderBar = sliderBar;
    self.navigationItem.titleView = self.sliderBar;
    
    self.sliderBar.delegate = self.sliderView;
    self.sliderView.delegate = self.sliderBar;
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"资讯", @"赛事", @"攻略", nil];
    [self.sliderBar setupSliderBarButtonsArray:titleArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
