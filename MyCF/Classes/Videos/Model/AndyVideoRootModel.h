//
//  AndyVideoRootModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyVideoMsgModel;

@interface AndyVideoRootModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) AndyVideoMsgModel *msg;

@end
