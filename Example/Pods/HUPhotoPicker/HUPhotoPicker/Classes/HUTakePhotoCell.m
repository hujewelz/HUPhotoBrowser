//
//  HUTakePhotoCell.m
//  Pods
//
//  Created by jewelz on 2017/9/15.
//
//

#import "HUTakePhotoCell.h"
#import "UIView+HUConstraint.h"
#import "Asset.h"

@implementation HUTakePhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:UIImageMake(@"album_photograph_icon") forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [self.contentView addSubview:button];
    
    [self.contentView addConstraintsWithVisualFormat:@"H:|[v0]|" views:@[button]];
    [self.contentView addConstraintsWithVisualFormat:@"V:|[v0]|" views:@[button]];
    
}


+ (NSString *)reuseIdentifier {
    return @"HUTakePhotoCell";
}


@end
