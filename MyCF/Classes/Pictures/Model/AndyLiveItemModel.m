//
//  AndyLiveItemModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyLiveItemModel.h"

@implementation AndyLiveItemModel

- (NSString *)convertViewers
{
    if (self.viewers >= 10000)
    {
        _convertViewers = [NSString stringWithFormat:@"%.2f万", self.viewers / 10000.0];
    }
    else
    {
        _convertViewers = [NSString stringWithFormat:@"%ld", self.viewers];
    }
    return _convertViewers;
}

@end
