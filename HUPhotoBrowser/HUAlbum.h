//
//  HUAlbum.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@interface HUAlbum : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) UIImage *album;


@end
