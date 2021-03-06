//
//  AndyCFNewsTableViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCFNewsTableViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "NSString+Andy.h"
#import "AndyNewsRootModel.h"
#import "AndyNewsModel.h"
#import "AndyNewsCommonFrame.h"
#import "AndyHeaderSliderView.h"

@interface AndyCFNewsTableViewController ()

@property (nonatomic, weak) AndyHeaderSliderView *headerSliderView;

@end

@implementation AndyCFNewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AndyLog(@"FNewsTableViewController 被加载");
    
    CGFloat headerSliderViewX = 0;
    CGFloat headerSliderViewY = 0;
    CGFloat headerSliderViewW = AndyMainScreenSize.width;
    CGFloat headerSliderViewH = headerSliderViewW * 0.45;
    
    AndyHeaderSliderView *headerSliderView = [[AndyHeaderSliderView alloc] initWithFrame:CGRectMake(headerSliderViewX, headerSliderViewY, headerSliderViewW, headerSliderViewH)];
    self.headerSliderView = headerSliderView;
    
    self.tableView.tableHeaderView = self.headerSliderView;
}

- (void)loadNewData
{
    [super loadNewData];
    
    self.pageIndex = 1;
    
    [AndyHttpTool getWithURL:[NSString stringWithFormat:@"http://qt.qq.com/php_cgi/cf_news/php/varcache_getnews.php?id=8&page=%d", self.pageIndex] params:nil success:^(id json) {
        
        [self CommbineNewData:json];
        
        self.pageIndex++;
        
        // 缓存
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:CFNewsCacheFileName atomically:YES];
        
    } failure:^(NSError *error)
     {
         NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:CFNewsCacheFileName];
         
         if ([AndyCommonFunction isNetworkConnected] == NO)
         {
             if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
             {
                 NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                 //NSString *jsonStr = [NSString stringWithContentsOfFile:cacheFilePath encoding:NSUTF8StringEncoding error:nil];
                 [self CommbineNewData:jsonDic];
             }
             else
             {
                 [super showNetErrorNotice];
             }
         }
         else
         {
             if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
             {
                 NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                 [self CommbineNewData:jsonDic];
             }
             else
             {
                 [super showLoadingErrorNotice];
             }
         }
         
         [self.header endRefreshing];
     }];
}

- (void)CommbineNewData:(id)json
{
    AndyNewsRootModel *rootModel = [AndyNewsRootModel objectWithKeyValues:json];
    
    self.hasNextPage = rootModel.next_page;
    
    [self.dataFrame removeAllObjects];
    
    [rootModel.news enumerateObjectsUsingBlock:^(AndyNewsModel  * _Nonnull newsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AndyNewsCommonFrame *newsCommonFrame = [[AndyNewsCommonFrame alloc] init];
        newsCommonFrame.newsModel = newsModel;
        
        [self.dataFrame addObject:newsCommonFrame];
    }];
    
    if (rootModel.ads.count > 0)
    {
        [self.headerSliderView setupScrollViewSubviewsWithArray:rootModel.ads];
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    
    [self.tableView reloadData];
    
    [self.header endRefreshing];
    
    [super hidNotice];
}

- (void)loadMoreData
{
    [super loadMoreData];
    
    [AndyHttpTool getWithURL:[NSString stringWithFormat:@"http://qt.qq.com/php_cgi/cf_news/php/varcache_getnews.php?id=8&page=%d", self.pageIndex] params:nil success:^(id json) {
        
        AndyNewsRootModel *rootModel = [AndyNewsRootModel objectWithKeyValues:json];
        
        self.hasNextPage = rootModel.next_page;
        
        [rootModel.news enumerateObjectsUsingBlock:^(AndyNewsModel  * _Nonnull newsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            AndyNewsCommonFrame *newsCommonFrame = [[AndyNewsCommonFrame alloc] init];
            newsCommonFrame.newsModel = newsModel;
            
            [self.dataFrame addObject:newsCommonFrame];
        }];
        
        [self.tableView reloadData];
        
        [self.footer endRefreshing];
        
        [super hidNotice];
        
        self.pageIndex++;
        
    } failure:^(NSError *error)
     {
         [self.footer endRefreshing];
     }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
