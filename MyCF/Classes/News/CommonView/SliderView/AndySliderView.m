//
//  AndySliderView.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySliderView.h"
#import "AndyNewsBaseTableViewController.h"
#import "AndySliderBar.h"

@interface AndySliderView () <AndySliderBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<AndyNewsBaseTableViewController *> *vcArray;

@end

@implementation AndySliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewWidth = AndyMainScreenSize.width;
    CGFloat scrollViewHeight = AndyMainScreenSize.height - scrollViewY;
    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewWidth, scrollViewHeight);
    scrollView.delegate = self;
    //一定也要把这里的UIScrollView的ScrollsToTop设置为NO，不然即使将子TableView其中一个的scrollsToTop设置为NO，视图中任然存在两个scrollsToTop为YES的UIScrollView，系统就不知道该滚动哪一个，也就点击顶部status bar不出现列表滚动到顶部。详情请参见苹果官方解释
    scrollView.scrollsToTop = NO;
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
}

- (void)setupViewControllersArray:(NSArray *)vcArray
{
    self.vcArray = vcArray;
    
//    CGFloat childVCW = self.scrollView.frame.size.width;
//    CGFloat childVCH = self.scrollView.frame.size.height - 0;
//    CGFloat childVCY = 0;
//    
//    for (int i = 0; i < vcArray.count; i++)
//    {
//        CGFloat childVCX = i *childVCW;
//        
//        AndyNewsBaseTableViewController *newsBaseTableViewVC = [vcArray objectAtIndex:i];
//        newsBaseTableViewVC.view.frame = CGRectMake(childVCX, childVCY, childVCW, childVCH);
//        [self.scrollView addSubview:newsBaseTableViewVC.view];
//    }
    
    CGFloat contentW = vcArray.count * self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

- (void)sliderBar:(AndySliderBar *)slideBar didSelectedButtonFrom:(long)from to:(long)to
{
    CGFloat contentOffsetX = to * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(contentOffsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
    [self loadDataAndCombineData:(int)to];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 取出子控制器
    UIViewController *vc = self.vcArray[index];
    vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, AndyMainScreenSize.width, scrollView.frame.size.height);
    [scrollView addSubview:vc.view];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat scrollW = scrollView.frame.size.width;
//    
////    int pageNum = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
//    int pageNum = scrollView.contentOffset.x/ scrollW;
//    
//    if ([self.delegate respondsToSelector:@selector(sliderView:didScrollViewTo:)])
//    {
//        [self.delegate sliderView:self didScrollViewTo:pageNum];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    
    CGFloat scrollW = scrollView.frame.size.width;
    
    //int pageNum = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    int pageNum = scrollView.contentOffset.x / scrollW;
    
    if ([self.delegate respondsToSelector:@selector(sliderView:didScrollViewTo:)])
    {
        [self.delegate sliderView:self didScrollViewTo:pageNum];
    }
    
    [self loadDataAndCombineData:pageNum];
}

- (void)loadDataAndCombineData:(int)pageNum
{
    AndyNewsBaseTableViewController *newsBaseTableViewVC = self.vcArray[pageNum];
    
    for (int num = 0; num < self.vcArray.count; num++)
    {
        if (num != pageNum)
        {
            AndyNewsBaseTableViewController *otherVC = self.vcArray[num];
            otherVC.tableView.scrollsToTop = NO;
        }
    }
    
    newsBaseTableViewVC.tableView.scrollsToTop = YES;
    
    if (newsBaseTableViewVC.dataFrame.count == 0)
    {
        [newsBaseTableViewVC beginRefresh];
    }
}












@end
