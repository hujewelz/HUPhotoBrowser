//
//  HUPhotoBrowserCell.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPhotoBrowserCellID @"HUPhotoBrowserCell"
static NSString *const kPhotoCellDidZommingNotification = @"kPhotoCellDidZommingNotification";

@interface HUPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)resetZoomingScale;


- (void)configureCellWithURLStrings:(NSString *)URLStrings;

@end
