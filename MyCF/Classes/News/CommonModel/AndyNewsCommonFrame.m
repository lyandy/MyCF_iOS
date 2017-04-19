//
//  AndyNewsCommonFrame.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsCommonFrame.h"
#import "AndyNewsModel.h"
#import "NSString+Andy.h"

@implementation AndyNewsCommonFrame

- (void)setNewsModel:(AndyNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    CGFloat cellW = AndyMainScreenSize.width;
    
    _topLineViewF = CGRectMake(0, 0, cellW, 1);
    
    CGFloat commonTopAndBottomMargin = 5.5;
    CGFloat commonLeftAndRightMargin = 8.0;

    
    CGFloat imageViewX = commonLeftAndRightMargin;
    CGFloat imageViewY = CGRectGetMaxY(_topLineViewF) + commonTopAndBottomMargin;
    CGFloat imageViewWidth = 90;
    CGFloat imageViewHeight = 70;
    _imageFocusViewF = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    
    CGFloat titleX = CGRectGetMaxX(_imageFocusViewF) + commonLeftAndRightMargin;
    CGFloat titleY = CGRectGetMaxY(_topLineViewF) + commonTopAndBottomMargin;
    // 文字计算的最大尺寸 -- MJ方法
    CGSize titleMaxSize = CGSizeMake(AndyMainScreenSize.width - 3 * commonLeftAndRightMargin - _imageFocusViewF.size.width, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize titleRealSize = [newsModel.title sizeWithFont:AndyNewsTitleFont maxSize:titleMaxSize];
    _titleViewF = (CGRect){{titleX, titleY}, titleRealSize};
    
    CGFloat summaryX = CGRectGetMinX(_titleViewF);
    CGFloat summaryY = CGRectGetMaxY(_titleViewF) + commonTopAndBottomMargin;
    // 文字计算的最大尺寸 -- MJ方法
    CGSize summaryMaxSize = CGSizeMake(AndyMainScreenSize.width - 3 * commonLeftAndRightMargin - _imageFocusViewF.size.width, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize summaryRealSize = [newsModel.summary sizeWithFont:AndyNewsSummaryFont maxSize:summaryMaxSize];
    _summaryViewF = (CGRect){{summaryX, summaryY}, summaryRealSize};
    
    NSMutableDictionary *timeLabelMD = [NSMutableDictionary dictionary];
    timeLabelMD[NSFontAttributeName] = AndyNewsSummaryFont;
    CGSize timeLabelSize = [newsModel.publication_date sizeWithAttributes:timeLabelMD];
    CGFloat timeLabelX = cellW - commonLeftAndRightMargin - timeLabelSize.width;
    CGFloat timeLabelY = CGRectGetMaxY(_imageFocusViewF) - timeLabelSize.height;
    _timeViewF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    
    NSMutableDictionary *videoLabelMD = [NSMutableDictionary dictionary];
    videoLabelMD[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    CGSize videoLabelSize = [@"视频" sizeWithAttributes:videoLabelMD];
//    CGFloat videoLabelX = CGRectGetMinX(_timeViewF) - commonLeftAndRightMargin - videoLabelSize.width;
    CGFloat videoLabelX = AndyMainScreenSize.width - 135 - commonLeftAndRightMargin - videoLabelSize.width;
    CGFloat videoLabelY = CGRectGetMinY(_timeViewF);
    _videoViewF = (CGRect){{videoLabelX, videoLabelY}, videoLabelSize};
    
    _cellHeight = CGRectGetMaxY(_imageFocusViewF) + commonTopAndBottomMargin;

}
















@end
