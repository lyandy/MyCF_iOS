//
//  AndyLiveItemModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndyLiveChannelModel.h"

@interface AndyLiveItemModel : NSObject

@property (nonatomic, copy) NSString *preview;

@property(nonatomic, strong) AndyLiveChannelModel *channel;

@property (nonatomic, assign) NSInteger viewers;

@property (nonatomic, copy) NSString *convertViewers;

@end
