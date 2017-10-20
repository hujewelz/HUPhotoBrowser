//
//  BAPHAuthorizationNotDeterminedView.m
//  beautyAssistant
//
//  Created by jewelz on 2017/7/20.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUPHAuthorizationNotDeterminedView.h"
#import "Asset.h"
#import "UIView+HUConstraint.h"

@interface HUPHAuthorizationNotDeterminedView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HUPHAuthorizationNotDeterminedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.imageView];
    
    [self centerXOffset:0 forView:self.imageView];
    [self centerYOffset:-30 forView:self.imageView];
    
    
    [self addSubview:self.titleLabel];
    [self addConstraintsWithVisualFormat:@"V:[v0]-30-[v1]" views:@[self.imageView, self.titleLabel]];
    [self centerXOffset:0 forView:self.titleLabel];

    
    [self addSubview:self.descLabel];
    [self centerXOffset:0 forView:self.descLabel];
    [self addConstraintsWithVisualFormat:@"V:[v0]-8-[v1]" views:@[self.titleLabel, self.descLabel]];

    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = UIImageMake(@"Jurisdiction_icon");
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontBoldMake(17);
        _titleLabel.text = @"此应用没有权限访问您的照片或视频。";
        _titleLabel.textColor = UIColorMake(98, 107, 122);
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = UIFontMake(15);
        _descLabel.text = @"您可以在\"隐私设置\"中启用访问。";
        _descLabel.textColor = [UIColor lightGrayColor];
    }
    return _descLabel;
}

@end
