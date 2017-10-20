//
//  UIView+Constraint.h
//  HUPhotoPicker
//
//  Created by jewelz on 2017/7/28.
//

#import <UIKit/UIKit.h>

@interface UIView (HUConstraint)

- (void)addConstraintsWithVisualFormat:(nonnull  NSString *)formate views:(nonnull NSArray <UIView *>*)views;

- (void)centerView:(nonnull UIView *)view;

- (void)centerXOffset:(CGFloat)offsetX forView:(nonnull UIView *)view;

- (void)centerYOffset:(CGFloat)offsetY forView:(nonnull UIView *)view;

@end
