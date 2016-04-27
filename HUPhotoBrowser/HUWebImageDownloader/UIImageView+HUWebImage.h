//
//  UIImageView+HUWebImage.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(NSURL *)url;
- (void)hu_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)hu_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image, NSError *error, NSURL *imageUrl))completed;

@end
