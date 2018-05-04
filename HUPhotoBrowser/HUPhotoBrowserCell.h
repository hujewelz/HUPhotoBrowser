//
//  HUPhotoBrowserCell.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPhotoBrowserCellID @"HUPhotoBrowserCell"
static NSString * const kPhotoCellDidZommingNotification = @"kPhotoCellDidZommingNotification";
static NSString * const kPhotoCellDidImageLoadedNotification = @"kPhotoCellDidImageLoadedNotification";

@interface HUPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)resetZoomingScale;

- (void)resizeImageView;

- (void)startAnimating;

- (void)stopAnimating;

@property (nonatomic, copy) void(^tapActionBlock)(UITapGestureRecognizer *tapGesture);

@end
