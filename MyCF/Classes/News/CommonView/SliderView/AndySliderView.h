//
//  AndySliderView.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndySliderView;

@protocol AndysliderViewDelegate <NSObject>

@optional
- (void)sliderView:(AndySliderView *)sliderView didScrollViewTo:(int)to;

@end

@interface AndySliderView : UIView

- (void)setupViewControllersArray:(NSArray *)vcArray;

@property (nonatomic, weak) id<AndysliderViewDelegate> delegate;

@end
