//
//  HUImageGridViewController.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HUImageGridViewController : UIViewController

@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;

@end
