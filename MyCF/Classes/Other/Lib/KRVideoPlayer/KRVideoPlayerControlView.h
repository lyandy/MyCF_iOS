//
//  KRVideoPlayerControlView.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRVideoPlayerController.h"

@interface KRVideoPlayerControlView : UIView
{
    //@public
    //NSString *_test;
}

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@property(nonatomic, strong) UIButton *lockButton;

@property(nonatomic, strong) UIButton *cameraButton;

@property(nonatomic, strong) UIButton *qualityButton;

@property (nonatomic, strong) UILabel *seekTimeLabel;

@property (nonatomic, weak) KRVideoPlayerController *krVideoPlayer;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

- (void)captureNoticeShow:(void (^)())completed;

- (void)combineQualityView:(NSArray *)qualityArray;

@end
