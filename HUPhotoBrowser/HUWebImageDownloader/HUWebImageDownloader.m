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


FOUNDATION_STATIC_INLINE NSUInteger HUCacheCostForImage(UIImage *image) {
    return image.size.width * image.size.height *image.scale * image.scale;
}

@interface HUWebImageDownloader ()

@property (nonatomic, strong) NSCache *webImageCache;
@property (nonatomic) dispatch_queue_t webImageQueue;
@property (nonatomic) dispatch_queue_t ioQueue;

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
        _shouldCacheImagesInMemory = YES;
        [self createDefaultCachePath];
        _webImageQueue = dispatch_queue_create("com.huwebimagedownloader", DISPATCH_QUEUE_SERIAL);
        _ioQueue = dispatch_queue_create("com.huwebimagedownloader.io", DISPATCH_QUEUE_SERIAL);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

+ (NSString *)cacheKeyForURL:(NSURL *)url {
   return [[HUWebImageDownloader sharedImageDownloader] cacheKeyForURL:url];
}

+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    return [[HUWebImageDownloader sharedImageDownloader] imageFromDiskCacheForKey:key];
}

+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [[HUWebImageDownloader sharedImageDownloader] imageFromMemoryCacheForKey:key];
}

+ (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock {
    return[[HUWebImageDownloader sharedImageDownloader] downloadImageWithURL:url completed:completeBlock];
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
    
    UIImage *image = [self imageFromDiskCacheForKey:[self cacheKeyForURL:url]];
    if (image) {
        if (completeBlock) {
            completeBlock(image, nil, url);
        }
        return;
    }
    
    dispatch_async(_webImageQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage hu_imageFromData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(image, nil, url);
            }
        });
        
        [self saveImage:data toDiskForKey:[self cacheKeyForURL:url]];
    });
    
}

#pragma mark - parvate

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
    UIImage *image = [self imageFromDiskCacheForKey:key];
    if (image) {
        return;
    }
    NSString *file = [self cacheFileForKey:key];
    dispatch_sync(_ioQueue, ^{
      
        [imageData writeToFile:file atomically:YES];
    });
}

- (NSString *)defaultCahePath {
    
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cacheDir stringByAppendingPathComponent:kDefaultDiskCachePath];
}

- (void)clearMemory {
    [self.webImageCache removeAllObjects];
}

@end
