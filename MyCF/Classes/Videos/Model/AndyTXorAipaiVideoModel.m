//
//  AndyTXorAipaiVideoModel.m
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyTXorAipaiVideoModel.h"

@implementation AndyTXorAipaiVideoModel

- (NSString *)sCreated
{
//    AndyLog(@"%@", _sCreated);
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSDate *date = [formatter dateFromString:_sCreated];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    AndyLog(@"%@", [formatter stringFromDate:date]);
//    return [formatter stringFromDate:date];
    
    return [self stringFromDate:[self dateFromString:_sCreated]];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate; 
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

@end
