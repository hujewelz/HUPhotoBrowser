//
//  UIView+Constraint.m
//  HUPhotoPicker
//
//  Created by jewelz on 2017/7/28.
//

#import "UIView+HUConstraint.h"

@implementation UIView (HUConstraint)

- (void)addConstraintsWithVisualFormat:(nonnull  NSString *)formate views:(nonnull NSArray <UIView *>*)views {
    if (views.count == 0) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    __block NSString *key = @"";
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        key = [NSString stringWithFormat:@"v%zd", idx];
        [dict setObject:view forKey:key];
    }];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formate options:0 metrics:nil views:dict]];
}

- (void)centerView:(nonnull UIView *)view {
    [self centerXOffset:0 forView:view];
    [self centerYOffset:0 forView:view];
}

- (void)centerXOffset:(CGFloat)offsetX forView:(nonnull UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:offsetX]];
}

- (void)centerYOffset:(CGFloat)offsetY forView:(nonnull UIView *)view {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:offsetY]];

}

@end
