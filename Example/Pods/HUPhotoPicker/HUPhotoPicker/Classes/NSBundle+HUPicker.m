//
//  NSBundle+HUPicker.m
//  Pods
//
//  Created by jewelz on 2017/7/28.
//
//

#import "NSBundle+HUPicker.h"
#import "HUImagePickerViewController.h"

@implementation NSBundle (HUPicker)

+ (instancetype)hu_bundle {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSBundle *podBundle = [NSBundle bundleForClass:[HUImagePickerViewController class]];
        
        bundle = [NSBundle bundleWithPath:[podBundle pathForResource:@"HUPhotoPicker" ofType:@"bundle"]];
    }
    return bundle;
}

+ (UIImage *)hu_imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self hu_bundle] compatibleWithTraitCollection:nil];
}

@end
