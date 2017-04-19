//
//  AndyHeaderSliderDetailView.h
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AndyNewsModel;

@interface AndyHeaderSliderDetailView : UIView

@property (nonatomic, assign) BOOL isFromNews;

@property(nonatomic, strong) AndyNewsModel *newsModel;

@end
