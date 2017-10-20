//
//  HUImagePickerViewController.m
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUImagePickerViewController.h"
#import "HUAlbumTableViewController.h"
#import "HUImageGridViewController.h"
#import "HUPHAuthorizationNotDeterminedView.h"
#import "HUPHAuthorizationNotDeterminedViewController.h"
#import "Asset.h"
#import <Photos/Photos.h>

@interface HUImagePickerViewController ()

@end

@implementation HUImagePickerViewController
@synthesize delegate = _delegate;

- (instancetype)initWithMaxCount:(NSInteger)maxCount numberOfColumns:(NSInteger)columns {
    
    UIViewController *rootVc = nil;
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        rootVc = [[HUPHAuthorizationNotDeterminedViewController alloc] init];
    } else {
        rootVc = [[HUImageGridViewController alloc] init];
    }
    self = [super initWithRootViewController:rootVc];
    if (self) {
        _maxCount = maxCount;
        _numberOfColumns = columns;
        _spacing = 1.5;
    }
    return self;
}

- (instancetype)init {
    
    return [self initWithMaxCount:10 numberOfColumns:4];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UINavigationBar appearance] setTintColor:UIColorMake(30, 30, 30)];
    NSDictionary *titleAttribute = @{NSForegroundColorAttributeName:UIColorMake(30, 30, 30), NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttribute];
    
    //设置正常状态
    NSDictionary *attribute = @{NSForegroundColorAttributeName:UIColorMake(81, 88, 102), NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:attribute forState:UIControlStateNormal];
    
    //设置不可用状态
    NSDictionary *disAttribute = @{NSForegroundColorAttributeName:UIColorMake(209, 209, 209), NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:disAttribute forState:UIControlStateDisabled];
    
//    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
//    if (author == PHAuthorizationStatusNotDetermined || author == PHAuthorizationStatusAuthorized) {
//        HUAlbumTableViewController *vc = [[HUAlbumTableViewController alloc] init];
//        
//        [self pushViewController:vc animated:true];
//    }
    
}

- (void)setDelegate:(id<HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>)delegate {
    _delegate = delegate;
}

- (id<HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>)delegate {
    return _delegate;
}



@end
