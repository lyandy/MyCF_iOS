//
//  AndyTXorAipaiVideoModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyTXorAipaiVideoModel : NSObject

@property (nonatomic, copy) NSString *sVID;

@property (nonatomic, copy) NSString *sTitle;

@property (nonatomic, copy) NSString *sUrl;

@property (nonatomic, copy) NSString *detailurl;

@property (nonatomic, copy) NSString *sIMG;

//视频上传者，有可能没有
@property (nonatomic, copy) NSString *sAuthor;

@property (nonatomic, copy) NSString *iTime;

@property (nonatomic, copy) NSString *iTotalPlay;

@property (nonatomic, copy) NSString *sCreated;

//爱拍视频连接。当这个有内容的时候直接用这个来播放，不用再去解码sVid了
@property (nonatomic, copy) NSString *sExt3;

@end
