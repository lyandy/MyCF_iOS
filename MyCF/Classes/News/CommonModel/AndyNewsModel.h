//
//  AndyNewsModel.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyTXVideoModel;

typedef enum :NSInteger {
    VideoType = 3,
    NewsType = 1,
    TopicType = 6,
    ActivityType = 2
} NewsTypeEnum;

@interface AndyNewsModel : NSObject

@property (nonatomic, copy) NSString *newsId;

@property (nonatomic, assign) NewsTypeEnum type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *publication_date;

@property (nonatomic, strong) AndyTXVideoModel *backup3;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL isVideo;

@end
