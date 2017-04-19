//
//  AndyCommonNewsTableViewCell.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonNewsTableViewCell.h"
#import "AndyNewsModel.h"
#import "AndyNewsCommonFrame.h"
#import "UIImageView+WebCache.h"

@interface AndyCommonNewsTableViewCell ()

@property (nonatomic, weak) UIImageView *imageFocusView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *summaryLabel;

@property (nonatomic, weak) UILabel *videoLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation AndyCommonNewsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"newsCommonId";
    
    AndyCommonNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil)
    {
        cell = [[AndyCommonNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.imageFocusView.alpha = 0.0;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor grayColor] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:0.5f];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
      [NSNumber numberWithInt:2],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, AndyMainScreenSize.width, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [self.contentView.layer addSublayer:shapeLayer];
    
    UIImageView *imageFocusView = [[UIImageView alloc] init];
    imageFocusView.alpha = 0.0;
    self.imageFocusView = imageFocusView;
    [self.contentView addSubview:self.imageFocusView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = AndyNewsTitleFont;
    titleLabel.textColor = AndyNewsTitleNotReadColor;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.numberOfLines = 0;
    summaryLabel.font = AndyNewsSummaryFont;
    summaryLabel.textColor = [UIColor grayColor];
    self.summaryLabel = summaryLabel;
    [self.contentView addSubview:self.summaryLabel];
    
    UILabel *videoLabel = [[UILabel alloc] init];
    videoLabel.alpha = 0.0;
    videoLabel.font = [UIFont systemFontOfSize:10];
    videoLabel.textColor = AndyColor(218, 93, 96, 1.0);
    videoLabel.text = @"视频";
    videoLabel.textAlignment = NSTextAlignmentCenter;
    videoLabel.layer.borderColor = AndyColor(218, 93, 96, 1.0).CGColor;
    videoLabel.layer.borderWidth = 0.5;
    videoLabel.layer.cornerRadius = 3;
    self.videoLabel = videoLabel;
    [self.contentView addSubview:videoLabel];

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = AndyNewsSummaryFont;
    timeLabel.textColor = [UIColor grayColor];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:self.timeLabel];
}

- (void)setNewsCommonFrame:(AndyNewsCommonFrame *)newsCommonFrame
{
    _newsCommonFrame = newsCommonFrame;
    
    AndyNewsModel *newsModel = newsCommonFrame.newsModel;
    
    [self.imageFocusView setImageWithURL:[NSURL URLWithString:newsModel.image_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [UIView animateWithDuration:0.3 animations:^{
            self.imageFocusView.alpha = 1.0;
        }];
    }];
    self.imageFocusView.frame = newsCommonFrame.imageFocusViewF;
    
    self.titleLabel.text = newsModel.title;
    self.titleLabel.frame = newsCommonFrame.titleViewF;
    
    self.summaryLabel.text = newsModel.summary;
    self.summaryLabel.frame = newsCommonFrame.summaryViewF;
    
    self.videoLabel.frame = newsCommonFrame.videoViewF;
    if (newsModel.isVideo)
    {
        self.videoLabel.alpha = 1.0;
    }
    else
    {
        self.videoLabel.alpha = 0.0;
    }
    
    self.timeLabel.text = newsModel.publication_date;
    self.timeLabel.frame = newsCommonFrame.timeViewF;
    
}














@end
