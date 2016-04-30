//
//  HUImagePickerViewController.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kHUImagePickerOriginalImage;
extern NSString * const kHUImagePickerThumbnailImage;

@protocol HUImagePickerViewControllerDelegate;
@interface HUImagePickerViewController : UINavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate, HUImagePickerViewControllerDelegate> delegate;

/**
 * max selected count. default is 10
 */
@property (nonatomic) NSInteger maxAllowedCount;

/**
 * original image allowed ?  default is NO
 */
@property (nonatomic, assign) BOOL originalImageAllowed;

@end


@protocol HUImagePickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info;

@end