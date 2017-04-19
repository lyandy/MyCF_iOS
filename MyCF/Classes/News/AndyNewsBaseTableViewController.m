//
//  AndyNewsBaseTableViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsBaseTableViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "AndyNewsCommonFrame.h"
#import "AndyNewsRootModel.h"
#import "AndyNewsModel.h"
#import "AndyTXVideoModel.h"
#import "AndyCommonNewsTableViewCell.h"
#import "AndyNewsDetailViewController.h"
#import "AndyVideoPlayViewController.h"

@interface AndyNewsBaseTableViewController ()<MJRefreshBaseViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) AndyNewsModel *newsModel;

@end

@implementation AndyNewsBaseTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //AndyLog(@"%@ 被加载", self);
    
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 48, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.tableView.backgroundColor = [UIColor redColor];
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
}

- (NSMutableArray *)dataFrame
{
    if (_dataFrame == nil)
    {
        _dataFrame = [NSMutableArray array];
    }
    return _dataFrame;
}

- (void)beginRefresh
{
    [MBProgressHUD showMessage:LoadingInfo toView:XAppDelegate.news.navigationController.view];
    [self loadNewData];
}

- (void)dealloc
{
    [self.header free];
    [self.footer free];
}

- (void)setupRefreshView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    
    //[header beginRefreshing];
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        if (self.hasNextPage == YES && self.pageIndex <= 5)
        {
            [self loadMoreData];
        }
        else
        {
            if (!self.hasNextPage)
            {
                AndyLog(@"没有下一页了");
            }
            else
            {
                AndyLog(@"页码索引超出限制");
            }
            
            [self.footer endRefreshing];
        }
    }
    else
    {
        [self loadNewData];
    }
}

- (void)loadNewData
{
    
}

- (void)loadMoreData
{
    
}

- (void)hidNotice
{
    [MBProgressHUD hideHUDForView:XAppDelegate.news.navigationController.view];
}

- (void)showNetErrorNotice
{
    [self hidNotice];
    [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:XAppDelegate.news.navigationController.view];
}

- (void)showLoadingErrorNotice
{
    [self hidNotice];
    [MBProgressHUD showError:LoadingError toView:XAppDelegate.news.navigationController.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyCommonNewsTableViewCell *cell = [AndyCommonNewsTableViewCell cellWithTableView:tableView];
    
    AndyNewsCommonFrame *newsCommonFrame = self.dataFrame[indexPath.row];
    
    cell.newsCommonFrame = newsCommonFrame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后灰色背景动画再消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([AndyCommonFunction isNetworkConnected])
    {
        AndyNewsCommonFrame *newsCommonFrame = self.dataFrame[indexPath.row];
        AndyNewsModel *newsModel = newsCommonFrame.newsModel;
        self.newsModel = newsModel;
        
        if ([AndyCommonFunction isWiFiEnabled])
        {
            if (newsModel.isVideo)
            {
                [self decideJumpVideoPlayVcWithNewsModel:newsModel];
            }
            else
            {
                AndyNewsDetailViewController *newsDetailVc = [[AndyNewsDetailViewController alloc] init];
                newsDetailVc.url = newsModel.url;
                [XAppDelegate.news.navigationController pushViewController:newsDetailVc animated:YES];
            }
        }
        else
        {
            if (newsModel.isVideo)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"播放提示" message:@"当前为非WiFi网络，继续播放将消耗您的手机流量。确定要播放吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                [alertView show];
            }
            else
            {
                AndyNewsDetailViewController *newsDetailVc = [[AndyNewsDetailViewController alloc] init];
                newsDetailVc.url = newsModel.url;
                [XAppDelegate.news.navigationController pushViewController:newsDetailVc animated:YES];
            }
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络提示" message:NetWorkOffline delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self decideJumpVideoPlayVcWithNewsModel:self.newsModel];
    }
}

- (void)decideJumpVideoPlayVcWithNewsModel:(AndyNewsModel *)newsModel
{
    [MBProgressHUD showMessage:IsDecodingQVideoUrl toView:XAppDelegate.news.navigationController.view];
    
    [AndyQVideoTool decodeQVideoUrlWithSVID:newsModel.backup3.vid success:^(NSString *result){
        [MBProgressHUD hideHUDForView:XAppDelegate.news.navigationController.view];
        AndyVideoPlayViewController *videoPlayVc = [[AndyVideoPlayViewController alloc] init];
        videoPlayVc.playUrl = result;
        videoPlayVc.videoTitle = newsModel.title;
        videoPlayVc.videoDesc = newsModel.summary;
        videoPlayVc.imageUrl = newsModel.image_url;
        [XAppDelegate.news.navigationController pushViewController:videoPlayVc animated:NO];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:DecodingQVideoUrlFailed toView:XAppDelegate.news.navigationController.view];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyNewsCommonFrame *newsCommonFrame = self.dataFrame[indexPath.row];
    
    return newsCommonFrame.cellHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

























@end
