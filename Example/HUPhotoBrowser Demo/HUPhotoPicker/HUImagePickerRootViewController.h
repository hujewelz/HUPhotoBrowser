//
//  HUImagePickerViewController.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection;
@interface HUImagePickerRootViewController : UIViewController

- (instancetype)initWithAssetCollection:(id)assetCollection;
@property (nonatomic, strong) id assetCollection;

@end
