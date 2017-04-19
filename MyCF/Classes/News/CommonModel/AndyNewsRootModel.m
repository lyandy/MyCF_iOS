//
//  AndyNewsRootModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNewsRootModel.h"
#import "MJExtension.h"
#import "AndyNewsModel.h"

@implementation AndyNewsRootModel

- (NSDictionary *)objectClassInArray
{
    return @{@"ads" : [AndyNewsModel class], @"news" : [AndyNewsModel class]};
}

@end
