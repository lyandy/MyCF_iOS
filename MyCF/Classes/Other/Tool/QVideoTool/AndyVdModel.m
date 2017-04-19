//
//  AndyVdModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVdModel.h"
#import "MJExtension.h"
#import "AndyViModel.h"

@implementation AndyVdModel

- (NSDictionary *)objectClassInArray
{
    return @{@"vi" : [AndyViModel class]};
}

@end
