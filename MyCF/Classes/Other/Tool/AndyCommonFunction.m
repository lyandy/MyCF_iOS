//
//  AndyCommonFunction.m
//  EyeSight
//
//  Created by 李扬 on 15/11/3.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonFunction.h"
#import "AndyTabBarController.h"
#import "AndyNavigationController.h"
#import "Reachability.h"
#import "SDImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AndyCommonFunction

+ (UIViewController *)getCurrentPerformanceUIViewContorller
{
    AndyTabBarController *andyTabBarVC =(AndyTabBarController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    
    //AndyLog(@"%@", andyTabBarVC.childViewControllers);
    
    AndyNavigationController *andyNavigationVC = (AndyNavigationController *)andyTabBarVC.childViewControllers[andyTabBarVC.selectedIndex];
    UIViewController *vc = (UIViewController *)andyNavigationVC.childViewControllers.lastObject;
    
    return vc;
}

+ (BOOL)isNetworkConnected
{
    return ([[Reachability reachabilityWithHostName:@"http://www.baidu.com"] currentReachabilityStatus] != NotReachable);

}

+ (BOOL)isWiFiEnabled
{
    if (self.isNetworkConnected)
    {
        return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
    }
    else
    {
        return NO;
    }
}

+ (NSString *)applicationDocumentsCacheDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"cache"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)getCacheFilePathWithFileName:(NSString *)fileName
{
    NSString *cachePath = [self applicationDocumentsCacheDirectory];
    
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@",cachePath, fileName];
    
    return cacheFilePath;
}

+ (NSString *)applicationDocumentsSplashScreenMobileImageDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"splashScreen/mobile"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)getSplashScreenMobileImagePathWithFileName:(NSString *)fileName
{
    NSString *imagePath = [self applicationDocumentsSplashScreenMobileImageDirectory];
    
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@",imagePath, fileName];
    
    return imageFilePath;
}

+ (NSString *)getSplashScreenMobileImageLocalPath
{
    NSString *path = [self getSplashScreenMobileImagePathWithFileName:@"phone.jpg"];
    
    if(![self checkFileIfExist:path])
    {
        path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    }
    
    return path;
}


+ (BOOL)checkFileIfExist:(NSString *)filePath
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:filePath])   //如果文件存在
    {
        return true;
    }
    else
    {
        return false;
    }
}
+ (NSString *)computeMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)countCacheSize
{
    unsigned long long int cacheFolderSize = [self getCacheFilesSize] * 45;
    
    NSString* strCacheSize;
    
    if( cacheFolderSize >= 1073741824)//GB
    {
        double value = (double)cacheFolderSize /1073741824;
        strCacheSize = [NSString stringWithFormat:@"%.2f GB",value];
    }
    else if( cacheFolderSize >= 1048576 )//MB
    {
        double value = (double)cacheFolderSize / 1048576;
        strCacheSize = [NSString stringWithFormat:@"%.2f MB",value];
    }
    else if( cacheFolderSize >= 1024 )//KB
    {
        double value = (double)cacheFolderSize / 1024;
        strCacheSize = [NSString stringWithFormat:@"%.2f KB",value];
    }
    else
    {
        strCacheSize = [NSString stringWithFormat:@"%lld Byte",cacheFolderSize];
    }
    
    return strCacheSize;
}

+ (unsigned long long int)getCacheFilesSize
{
    NSMutableArray *cacheFileList = [self getCacheFilePath];
    unsigned long long int cacheFolderSize = 0;
    NSFileManager  *manager = [NSFileManager defaultManager];
    
    //清理CACHE目录
    for(NSString* cacheFilePath in cacheFileList)
    {
        NSDictionary *cacheFileAttributes = [manager attributesOfItemAtPath:cacheFilePath error:nil];
        cacheFolderSize += [cacheFileAttributes fileSize];
    }
    return cacheFolderSize;
}

+ (NSMutableArray*)getCacheFilePath
{
    NSFileManager  *manager = [NSFileManager defaultManager];
    NSString* cacheDir = [self applicationDocumentsCacheDirectory];
    
    //显示所有子目录
    NSArray *cacheFileList = [manager subpathsAtPath:cacheDir];
    NSMutableArray *fullPathArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    for(NSString* cacheFilePath in cacheFileList)
    {
        NSString* fileFullPath = [cacheDir stringByAppendingPathComponent:cacheFilePath];
        [fullPathArray addObject:fileFullPath];
    }
    
    return fullPathArray;
}

+ (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSFileManager  *manager = [NSFileManager defaultManager];
    NSMutableArray *cacheFileList = [self getCacheFilePath];

    for(NSString* cacheFilePath in cacheFileList)
    {
        NSError *error;
        
        if(![manager removeItemAtPath:cacheFilePath error:&error])
        {
            //NSLog(@"%@: %@", cacheFilePath, [error localizedDescription]);
        }
    }
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
}


@end
