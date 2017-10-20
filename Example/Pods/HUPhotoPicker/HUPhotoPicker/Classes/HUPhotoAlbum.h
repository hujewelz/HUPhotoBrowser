//
//  HUPhotoAlbum.h
//  Pods
//
//  Created by jewelz on 2017/9/15.
//
//

#import <Foundation/Foundation.h>

@class PHAssetCollection;
@interface HUPhotoAlbum : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger assetCount;
@property (nonatomic, strong) PHAssetCollection *collection;

+ (instancetype)photoAlbumWithAssetCollection:(PHAssetCollection *)collection assetCount:(NSUInteger)count;
- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection assetCount:(NSUInteger)count;

@end
