//
//  HUPhotoBrowserCell.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPhotoBrowserCellID @"HUPhotoBrowserCell"

@interface HUPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) UIImage *placeholderImage;

- (void)configureCellWithURLStrings:(NSString *)URLStrings;

@end
