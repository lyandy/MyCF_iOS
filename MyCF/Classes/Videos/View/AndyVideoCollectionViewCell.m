//
//  AndyVideoCollectionViewCell.m
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AndyTXorAipaiVideoModel.h"
#import "NSString+Andy.h"
#import "UIImage+Andy.h"

#define AndyVideoTilteFont AndyMainScreenSize.width > 375 ? [UIFont systemFontOfSize:15] : (AndyMainScreenSize.width > 320 ? [UIFont systemFontOfSize:14] : [UIFont systemFontOfSize:13])
#define AndyVideoDurationAndPlayAndDateFont AndyMainScreenSize.width > 375 ? [UIFont systemFontOfSize:13] : (AndyMainScreenSize.width > 320 ? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:11])
#define AndyVideoImageWidth AndyMainScreenSize.width > 375 ? 11 : (AndyMainScreenSize.width > 320 ? 10 : 9)
#define AndyVideoTextVerticalOffset

@interface AndyVideoCollectionViewCell ()

@property (nonatomic, weak) UIView *durationBgView;

@property (nonatomic, weak) UILabel *durationLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *playImageView;

@property (nonatomic, weak) UILabel *playLabel;

@property (nonatomic, weak) UIImageView *dateImageView;

@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation AndyVideoCollectionViewCell

- (void)awakeFromNib
{
    self.backgroundColor = AndyColor(242, 242, 242, 1.0);
    [self setupSubViews];
    
    AndyLog(@"屏幕宽度：%f", AndyMainScreenSize.width);
}

