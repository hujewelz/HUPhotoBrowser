//
//  HUPhotoAlbum.m
//  Pods
//
//  Created by jewelz on 2017/9/15.
//
//

#import "HUPhotoAlbum.h"
#import <Photos/Photos.h>

@implementation HUPhotoAlbum

+ (instancetype)photoAlbumWithAssetCollection:(PHAssetCollection *)collection assetCount:(NSUInteger)count {
    return [[self alloc] initWithAssetCollection:collection assetCount:count];
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection assetCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        self.title = collection.localizedTitle;
        self.collection = collection;
        self.assetCount = count;
    }
    return self;
}

@end
