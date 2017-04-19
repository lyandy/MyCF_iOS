//
//  AndyVideoMsgModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoMsgModel.h"
#import "MJExtension.h"
#import "AndyTXorAipaiVideoModel.h"

@implementation AndyVideoMsgModel

- (NSDictionary *)objectClassInArray
{
    return @{@"result" : [AndyTXorAipaiVideoModel class]};
}

@end
