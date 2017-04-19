//
//  AndySliderBar.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AndySliderBar;

@protocol AndySliderBarDelegate <NSObject>

@optional
- (void)sliderBar:(AndySliderBar *)sliderBar didSelectedButtonFrom:(long)from to:(long)to;

@end

@interface AndySliderBar : UIView

- (void)setupSliderBarButtonsArray:(NSArray*)titleArr;

@property (nonatomic, weak) id<AndySliderBarDelegate> delegate;

@end
