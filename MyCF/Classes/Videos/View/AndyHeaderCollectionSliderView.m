//
//  AndyHeaderCollectionView.m
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyHeaderCollectionSliderView.h"
#import "AndyNewsModel.h"
#import "AndyHeaderSliderDetailView.h"

@interface AndyHeaderCollectionSliderView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UIPageControl *performPageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AndyHeaderCollectionSliderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bounds = CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.width * 0.45);
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = self.bounds;
    scrollView.scrollsToTop = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = AndyPerformanceColor;
    pageControl.alpha = 0.0;
    self.pageControl = pageControl;
    [self addSubview:self.pageControl];
    
    UIPageControl *performPageControl = [[UIPageControl alloc] init];
    performPageControl.currentPageIndicatorTintColor = AndyPerformanceColor;
    self.performPageControl = performPageControl;
    [self addSubview:self.performPageControl];
}

- (void)setupScrollViewSubviewsWithArray:(NSArray *)modelArray
{
    [self removeTimer];
    
    for(UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat sliderDetailW = self.scrollView.frame.size.width;
    CGFloat sliderDetailH = self.scrollView.frame.size.height;
    CGFloat sliderDetailY = 0;
    
    AndyHeaderSliderDetailView *sliderDetailViewEnd = [[AndyHeaderSliderDetailView alloc] initWithFrame:CGRectMake(0, sliderDetailY, sliderDetailW, sliderDetailH)];
    sliderDetailViewEnd.newsModel = (AndyNewsModel *)modelArray[modelArray.count - 1];
    [self.scrollView addSubview:sliderDetailViewEnd];
    
    for (int i = 0; i < modelArray.count; i++)
    {
        CGFloat sliderDetailX = (i + 1) * sliderDetailW;
        
        AndyHeaderSliderDetailView *sliderDetailView = [[AndyHeaderSliderDetailView alloc] initWithFrame:CGRectMake(sliderDetailX, sliderDetailY, sliderDetailW, sliderDetailH)];
        sliderDetailView.isFromNews = NO;
        sliderDetailView.newsModel = (AndyNewsModel *)modelArray[i];
        
        [self.scrollView addSubview:sliderDetailView];
    }
    
    AndyHeaderSliderDetailView *sliderDetailViewStart = [[AndyHeaderSliderDetailView alloc] initWithFrame:CGRectMake((modelArray.count + 1) * sliderDetailW, sliderDetailY, sliderDetailW, sliderDetailH)];
    sliderDetailViewStart.newsModel = (AndyNewsModel *)modelArray[0];
    [self.scrollView addSubview:sliderDetailViewStart];
    
    CGFloat contentW = (modelArray.count + 2) * sliderDetailW;
    
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    CGFloat pageControlW = modelArray.count * 15;
    CGFloat pageControlH = 28;
    CGFloat pageControlX = self.bounds.size.width - pageControlW - 5;
    CGFloat pageControlY = self.bounds.size.height - 28;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    self.performPageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    self.pageControl.numberOfPages = (modelArray.count + 2);
    self.performPageControl.numberOfPages = modelArray.count;
    
    [self.scrollView setContentOffset:CGPointMake(sliderDetailW, 0) animated:NO];
    self.pageControl.currentPage = 1;
    self.performPageControl.currentPage = self.pageControl.currentPage - 1;
    
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollW = scrollView.frame.size.width;
    
    int pageNum = scrollView.contentOffset.x / scrollW;
    
    if(pageNum==0)
    {
        pageNum = (int)self.pageControl.numberOfPages-2;
        
    }else if(pageNum == self.pageControl.numberOfPages-1)
    {
        pageNum = 1;
    }
    
    self.pageControl.currentPage = pageNum;
    self.performPageControl.currentPage = self.pageControl.currentPage - 1;
    
    CGFloat contentOffsetX = pageNum * scrollW;
    CGPoint offset = CGPointMake(contentOffsetX, 0);
    
    [self.scrollView setContentOffset:offset animated:NO];
}

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)nextPage
{
    CGFloat scrollW = self.scrollView.frame.size.width;
    
    int pageNum = self.scrollView.contentOffset.x / scrollW;
    
    if(pageNum==0)
    {
        pageNum = (int)self.pageControl.numberOfPages-2;
        
    }else if(pageNum == self.pageControl.numberOfPages-1)
    {
        pageNum = 1;
    }
    else
    {
        pageNum++;
    }
    
    CGFloat contentOffsetX = pageNum * scrollW;
    CGPoint offset = CGPointMake(contentOffsetX, 0);
    
    [self.scrollView setContentOffset:offset animated:YES];
    
    if (pageNum == self.pageControl.numberOfPages - 1)
    {
        pageNum = 1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];
        });
    }
    
    self.pageControl.currentPage = pageNum;
    self.performPageControl.currentPage = self.pageControl.currentPage - 1;
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}


@end
