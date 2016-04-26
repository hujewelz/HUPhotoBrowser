//
//  HUImagePickerViewController.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUImagePickerViewController.h"
#import "HUImagePickerRootViewController.h"
#import "HUAlbumsViewController.h"
#import "HUPhotoHelper.h"

@interface HUImagePickerViewController ()

@end

@implementation HUImagePickerViewController
@dynamic delegate;

- (instancetype)init {
    HUImagePickerRootViewController *vc = nil;
    if (IS_IOS8_LATER) {
        vc = [[HUImagePickerRootViewController alloc] initWithAssetCollection:[HUPhotoHelper sharedInstance].cameraRoll];
    }
    else {
        vc = [[HUImagePickerRootViewController alloc] init];
    }
    _maxAllowedCount = 10;
    return [self initWithRootViewController:vc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self pushViewController:[HUAlbumsViewController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!IS_IOS8_LATER) {
        HUImagePickerRootViewController *topVc = (HUImagePickerRootViewController *)self.topViewController;
        topVc.assetCollection = [HUPhotoHelper sharedInstance].cameraRoll;
    }
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
