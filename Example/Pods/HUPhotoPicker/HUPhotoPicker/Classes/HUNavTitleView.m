//
//  NavTitleView.m
//  HUPhotoPicker
//
//  Created by jewelz on 2017/9/27.
//

#import "HUNavTitleView.h"
#import "NSBundle+HUPicker.h"

@interface HUNavTitleView()

@end

@implementation HUNavTitleView

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width * 2 - 3, 0, 0)];
    
    CGFloat titleWidth = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width + 3;
    //CGFloat titleWidth = self.titleLabel.bounds.size.width;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth)];
   
    
}

@end
