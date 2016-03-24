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

+ (instancetype)sharedInstance {
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
    return [[HUWebImageDownloader sharedInstance] cacheKeyForURL:url];
}

+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    return [[HUWebImageDownloader sharedInstance] imageFromDiskCacheForKey:key];
}

+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [[HUWebImageDownloader sharedInstance] imageFromMemoryCacheForKey:key];
}

+ (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock {
    return[[HUWebImageDownloader sharedInstance] downloadImageWithURL:url completed:completeBlock];
}

+ (void)downloadImageWithURL:(NSURL *)url option:(HUWebImageOption)option completed:(HUDownloadCompletionBlock)completeBlock {
    return[[HUWebImageDownloader sharedInstance] downloadImageWithURL:url option:option completed:completeBlock];
}

#pragma mark - save image

- (void)saveImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if (image == nil) {
        return;
    }
    if (toDisk) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [self saveImage:imageData toDiskForKey:key];
    }
    
    [self saveImage:image toMemoryForKey:key];
}

#pragma mark - cache key for url

- (NSString *)cacheKeyForURL:(NSURL *)url {
    return [url absoluteString];
}

#pragma mark - the image from disk for key

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    
    UIImage *image = [self imageFromMemoryCacheForKey:key]; //first from memory
    if (image) {
        NSLog(@"image from memory");
        return image;
    }
    UIImage *diskImage = [self diskImageForKey:key];
    if (diskImage && self.shouldCacheImagesInMemory) {
        NSLog(@"image from disk");
        NSUInteger cost = HUCacheCostForImage(diskImage);
        [self.webImageCache setObject:diskImage forKey:key cost:cost];
    }
    
    return diskImage;
}

#pragma mark - the image from memory for key

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.webImageCache objectForKey:key];
}

#pragma mark - download image for url whit option

- (void)downloadImageWithURL:(NSURL *)url option:(HUWebImageOption)option completed:(HUDownloadCompletionBlock)completeBlock {
    UIImage *image = [self imageFromDiskCacheForKey:[self cacheKeyForURL:url]];
    if (image) {
        if (completeBlock) {
            completeBlock(image, nil, url);
        }
        return;
    }
    
    dispatch_async(_webImageQueue, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLRequest *repuest = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:repuest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSLog(@"data: %zd", data.length/1024);
            UIImage *image = [UIImage hu_imageFromData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeBlock) {
                    completeBlock(image, nil, url);
                }
            });
            
            if (option == HUWebImageOptionMemoryAndDisk) {
                [self saveImage:data toDiskForKey:[self cacheKeyForURL:url]];
                [self saveImage:image toMemoryForKey:[self cacheKeyForURL:url]];
            }
            else if (option == HUWebImageOptionMemoryOnely) {
                [self saveImage:image toMemoryForKey:[self cacheKeyForURL:url]];
            }
            
            
            
            
        }];
        [task resume];
        
    });
}

- (void)downloadImageWithUrl:(NSURL *)url {
    
    
}

#pragma mark - download image for url and store to disk

- (void)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock {
    [self downloadImageWithURL:url option:HUWebImageOptionMemoryAndDisk completed:completeBlock];
}

#pragma mark - parvate

- (void)saveImage:(UIImage *)image toMemoryForKey:(NSString *)key {
    UIImage *memoryImage = [self imageFromMemoryCacheForKey:key]; //first from memory
    if (memoryImage == nil && image) {
        NSUInteger cost = HUCacheCostForImage(image);
        [self.webImageCache setObject:image forKey:key cost:cost];
        NSLog(@"save image to memory");
    }
}

#pragma mark - save image to disk

- (void)saveImage:(NSData *)imageData toDiskForKey:(NSString *)key {
    if (imageData == nil) {
        return;
    }
    UIImage *image = [self imageFromDiskCacheForKey:key];
    if (image) {
        return;
    }
    NSString *file = [self cacheFileForKey:key];
    dispatch_sync(_ioQueue, ^{
        NSLog(@"save data to disk %@", file);
        [imageData writeToFile:file atomically:YES];
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

- (NSString *)defaultCahePath {
    
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cacheDir stringByAppendingPathComponent:kDefaultDiskCachePath];
}

- (void)clearMemory {
    [self.webImageCache removeAllObjects];
}

@end
