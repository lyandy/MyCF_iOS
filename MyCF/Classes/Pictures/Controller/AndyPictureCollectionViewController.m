//
//  AndyPictureCollectionViewController.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPictureCollectionViewController.h"
#import "AndyHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "AndyLiveCollectionViewCell.h"
#import "NSString+Andy.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AndyLiveRootModel.h"
#import "AndyLiveItemModel.h"
#import "AndyLiveWebViewController.h"

#define AndyLiveId @"LiveId"

@interface AndyPictureCollectionViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic, strong) NSMutableArray *LiveM;

@property (nonatomic, weak) MJRefreshHeaderView *header;

@end

@implementation AndyPictureCollectionViewController

- (NSMutableArray *)LiveM
{
    if (_LiveM == nil)
    {
        _LiveM = [NSMutableArray array];
    }
    return _LiveM;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"AndyLiveCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:AndyLiveId];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showMessage:LoadingInfo toView:self.navigationController.view];
    [self loadNewLiveData];
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat screenWidth = AndyMainScreenSize.width < AndyMainScreenSize.height ? AndyMainScreenSize.width : AndyMainScreenSize.height;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        layout.itemSize = CGSizeMake(screenWidth / 2 - 10.5, (screenWidth > 320 ? (screenWidth / 2 - 28) : (screenWidth / 2 - 28 + 10)));
    }
    
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
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadNewLiveData];
}

- (void)loadNewLiveData
{
    [AndyHttpTool getWithURL:@"http://api.plu.cn/tga/streams?sort-by=top&game=7&max-results=100" params:nil success:^(id json) {
        
        [self CommbineNewData:json];
        // 缓存
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:PictureCacheFileName atomically:YES];
        
    } failure:^(NSError *error)
     {
         NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:PictureCacheFileName];
         
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
    //AndyLog(@"%@", json);
    AndyLiveRootModel *rootModel = [AndyLiveRootModel objectWithKeyValues:json];
    
    [self.LiveM removeAllObjects];
    
    [self.LiveM addObjectsFromArray:rootModel.data.items];
    
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
    return self.LiveM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AndyLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AndyLiveId forIndexPath:indexPath];
    
    cell.imageFocusView.alpha = 0.0;
    
    cell.liveItemModel = self.LiveM[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AndyCommonFunction isNetworkConnected])
    {
        AndyLiveItemModel *liveItemModel = self.LiveM[indexPath.item];
        
        AndyLiveWebViewController *liveWebVc = [[AndyLiveWebViewController alloc] init];
        liveWebVc.url = liveItemModel.channel.url;
        
        [self.navigationController pushViewController:liveWebVc animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络提示" message:NetWorkOffline delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
