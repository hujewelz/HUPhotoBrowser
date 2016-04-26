//
//  HUAlbumCell.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUAlbum;
@interface HUAlbumCell : UITableViewCell

+ (UINib *)nib;
+ (NSString *)reuserIdentifier;

@property (nonatomic, strong) HUAlbum *album;



@end
