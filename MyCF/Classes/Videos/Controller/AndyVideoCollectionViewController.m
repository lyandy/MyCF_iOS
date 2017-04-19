//
//  AndyVideoCollectionViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoCollectionViewController.h"
#import "AndyHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "AndyVideoCollectionViewCell.h"
#import "MJExtension.h"
#import "NSString+Andy.h"
#import "MJRefresh.h"
#import "AndyVideoRootModel.h"
#import "AndyVideoMsgModel.h"
#import "AndyTXorAipaiVideoModel.h"
#import "AndyVideoCollectionViewCell.h"
#import "AndyVideoPlayViewController.h"
#import "AndyHeaderCollectionSliderView.h"
#import "AndyNewsRootModel.h"
#import "AndyNewsModel.h"

#define AndyVideoyId @"VideoId"

@interface AndyVideoCollectionViewController ()<MJRefreshBaseViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *videosM;

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;

@property (nonatomic, strong) AndyTXorAipaiVideoModel *txotAipaiViewModel;

@property (nonatomic, assign) int pageIndex;

@property (nonatomic, assign) BOOL headerHasTry;

@end

static NSString * const collectionHeaderViewIdentifier = @"UICollectionHeaderId";

@implementation AndyVideoCollectionViewController

- (NSMutableArray *)videosM
{
    if (_videosM == nil)
    {
        _videosM = [NSMutableArray array];
    }
    return _videosM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"AndyVideoCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:AndyVideoyId];
    
    
    UINib *headerNib = [UINib nibWithNibName:@"AndyUICollectionHearView" bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderViewIdentifier];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showMessage:LoadingInfo toView:self.navigationController.view];
    [self loadNewVideoData];
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
    
    [self setupNavBar];
}

- (void)setupNavBar
{
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"直播" style:UIBarButtonItemStylePlain target:self action:@selector(showLiveVideo)];
}

- (void)showLiveVideo
{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AndyHeaderCollectionSliderView *view = [collectionView
                                      dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                      withReuseIdentifier:collectionHeaderViewIdentifier
                                      forIndexPath:indexPath];
    
    if (!self.headerHasTry)
    {
        self.headerHasTry = YES;
        [self loadHeaderDataWithHeaderView:view];
    }
    else
    {
        AndyLog(@"您已经试过或者正在试");
    }
    
    return view;
}

- (void)loadHeaderDataWithHeaderView:(AndyHeaderCollectionSliderView *)headerView
{
    [AndyHttpTool getWithURL:@"http://qt.qq.com/php_cgi/cf_news/php/varcache_getnews.php?id=2&page=1" params:nil success:^(id json) {
        
        [self CommbineHeaderData:json WithHeaderView:headerView];
        // 缓存
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:VideoHeaderCacheFileName atomically:YES];
        
    } failure:^(NSError *error)
     {
         NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:VideoHeaderCacheFileName];
         
         if ([AndyCommonFunction isNetworkConnected] == NO)
         {
             if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
             {
                 NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                 //NSString *jsonStr = [NSString stringWithContentsOfFile:cacheFilePath encoding:NSUTF8StringEncoding error:nil];
                 [self CommbineHeaderData:jsonDic WithHeaderView:headerView];
             }
             else
             {
                 //[super showNetErrorNotice];
             }
         }
         else
         {
             if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
             {
                 NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                 [self CommbineHeaderData:jsonDic WithHeaderView:headerView];
             }
             else
             {
                 //[super showLoadingErrorNotice];
             }
         }
     }];
}

- (void)CommbineHeaderData:(id)json WithHeaderView:(AndyHeaderCollectionSliderView *)headerView
{
    AndyNewsRootModel *rootModel = [AndyNewsRootModel objectWithKeyValues:json];
    
    //NSMutableArray *headerModelM = [NSMutableArray array];
    
    if (rootModel.ads.count > 0)
    {
        [headerView setupScrollViewSubviewsWithArray:[rootModel.ads subarrayWithRange:NSMakeRange(0, 5)]];
    }
    else
    {
        //self.tableView.tableHeaderView = nil;
    }
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    CGFloat screenWidth = AndyMainScreenSize.width < AndyMainScreenSize.height ? AndyMainScreenSize.width : AndyMainScreenSize.height;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        layout.itemSize = CGSizeMake(screenWidth / 2 - 10.5, (screenWidth > 320 ? (screenWidth / 2 - 28) : (screenWidth / 2 - 28 + 10)));
    }
    
    [layout setHeaderReferenceSize:CGSizeMake(screenWidth, screenWidth * 0.45)];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 7;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, layout.minimumLineSpacing, 7);
    return [super initWithCollectionViewLayout:layout];
}

- (void)setupRefreshView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView;
    header.delegate = self;
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.delegate = self;
    self.footer = footer;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        if (self.pageIndex <= 5)
        {
            [self loadMoreVideoData];
        }
        else
        {
            [self.footer endRefreshing];
        }
    }
    else
    {
        [self loadNewVideoData];
    }
}

