//
//  HUImageGridCell.m
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUImageGridCell.h"
#import "Asset.h"
#import "UIView+HUConstraint.h"
//#import "NSBundle+HUPicker.h"

@interface HUImageGridCell ()

@property (nonatomic, strong) UIButton *checkButton;


@end
@implementation HUImageGridCell

+ (NSString *)reuseIdentifier {
    return @"HUImageGridCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setModel:(HUImageSelectModel *)model {
    _model = model;
    
    [_checkButton setSelected:model.isSelected];
    if (model.isSelected) {
        NSString *title = [NSString stringWithFormat:@"%zd", model.index];
        [_checkButton setTitle:title forState:UIControlStateSelected];
    }
}

- (void)setIsDegraded:(BOOL)isDegraded {
    _isDegraded = isDegraded;
    self.degradedButton.hidden = !isDegraded;
//    NSLog(@"is degraded: %zd", isDegraded);
}

- (void)setupView {
    [self.contentView addSubview:self.thumbnail];
    
    [self.contentView addConstraintsWithVisualFormat:@"H:|[v0]|" views:@[self.thumbnail]];
    [self.contentView addConstraintsWithVisualFormat:@"V:|[v0]|" views:@[self.thumbnail]];
    
    [self.contentView addSubview:self.checkButton];
    [self.contentView addConstraintsWithVisualFormat:@"H:[v0(==22)]-2-|" views:@[self.checkButton]];
    [self.contentView addConstraintsWithVisualFormat:@"V:|-2-[v0(==22)]" views:@[self.checkButton]];
    
    
    [self.contentView addSubview:self.degradedButton];
    [self.contentView addConstraintsWithVisualFormat:@"H:|[v0]|" views:@[self.degradedButton]];
    [self.contentView addConstraintsWithVisualFormat:@"V:|[v0]|" views:@[self.degradedButton]];

}

- (UIImageView *)thumbnail {
    if (_thumbnail == nil) {
        _thumbnail = [UIImageView new];
        _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnail.backgroundColor = [UIColor redColor];
        _thumbnail.clipsToBounds = YES;
    }
    return _thumbnail;
}

- (UIButton *)checkButton {
    if (_checkButton == nil) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setBackgroundImage:UIImageMake(@"photo_button_normal") forState:UIControlStateNormal];
        [_checkButton setBackgroundImage:UIImageMake(@"photo_button_selected") forState:UIControlStateSelected];
        [_checkButton setTitle:nil forState:UIControlStateNormal];
        _checkButton.adjustsImageWhenHighlighted = NO;
        _checkButton.userInteractionEnabled = NO;
        [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _checkButton;
}

- (UIButton *)degradedButton {
    if (_degradedButton == nil) {
        _degradedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _degradedButton.adjustsImageWhenHighlighted = NO;
        //_degradedButton.backgroundColor = [UIColor redColor];
        _degradedButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _degradedButton;
}

@end
