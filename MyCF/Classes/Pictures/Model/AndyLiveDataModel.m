//
//  AndyLiveDataModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyLiveDataModel.h"
#import "MJExtension.h"
#import "AndyLiveItemModel.h"

@implementation AndyLiveDataModel

- (NSDictionary *)objectClassInArray
{
    return @{@"items" : [AndyLiveItemModel class]};
}

@end
