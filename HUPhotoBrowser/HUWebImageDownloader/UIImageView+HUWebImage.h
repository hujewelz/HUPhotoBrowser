//
//  UIImageView+HUWebImage.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(NSURL * __nonnull)url;
- (void)hu_setImageWithURL:(NSURL * __nonnull)url placeholderImage:(UIImage * __nullable)placeholder;
- (void)hu_setImageWithURL:(NSURL * __nonnull)url placeholderImage:(UIImage * __nullable)placeholder completed:(void(^__nullable)(UIImage * __nullable image, NSError * __nullable error, NSURL * __nullable imageUrl))completed;

@end
