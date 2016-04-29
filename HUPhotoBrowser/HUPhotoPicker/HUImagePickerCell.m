//
//  HUImagePickerCell.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUImagePickerCell.h"

@interface HUImagePickerCell ()

@property (weak, nonatomic) IBOutlet UIView *mask;


@end

@implementation HUImagePickerCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"HUImagePickerCell" bundle:nil];
}

+ (NSString *)reuserIdentifier {
    return @"HUImagePickerCell";
}

- (void)awakeFromNib {
    // Initialization code
    self.mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

//- (void)setSelected:(BOOL)selected {
//    //[super setSelected:self];
//    
//    self.mask.hidden = !selected;
//}

- (void)setDidSelected:(BOOL)didSelected {
    _didSelected = didSelected;
    self.mask.hidden = !didSelected;
}

@end
