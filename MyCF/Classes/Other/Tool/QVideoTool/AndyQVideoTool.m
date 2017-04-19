//
//  AndyQVideoTool.m
//  MyCF
//
//  Created by 李扬 on 15/12/16.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyQVideoTool.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "AndyVideoDecodeRootModel.h"
#import "AndyVdModel.h"
#import "AndyViModel.h"
#import "AndyUrlbkModel.h"
#import "AndyUiModel.h"

@implementation AndyQVideoTool

+ (void)decodeQVideoUrlWithSVID:(NSString *)sVid success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *sVidTrim = [sVid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [AndyHttpTool getSessionWithURL:[NSString stringWithFormat:@"http://vv.video.qq.com/geturl?otype=json&platform=3&vid=%@", sVidTrim] params:nil success:^(id dataStr) {
        if (success)
        {
            NSString *midStr = [dataStr stringByReplacingOccurrencesOfString:@"QZOutputJson=" withString:@""];
            NSString *endStr = [midStr stringByReplacingOccurrencesOfString:@"}};" withString:@"}}"];
            //AndyLog(@"%@", endStr);
            NSData *data = [endStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            AndyVideoDecodeRootModel *videoDecodeRootModel = [AndyVideoDecodeRootModel objectWithKeyValues:dict];
    
            success(((AndyViModel *)videoDecodeRootModel.vd.vi[0]).url);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

@end
