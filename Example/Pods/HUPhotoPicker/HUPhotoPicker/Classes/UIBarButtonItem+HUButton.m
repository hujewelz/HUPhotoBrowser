//
//  UIBarButtonItem+HUButton.m
//  Pods
//
//  Created by jewelz on 2017/7/29.
//
//

#import "UIBarButtonItem+HUButton.h"

@implementation UIBarButtonItem (HUButton)

+ (instancetype)leftItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
