//
//  HUWebImageDownloader.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HUWebImageOption) {
    HUWebImageOptionNone,
    HUWebImageOptionMemoryOnely,
    HUWebImageOptionMemoryAndDisk,
};

typedef void(^HUDownloadCompletionBlock)( UIImage * __nullable image, NSError * __nullable error, NSURL * __nullable imageUrl);

@class HUWebImageDownloadOperation;
@interface HUWebImageDownloader : NSObject

+ (nonnull instancetype)sharedInstance;
+ (nonnull NSString *)cacheKeyForURL:(nonnull NSURL *)url;
+ (nullable UIImage *)imageFromDiskCacheForKey:(nonnull NSString *)key;
+ (nullable UIImage *)imageFromMemoryCacheForKey:(nonnull NSString *)key;
+ (nonnull HUWebImageDownloadOperation *)downloadImageWithURL:(nonnull NSURL *)url completed:(nullable HUDownloadCompletionBlock)completeBlock;
+ (nonnull HUWebImageDownloadOperation *)downloadImageWithURL:(nonnull NSURL *)url option:(HUWebImageOption)option completed:(nullable HUDownloadCompletionBlock)completeBlock;

- (nonnull NSString *)cacheKeyForURL:(nonnull NSURL *)url;
- (nullable UIImage *)imageFromDiskCacheForKey:(nonnull NSString *)key;
- (nullable UIImage *)imageFromMemoryCacheForKey:(nonnull NSString *)key;
- (void)saveImage:(nullable UIImage *)image forKey:(nonnull NSString *)key toDisk:(BOOL)toDisk;


- (nonnull HUWebImageDownloadOperation *)downloadImageWithURL:(nonnull NSURL *)url completed:(nullable HUDownloadCompletionBlock)completeBlock;


- (nonnull HUWebImageDownloadOperation *)downloadImageWithURL:(nonnull NSURL *)url option:(HUWebImageOption)option completed:(nullable HUDownloadCompletionBlock)completeBlock;

@property (nonatomic) BOOL shouldCacheImagesInMemory;

@end