- (void)setupSubViews
{
    UIImageView *imageFocusView = [[UIImageView alloc] init];
    imageFocusView.alpha = 0.0;
    self.imageFocusView = imageFocusView;
    [self.contentView addSubview:self.imageFocusView];
    
    UIView *durationBgView = [[UIView alloc] init];
    durationBgView.backgroundColor = AndyColor(0, 0, 0, 0.5);
    self.durationBgView = durationBgView;
    [self.imageFocusView addSubview:self.durationBgView];
    
    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.contentMode = UIViewContentModeCenter;
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.font = AndyVideoDurationAndPlayAndDateFont;
    self.durationLabel = durationLabel;
    [self.durationBgView addSubview:self.durationLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = AndyVideoTilteFont;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    UIImage *imgPlayNormal = [UIImage imageNamed:@"media_play"];
    UIImage *tintImgPlayNormal = [imgPlayNormal rt_tintedImageWithColor:AndyColor(0, 0, 0, 0.5)];
    playImageView.image = tintImgPlayNormal;
    self.playImageView = playImageView;
    [self.contentView addSubview:self.playImageView];
    
    UILabel *playLabel = [[UILabel alloc] init];
    playLabel.textColor = [UIColor grayColor];
    playLabel.font = AndyVideoDurationAndPlayAndDateFont;
    self.playLabel = playLabel;
    [self.contentView addSubview:self.playLabel];
    
    UIImageView *dateImageView = [[UIImageView alloc] init];
    UIImage *imgDateNormal = [UIImage imageNamed:@"media_time"];
    UIImage *tintImgDateNormal = [imgDateNormal rt_tintedImageWithColor:AndyColor(0, 0, 0, 0.5)];
    dateImageView.image = tintImgDateNormal;
    self.dateImageView = dateImageView;
    [self.contentView addSubview:self.dateImageView];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = AndyVideoDurationAndPlayAndDateFont;
    self.dateLabel = dateLabel;
    [self.contentView addSubview:self.dateLabel];
}

- (void)setTxorAipaiVideoModel:(AndyTXorAipaiVideoModel *)txorAipaiVideoModel
{
    _txorAipaiVideoModel = txorAipaiVideoModel;
    
    [self.imageFocusView setImageWithURL: [NSURL URLWithString:txorAipaiVideoModel.sIMG] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        [UIView animateWithDuration:0.3 animations:^{
            self.imageFocusView.alpha = 1.0;
        }];
    }];
    
    CGFloat imageFocusViewW = self.bounds.size.width;
    CGFloat imageFocusViewH = imageFocusViewW * 0.55;
    CGFloat imageFocusViewX = 0;
    CGFloat imageFocusViewY = 0;
    self.imageFocusView.frame = CGRectMake(imageFocusViewX, imageFocusViewY, imageFocusViewW, imageFocusViewH);
    
    CGFloat durationBgViewW = 40;
    CGFloat durationBgViewH = 20;
    CGFloat durationBgViewX = imageFocusViewW - durationBgViewW;
    CGFloat durationBgViewY = imageFocusViewH - durationBgViewH;
    self.durationBgView.frame = CGRectMake(durationBgViewX, durationBgViewY, durationBgViewW, durationBgViewH);
    
    self.durationLabel.text = txorAipaiVideoModel.iTime;
    NSMutableDictionary *durationLabelMD = [NSMutableDictionary dictionary];
    durationLabelMD[NSFontAttributeName] = AndyVideoDurationAndPlayAndDateFont;
    CGSize durationLabelSize = [self.durationLabel.text sizeWithAttributes:durationLabelMD];
    CGFloat durationLabelX = (durationBgViewW - durationLabelSize.width) / 2;
    CGFloat durationLabelY = (durationBgViewH - durationLabelSize.height) / 2;
    self.durationLabel.bounds = (CGRect){{durationLabelX, durationLabelY}, durationLabelSize};
    self.durationLabel.center = CGPointMake(durationBgViewW / 2, durationBgViewH / 2);
    
    CGFloat commonMargin = 5;
    
    self.titleLabel.text = txorAipaiVideoModel.sTitle;
    CGFloat titleLabelX = commonMargin;
    CGFloat titleLabelY = imageFocusViewH + commonMargin;
    CGSize titleLabelMaxSize = CGSizeMake(imageFocusViewW - 2 * commonMargin, 40);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize titleRealSize = [self.titleLabel.text sizeWithFont:AndyVideoTilteFont maxSize:titleLabelMaxSize];
    self.titleLabel.frame = (CGRect){{titleLabelX, titleLabelY}, titleRealSize};
    
    CGFloat playImageViewW = AndyVideoImageWidth;
    CGFloat playImageViewH = AndyVideoImageWidth;
    CGFloat playImageViewX = commonMargin;
    CGFloat playImageViewY = self.bounds.size.height - commonMargin - playImageViewH;
    self.playImageView.frame = CGRectMake(playImageViewX, playImageViewY, playImageViewW, playImageViewH);
    
    self.playLabel.text = txorAipaiVideoModel.iTotalPlay;
    CGFloat playLabelX = commonMargin + playImageViewW + 3;
    CGFloat playLabelY = playImageViewY - (AndyMainScreenSize.width > 320 ? 2.5 : 2);
    NSMutableDictionary *playLabelMD = [NSMutableDictionary dictionary];
    playLabelMD[NSFontAttributeName] = AndyVideoDurationAndPlayAndDateFont;
    CGSize playLabelSize = [self.playLabel.text sizeWithAttributes:playLabelMD];
    self.playLabel.frame = (CGRect){{playLabelX, playLabelY}, playLabelSize};
    
    self.dateLabel.text = txorAipaiVideoModel.sCreated;
    NSMutableDictionary *dateLabelMD = [NSMutableDictionary dictionary];
    dateLabelMD[NSFontAttributeName] = AndyVideoDurationAndPlayAndDateFont;
    CGSize dateLabelSize = [self.dateLabel.text sizeWithAttributes:dateLabelMD];
    CGFloat dateLabelX = self.bounds.size.width - commonMargin - dateLabelSize.width;
    CGFloat dateLabelY = playImageViewY - (AndyMainScreenSize.width > 320 ? 2.5 : 2);
    self.dateLabel.frame = (CGRect){{dateLabelX, dateLabelY}, dateLabelSize};

    CGFloat dateImageViewW = AndyVideoImageWidth;
    CGFloat dateImageViewH = AndyVideoImageWidth;
    CGFloat dateImageViewX = CGRectGetMinX(self.dateLabel.frame) - dateImageViewW - 3.0;
    CGFloat dateImageViewY = playImageViewY;
    self.dateImageView.frame = CGRectMake(dateImageViewX, dateImageViewY, dateImageViewW, dateImageViewH);
}
















@end
