//
//  AndyVideoModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyTXVideoModel : NSObject

@property (nonatomic, copy) NSString *videoType;

// 视频vid，重点根据这个来获取到真实的视频地址
@property (nonatomic, copy) NSString *vid;

 //此链接可能是爱拍的视频链接，但到目前为止还没遇到。VideoListModel.cs经常遇到爱拍的sExt3链接就是mp4格式的爱拍视频
@property (nonatomic, copy) NSString *videoUrl;

@end
