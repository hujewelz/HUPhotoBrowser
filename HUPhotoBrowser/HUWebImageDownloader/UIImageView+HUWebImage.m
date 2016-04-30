//
//  UIImageView+HUWebImage.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "UIImageView+HUWebImage.h"
#import "HUWebImageDownloadOperation.h"
#import "HUWebImageDownloader.h"
#import <objc/runtime.h>

static char *loadOperationKey = "loadOperationKey";

@implementation UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(NSURL *)url {
    [self hu_setImageWithURL:url placeholderImage:nil];
}

- (void)hu_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self hu_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)hu_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *, NSError *, NSURL *))completed {
    self.image = nil;
    self.image = placeholder;
    [self hu_cancelImageDownloadOperationForKey:@"downloadimage"];
    __weak __typeof(self) wself = self;
    HUWebImageDownloadOperation *operation = [HUWebImageDownloader downloadImageWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
        if (image) {
            wself.image = image;
            [wself setNeedsDisplay];
            [wself layoutIfNeeded];
        }
        else {
            wself.image = placeholder;
            [wself setNeedsDisplay];
            [wself layoutIfNeeded];
        }
        if (completed) {
            completed(image, error, imageUrl);
        }
    }];
    if (operation) {
        [self hu_setImageDownloadOperation:operation forKey:@"downloadimage"];
    }

}

- (void)hu_setImageDownloadOperation:(id)operation forKey:(NSString *)key {
    [self hu_cancelImageDownloadOperationForKey:key];
    NSMutableDictionary *operations = [self operationDict];
    [operations setObject:operation forKey:key];
}

- (void)hu_cancelImageDownloadOperationForKey:(NSString *)key {
    NSMutableDictionary *operations = [self operationDict];
    
    id operation = operations[key];
    if ([operation isKindOfClass:[HUWebImageDownloadOperation class]]) {
        [operation cancel];
        operation = nil;
    }

}

- (NSMutableDictionary *)operationDict {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, loadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

@end
