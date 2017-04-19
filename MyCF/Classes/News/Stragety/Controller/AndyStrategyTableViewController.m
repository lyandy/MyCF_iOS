//
//  AndyStrategyTableViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyStrategyTableViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "NSString+Andy.h"
#import "AndyNewsRootModel.h"
#import "AndyNewsModel.h"
#import "AndyNewsCommonFrame.h"

@interface AndyStrategyTableViewController ()

@end

@implementation AndyStrategyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AndyLog(@"StrategyTableViewController 被加载");
}

- (void)loadNewData
{
    [super loadNewData];
    
    self.pageIndex = 1;
    
    [AndyHttpTool getWithURL:[NSString stringWithFormat:@"http://qt.qq.com/php_cgi/cf_news/php/varcache_getnews.php?id=3&page=%d", self.pageIndex] params:nil success:^(id json) {
        
        [self CommbineNewData:json];
        
        self.pageIndex++;
        
        // 缓存
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:StrategyCacheFileName atomically:YES];
        
    } failure:^(NSError *error)
     {
         NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:StrategyCacheFileName];
         
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
    
    [self.tableView reloadData];
    
    [self.header endRefreshing];
    
    [super hidNotice];
}

- (void)loadMoreData
{
    [super loadMoreData];
    
    [AndyHttpTool getWithURL:[NSString stringWithFormat:@"http://qt.qq.com/php_cgi/cf_news/php/varcache_getnews.php?id=3&page=%d", self.pageIndex] params:nil success:^(id json) {
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
