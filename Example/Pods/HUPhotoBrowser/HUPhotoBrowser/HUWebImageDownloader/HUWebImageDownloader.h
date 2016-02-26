//
//  HUWebImageDownloader.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HUDownloadCompletionBlock)(UIImage *image, NSError *error, NSURL *imageUrl);

@interface HUWebImageDownloader : NSObject

+ (instancetype)sharedImageDownloader;
+ (NSString *)cacheKeyForURL:(NSURL *)url;
+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
+ (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock;

- (NSString *)cacheKeyForURL:(NSURL *)url;
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
- (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock;

@property (nonatomic) BOOL shouldCacheImagesInMemory;

@end
