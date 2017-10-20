//
//  BAAlbumCell.m
//  beautyAssistant
//
//  Created by jewelz on 2017/6/26.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUAlbumCell.h"
#import "NSBundle+HUPicker.h"
#import "NSBundle+HUPicker.h"

@implementation HUAlbumCell

+ (UINib *)nib {
   // NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    
    return [UINib nibWithNibName:@"HUAlbumCell" bundle:[NSBundle hu_bundle]];
}

+ (NSString *)reuseIdentifier {
    return @"BAAlbumCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
