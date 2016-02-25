//
//  HUWebImageDownloader.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "HUWebImageDownloader.h"
#import "NSString+HUExtension.h"
#import "UIImage+HUExtension.h"

static NSString *const kDefaultDiskCachePath = @"com.huwebimagedownloader";

inline NSUInteger HUCacheCostForImage(UIImage *image);

@interface HUWebImageDownloader ()

@property (nonatomic, strong) NSCache *webImageCache;

@end

@implementation HUWebImageDownloader

+ (instancetype)sharedImageDownloader {
    static HUWebImageDownloader *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [self new];
    });
    return downloader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _webImageCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    return [url absoluteString];
}

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    
    UIImage *diskImage = [self diskImageForKey:key];
    if (diskImage && self.shouldCacheImagesInMemory) {
        NSUInteger cost = HUCacheCostForImage(diskImage);
        [self.webImageCache setObject:diskImage forKey:key cost:cost];
    }

    return diskImage;
}
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.webImageCache objectForKey:key];
}

- (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock {
    char *label = "com.huwebimagedownloader";
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage hu_imageFromData:data];
        [self saveImage:data toDiskForKey:[self cacheKeyForURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(image, nil, url);
            }
        });
    });
    
}

- (UIImage *)diskImageForKey:(NSString *)key {
    NSString *fileName = [self cacheFileForKey:key];
    UIImage *img = [UIImage imageWithContentsOfFile:fileName];
    return img;
}




- (NSString *)cacheFileForKey:(NSString *)key {
    NSString *cachePath = [self defaultCahePath];
    return [cachePath stringByAppendingPathComponent:[key hu_md5]];
}

- (BOOL)createDefaultCachePath {

    NSString *cachePath = [self defaultCahePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExit = [fileManager fileExistsAtPath:cachePath isDirectory:&isDir];
    if (!(isDir && isDirExit)) {
        if ([fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return NO;
        }
    }
    
    return isDirExit;
}

- (void)saveImage:(NSData *)imageData toDiskForKey:(NSString *)key {

    NSString *file = [self cacheFileForKey:key];
    [imageData writeToFile:file atomically:YES];
}

- (NSString *)defaultCahePath {
    
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cacheDir stringByAppendingPathComponent:kDefaultDiskCachePath];
}

- (void)clearMemory {
    [self.webImageCache removeAllObjects];
}

@end
