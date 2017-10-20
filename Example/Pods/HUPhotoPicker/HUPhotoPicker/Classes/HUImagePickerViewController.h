//
//  HUImagePickerViewController.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUImagePickerViewController, PHAsset;
@protocol HUImagePickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerViewController:(nonnull HUImagePickerViewController *)imagePickerViewController
  didFinishPickingImageWithImages:(nonnull NSArray<UIImage *> *)images assets:(nullable NSArray<PHAsset *> *)assets;

- (void)imagePickerViewControllerDidBeginUploadImage:(nonnull HUImagePickerViewController *)imagePickerViewController;


@end

@interface HUImagePickerViewController : UINavigationController

- (instancetype _Nonnull )initWithMaxCount:(NSInteger)maxCount numberOfColumns:(NSInteger)columns;


@property (nonatomic, weak, nullable) id <HUImagePickerViewControllerDelegate, UINavigationControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSInteger numberOfColumns;

@property (nonatomic, assign) CGFloat spacing;

/// 是否允许通过网络下载iCloud图片，默认为 NO
@property (nonatomic, assign, getter=isNetworkAccessAllowed) BOOL networkAccessAllowed;

@end
