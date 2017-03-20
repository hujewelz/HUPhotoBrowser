//
//  UIImageView+HUWebImage.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(nullable NSURL *)url;
- (void)hu_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;
- (void)hu_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable void(^)(UIImage * __nullable image, NSError * __nullable error, NSURL * __nullable imageUrl))completed;

@end
