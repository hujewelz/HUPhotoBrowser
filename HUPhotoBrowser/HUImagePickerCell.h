//
//  HUImagePickerCell.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUImagePickerCell : UICollectionViewCell

+ (UINib *)nib;
+ (NSString *)reuserIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL didSelected;

@end
