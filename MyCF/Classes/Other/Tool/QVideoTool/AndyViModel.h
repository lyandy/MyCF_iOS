//
//  AndyViModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyUrlbkModel;

@interface AndyViModel : NSObject

@property (nonatomic, copy) NSString *lnk;

@property (nonatomic, copy) NSString *url;

@property(nonatomic, strong) AndyUrlbkModel *urlbk;

@end
