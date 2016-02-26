//
//  UIImageView+HUWebImage.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "UIImageView+HUWebImage.h"
#import "HUWebImageDownloader.h"

@implementation UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(NSURL *)url {
    self.image = nil;
    
    [HUWebImageDownloader downloadImageWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
        self.image = image;
    }];
}

- (void)hu_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image {
    self.image = nil;
    self.image = image;
    [HUWebImageDownloader downloadImageWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
        self.image = image;
    }];
}

@end
