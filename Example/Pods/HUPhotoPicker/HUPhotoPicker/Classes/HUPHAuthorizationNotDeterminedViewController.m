//
//  HUPHAuthorizationNotDeterminedViewController.m
//  beautyAssistant
//
//  Created by jewelz on 2017/7/20.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUPHAuthorizationNotDeterminedViewController.h"
#import "HUPHAuthorizationNotDeterminedView.h"
#import "HUImagePickerViewController.h"

@interface HUPHAuthorizationNotDeterminedViewController ()

@property (nonatomic, strong) HUPHAuthorizationNotDeterminedView *notDeterminedView;

@end

@implementation HUPHAuthorizationNotDeterminedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];

    [self.view addSubview:self.notDeterminedView];
}

#pragma mark - Action

- (void)rightBarItemClicked {
    //[SVProgressHUD dismiss];
    if ([self.navigationController isKindOfClass:[HUImagePickerViewController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (HUPHAuthorizationNotDeterminedView *)notDeterminedView {
    if (_notDeterminedView == nil) {
        _notDeterminedView = [[HUPHAuthorizationNotDeterminedView alloc] initWithFrame:self.view.bounds];
    }
    return _notDeterminedView;
}

@end
