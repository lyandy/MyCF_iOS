//
//  AndyShareView+Andy.m
//  EyeSight
//
//  Created by 李扬 on 15/12/1.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyShareView+Andy.h"
#import "AndyShareView.h"
#import "AndyVideoListBaseModel.h"

@implementation AndyShareView (Andy)

+ (void)showShareViewWithVideoModel:(AndyVideoListBaseModel *)videoModel
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];

    if([view isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
    {
        unsigned long windowCounts = [UIApplication sharedApplication].windows.count;
        if (windowCounts >= 2)
        {
            view = [UIApplication sharedApplication].windows[1];
        }
    }
    
    AndyShareView *shareView = [[AndyShareView alloc] initWithFrame:view.bounds];
    
    shareView.videoModel = videoModel;
    
    [view addSubview:shareView];
}

@end