- (void)loadMoreVideoData
{
    [AndyHttpTool getSessionWithURL:[NSString stringWithFormat:@"http://apps.game.qq.com/wmp/public/search.php?page=%d&p0=cf&p1=999&source=cf_app", self.pageIndex] params:nil success:^(id dataStr) {
        
        //AndyLog(@"%@", json);
        NSString *midStr = [dataStr stringByReplacingOccurrencesOfString:@"var searchObj=" withString:@""];
        NSString *endStr = [midStr stringByReplacingOccurrencesOfString:@"}};" withString:@"}}"];
        //AndyLog(@"%@", endStr);
        
        NSData *data = [endStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        AndyVideoRootModel *videoRootModel = [AndyVideoRootModel objectWithKeyValues:dict];
 
        [self.videosM addObjectsFromArray:videoRootModel.msg.result];
        
        self.pageIndex++;
        
        [self.collectionView reloadData];
        
        [self.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
    }];
}

- (void)loadNewVideoData
{
    //
    self.pageIndex = 1;
    
    self.headerHasTry = NO;
    
    [AndyHttpTool getSessionWithURL:[NSString stringWithFormat:@"http://apps.game.qq.com/wmp/public/search.php?page=%d&p0=cf&p1=999&source=cf_app", self.pageIndex] params:nil success:^(id dataStr) {
        
        //AndyLog(@"%@", json);
        NSString *midStr = [dataStr stringByReplacingOccurrencesOfString:@"var searchObj=" withString:@""];
        NSString *endStr = [midStr stringByReplacingOccurrencesOfString:@"}};" withString:@"}}"];
        //AndyLog(@"%@", endStr);
        
        NSData *data = [endStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [self CommbineNewData:dict];
        
        self.pageIndex++;
        
        //AndyLog(@"%@", dict.description);
        
        [[NSString stringWithFormat:@"%@", dict.description] saveContentToFile:VideoCacheFileName atomically:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:VideoCacheFileName];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
            {
                NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                [self CommbineNewData:jsonDic];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.navigationController.view];
                [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:self.navigationController.view];
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
                [MBProgressHUD hideHUDForView:self.navigationController.view];
                [MBProgressHUD showError:LoadingError toView:self.navigationController.view];
            }
        }
        
        [self.header endRefreshing];
    }];
}

- (void)CommbineNewData:(id)json
{
    AndyVideoRootModel *videoRootModel = [AndyVideoRootModel objectWithKeyValues:json];
    
    [self.videosM removeAllObjects];
    
    [self.videosM addObjectsFromArray:videoRootModel.msg.result];
    
//    [videoRootModel.msg.result enumerateObjectsUsingBlock:^(AndyTXorAipaiVideoModel *  _Nonnull txorAipaiVideoModel, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (txorAipaiVideoModel.sExt3.length > 0)
//        {
//            AndyLog(@"%@", txorAipaiVideoModel.sTitle);
//        }
//    }];
    
    [self.collectionView reloadData];
    
    [self.header endRefreshing];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videosM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AndyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AndyVideoyId forIndexPath:indexPath];
    
    cell.imageFocusView.alpha = 0.0;
    
    cell.txorAipaiVideoModel = self.videosM[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //AndyLog(@"x:%f y:%f", self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    
    if ([AndyCommonFunction isNetworkConnected])
    {
        AndyTXorAipaiVideoModel *txorAipaiVideoModel = self.videosM[indexPath.item];
        
        self.txotAipaiViewModel = txorAipaiVideoModel;
        
        if ([AndyCommonFunction isWiFiEnabled])
        {
            [self decideJumpVideoPlayVcWithNewsModel:txorAipaiVideoModel];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"播放提示" message:@"当前为非WiFi网络，继续播放将消耗您的手机流量。确定要播放吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络提示" message:NetWorkOffline delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)decideJumpVideoPlayVcWithNewsModel:(AndyTXorAipaiVideoModel *)txorAipaiVideoModel
{
    if (txorAipaiVideoModel.sExt3.length > 0)
    {
        AndyVideoPlayViewController *videoPlayVc = [[AndyVideoPlayViewController alloc] init];
        videoPlayVc.playUrl = txorAipaiVideoModel.sExt3;
        videoPlayVc.videoTitle = txorAipaiVideoModel.sTitle;
        videoPlayVc.videoDesc = @"";
        videoPlayVc.imageUrl = txorAipaiVideoModel.sIMG;
        [self.navigationController pushViewController:videoPlayVc animated:NO];
    }
    else
    {
        [MBProgressHUD showMessage:IsDecodingQVideoUrl toView:self.navigationController.view];
        
        [AndyQVideoTool decodeQVideoUrlWithSVID:txorAipaiVideoModel.sVID success:^(NSString *result){
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            AndyVideoPlayViewController *videoPlayVc = [[AndyVideoPlayViewController alloc] init];
            videoPlayVc.playUrl = result;
            videoPlayVc.videoTitle = txorAipaiVideoModel.sTitle;
            videoPlayVc.videoDesc = @"";
            videoPlayVc.imageUrl = txorAipaiVideoModel.sIMG;
            [self.navigationController pushViewController:videoPlayVc animated:NO];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:DecodingQVideoUrlFailed toView:self.navigationController.view];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self decideJumpVideoPlayVcWithNewsModel:self.txotAipaiViewModel];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.collectionView setContentOffset:CGPointMake(0, -10000) animated:NO];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView.scrollEnabled = NO;
    AndyLog(@"我滚动了");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    AndyLog(@"滚动已停止");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
