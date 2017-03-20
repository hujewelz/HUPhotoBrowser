//
//  HUImageItem.m
//  Pods
//
//  Created by mac on 16/11/10.
//
//

#import "HUImageItem.h"

@implementation HUImageItem

+ (instancetype)imageItemWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
        _selected = NO;
    }
    return self;
}

@end
