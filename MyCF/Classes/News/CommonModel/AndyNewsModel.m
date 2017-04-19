//
//  AndyNewsModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsModel.h"

@implementation AndyNewsModel

- (BOOL)isVideo
{
    if (self.type == VideoType)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
