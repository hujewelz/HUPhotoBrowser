//
//  HUPhotoHelper.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUPhotoHelper.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/Photos.h>
#endif
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "HUAlbum.h"

NSString * const kDidFetchCameraRollSucceedNotification = @"kDidFetchCameraRollSucceedNotification";

static const char *kIOQueueLable = "com.jewelz.assetqueue";
static NSString * const kOriginalImages = @"";

@interface HUPhotoHelper () {
    NSMutableArray *_photos;
    
}

@property (nonatomic, copy) FetchPhotoSucceed resutBlock;
@property (nonatomic, copy) FetchAlbumSucceed albumBlock;
@property (nonatomic) dispatch_queue_t ioQueue;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation HUPhotoHelper

+ (instancetype)sharedInstance {
    static HUPhotoHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [HUPhotoHelper new];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create(kIOQueueLable, DISPATCH_QUEUE_CONCURRENT);
        _photos = [NSMutableArray array];
        _originalImages = [NSMutableArray array];
        if (!IS_IOS8_LATER) {
            self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        }
        
    }
    return self;
}

+ (void)fetchAlbums:(FetchAlbumSucceed)result {
    HUPhotoHelper *helper = [HUPhotoHelper sharedInstance];
    helper.albumBlock = result;
    [helper getallAlbums];
}

+ (void)fetchAssetsInAssetCollection:(id)assetCollection resultHandler:(FetchPhotoSucceed)result {
    HUPhotoHelper *helper = [HUPhotoHelper sharedInstance];
    helper.resutBlock = result;
    [helper enumerateAssetsInAssetCollection:assetCollection original:NO];
}

#pragma mark - 获取相机胶卷

- (id)cameraRoll {
    if (IS_IOS8_LATER)
        return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {

            [[NSNotificationCenter defaultCenter] postNotificationName:kDidFetchCameraRollSucceedNotification object:group];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found!");
    }];
    return nil;
}

#pragma mark - 获取所有相簿
- (void)getallAlbums {
    NSMutableArray *albums = [NSMutableArray array];
    _allCollections = [NSMutableArray array];
    
    if (IS_IOS8_LATER) {
        dispatch_async(_ioQueue, ^{
            // 获得所有的自定义相簿
            PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            // 遍历所有的自定义相簿
            for (PHAssetCollection *assetCollection in assetCollections) {
                [_allCollections addObject:assetCollection];
                [albums addObject:[self enumerateAlbum:assetCollection]];
            }
            // 获得相机胶卷
            PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
            if (cameraRoll){
                [_allCollections addObject:cameraRoll];
                [albums addObject:[self enumerateAlbum:cameraRoll]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.albumBlock) {
                    self.albumBlock(albums);
                }
                
            });
        });

    }
    else {
    
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group) {
                
                [_allCollections addObject:group];
                [albums addObject:[self enumerateAlbum:group]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.albumBlock) {
                    self.albumBlock(albums);
                }
                
            });
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Group not found!");
        }];

       
    }
    
    
    
}

- (HUAlbum *)enumerateAlbum:(id )assetCollection {
    HUAlbum *album = [[HUAlbum alloc] init];
    if (IS_IOS8_LATER) {
        PHAssetCollection *assetC = (PHAssetCollection *)assetCollection;
//        NSLog(@"相簿名:%@", assetC.localizedTitle);
        album.title = assetC.localizedTitle;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        // 获得某个相簿中的所有PHAsset对象
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetC options:nil];
        album.imageCount = assets.count;
        PHAsset *asset = [assets firstObject];
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * result, NSDictionary * info) {
//            NSLog(@"album：%@", result);
            
            album.album = result;
            
        }];
        
    }
    else {
        ALAssetsGroup *group = (ALAssetsGroup *)assetCollection;
        album.title = [group valueForProperty:ALAssetsGroupPropertyName];
        album.imageCount = group.numberOfAssets;
        album.album = [UIImage imageWithCGImage:group.posterImage];
        
    }
   
    return album;
    
}


/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(id)assetCollection original:(BOOL)original {
    __block NSString *localizedTitle = nil;
    __block NSMutableArray *images = nil;
    dispatch_async(_ioQueue, ^{
        if (IS_IOS8_LATER) {
            PHAssetCollection *assetC = (PHAssetCollection *)assetCollection;
//            NSLog(@"相簿名:%@", assetC.localizedTitle);
            localizedTitle = assetC.localizedTitle;
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
                // 获得某个相簿中的所有PHAsset对象
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetC options:nil];
            images = [NSMutableArray arrayWithCapacity:assets.count];
            
            for (PHAsset *asset in assets) {
                // 是否要原图
                CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
                // 从asset中获得图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * result, NSDictionary * info) {
                    if (result) {
                        
                        [images addObject:result];
                    }
                }];
                
                [_photos addObject:asset];
            }
           
        }
        else {
            
            ALAssetsGroup *group = (ALAssetsGroup *)assetCollection;
            localizedTitle = [group valueForProperty:ALAssetsGroupPropertyName];
            images = [NSMutableArray arrayWithCapacity:group.numberOfAssets];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    [images addObject:[UIImage imageWithCGImage:result.thumbnail]];
                    [_photos addObject:result];
                }
                
            }];
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (self.resutBlock) {
                self.resutBlock(images,localizedTitle);
            }
        });
        
    });
}

- (void)fetchSelectedPhoto:(NSInteger)index {
    id photo = _photos[index];
   
    if (IS_IOS8_LATER) {
        PHAsset *asset = (PHAsset *)photo;
    
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * result, NSDictionary * info) {
            if (result) {
                [_originalImages addObject:result];
            }
            
        }];
    }
    else {
        ALAsset *result = (ALAsset *)photo;
        UIImage *image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
        if (image) {
            [_originalImages addObject:image];
        }
        
//        ALAssetRepresentation *representation = result.defaultRepresentation;
//        NSUInteger size = (NSUInteger)representation.size;
//        Byte *buffer = (Byte *)malloc(size);
//        NSUInteger length = [representation getBytes:buffer fromOffset:0 length:size error:nil];
//        NSLog(@"length: %u",length);
//        if (length != 0) {
//            NSData *data = [[NSData alloc ] initWithBytesNoCopy:buffer length:length freeWhenDone:YES];
//            NSLog(@"data: %@", data);
//        }
        
    }
  
}



@end
