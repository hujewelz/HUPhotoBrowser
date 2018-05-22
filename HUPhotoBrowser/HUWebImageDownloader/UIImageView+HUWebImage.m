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
#import "hu_const.h"


static char *loadOperationKey = "loadOperationKey";
static char imageURLKey;

@implementation UIImageView (HUWebImage)

- (void)hu_setImageWithURL:(nullable NSURL *)url {
    [self hu_setImageWithURL:url placeholderImage:nil];
}

- (void)hu_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self hu_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)hu_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable void (^)(UIImage *, NSError *, NSURL *))completed {
    if (url == nil) {
      return;
    }
    self.image = nil;
    self.image = placeholder;
    [self hu_cancelImageDownloadOperationForKey:@"downloadimage"];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak __typeof(self) wself = self;
    HUWebImageDownloadOperation *operation = [HUWebImageDownloader downloadImageWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
        __strong __typeof (wself) sself = wself;
        if (!sself) {
          return ;
        }
        if (![[sself hu_imageURL].absoluteString isEqualToString:url.absoluteString]) {
            return;
        }
        
        dispatch_async_main({
            if (image) {
                sself.image = image;
                [sself setNeedsLayout];
            }
            else {
                sself.image = placeholder;
                [sself setNeedsLayout];
            }
            if (completed) {
                completed(image, error, imageUrl);
            }
        })
    }];
    if (operation) {
        [self hu_setImageDownloadOperation:operation forKey:@"downloadimage"];
    }

}



- (void)hu_setImageDownloadOperation:(id)operation forKey:(NSString *)key {
    if (key == nil) {
      return ;
    }
    [self hu_cancelImageDownloadOperationForKey:key];
    NSMutableDictionary *operations = [self operationDict];
    [operations setObject:operation forKey:key];
}

- (void)hu_cancelImageDownloadOperationForKey:(NSString *)key {
    NSMutableDictionary *operations = [self operationDict];
    
    id operation = operations[key];
    if ([operation isKindOfClass:[HUWebImageDownloadOperation class]]) {
        [operation cancel];
    }
    [operations removeObjectForKey:key];
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

- (NSURL *)hu_imageURL {
  return objc_getAssociatedObject(self, &imageURLKey);
}

@end
