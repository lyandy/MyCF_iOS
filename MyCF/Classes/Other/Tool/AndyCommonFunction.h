//
//  AndyCommonFunction.h
//  EyeSight
//
//  Created by 李扬 on 15/11/3.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AndyVideoListBaseModel;

@interface AndyCommonFunction : NSObject

+ (BOOL)isNetworkConnected;

+ (BOOL)isWiFiEnabled;

+ (UIViewController *)getCurrentPerformanceUIViewContorller;

+ (NSString *)applicationDocumentsCacheDirectory;

+ (NSString *)getCacheFilePathWithFileName:(NSString *)fileName;

+ (NSString *)getVideoDownloadFilePathWithFileName:(NSString *)fileName;

+ (NSString *)applicationDocumentsSplashScreenMobileImageDirectory;

+ (NSString *)getSplashScreenMobileImagePathWithFileName:(NSString *)fileName;

+ (NSString *)getSplashScreenMobileImageLocalPath;

+ (BOOL)checkFileIfExist:(NSString *)filePath;

+ (NSString *)computeMD5:(NSString *)str;

+ (NSString *)countCacheSize;

+ (unsigned long long int)getCacheFilesSize;

+ (NSMutableArray*)getCacheFilePath;

+ (void)clearCache;

+ (void)initUserDefaults;

@end
