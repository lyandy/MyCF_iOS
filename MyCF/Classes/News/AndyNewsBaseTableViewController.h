//
//  AndyNewsBaseTableViewController.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface AndyNewsBaseTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *dataFrame;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;

@property (nonatomic, assign) int pageIndex;

- (void)beginRefresh;

- (void)loadNewData;

- (void)loadMoreData;

- (void)hidNotice;

- (void)showNetErrorNotice;

- (void)showLoadingErrorNotice;

@end
