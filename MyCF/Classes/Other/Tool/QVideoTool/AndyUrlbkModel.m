//
//  AndyUrlbkModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyUrlbkModel.h"
#import "MJExtension.h"
#import "AndyUiModel.h"

@implementation AndyUrlbkModel

- (NSDictionary *)objectClassInArray
{
    return @{@"ui" : [AndyUiModel class]};
}

@end
