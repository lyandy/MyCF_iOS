//
//  AndyQVideoTool.h
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyQVideoTool : NSObject

+ (void)decodeQVideoUrlWithSVID:(NSString *)sVid success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;

@end
