//
//  AndyNewsRootModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyNewsRootModel : NSObject

@property (nonatomic, strong) NSArray *ads;

@property (nonatomic, strong) NSArray *news;

@property (nonatomic, assign) BOOL next_page;

@end
