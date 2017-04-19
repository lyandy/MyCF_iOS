//
//  AndyNewsCommonFrame.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyNewsModel;

@interface AndyNewsCommonFrame : NSObject

@property (nonatomic, strong) AndyNewsModel *newsModel;

@property (nonatomic, assign, readonly) CGRect topLineViewF;

@property (nonatomic, assign, readonly) CGRect imageFocusViewF;

@property (nonatomic, assign, readonly) CGRect titleViewF;

@property (nonatomic, assign, readonly) CGRect summaryViewF;

@property (nonatomic, assign, readonly) CGRect videoViewF;

@property (nonatomic, assign, readonly) CGRect timeViewF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
