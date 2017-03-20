//
//  HUImageItem.h
//  Pods
//
//  Created by mac on 16/11/10.
//
//

#import <Foundation/Foundation.h>

@interface HUImageItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (instancetype)imageItemWithImage:(UIImage *)image;

- (instancetype)initWithImage:(UIImage *)image;

@end
