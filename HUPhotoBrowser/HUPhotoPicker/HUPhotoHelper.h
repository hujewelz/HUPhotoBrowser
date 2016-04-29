//
//  HUPhotoHelper.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDidFetchCameraRollSucceedNotification;

#define IS_IOS8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

typedef void (^FetchPhotoSucceed)(NSArray *images, NSString *albumTitle);
typedef void (^FetchAlbumSucceed)(NSArray *albums);

@class HUAlbum, ALAssetsGroup, PHAssetCollection;
@interface HUPhotoHelper : NSObject

+ (instancetype)sharedInstance;

+ (void)fetchAlbums:(FetchAlbumSucceed)result;
+ (void)fetchAssetsInAssetCollection:(id)assetCollection resultHandler:(FetchPhotoSucceed)result;


/**所有的相薄*/
@property (nonatomic, readonly, strong) NSMutableArray *allCollections;

/**相机相册，所有相机拍摄的照片或视频都会出现在该相册中*/
@property (nonatomic, strong) id cameraRoll;

//- (void)fetchCameraRollWithResult:(void(^)(ALAssetsGroup *cameralGroup))result;

/**目标图片输出大小*/
//@property (nonatomic) CGSize targerSize;

//@property (nonatomic) NSInteger numberofAlbums;
- (void)fetchSelectedPhoto:(NSInteger)index;
@property (nonatomic, strong) NSMutableArray *originalImages;


@end
