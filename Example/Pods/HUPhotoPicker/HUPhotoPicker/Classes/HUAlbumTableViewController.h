//
//  BAAlbumTableViewController.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHFetchResult;
@interface HUAlbumTableViewController : UITableViewController

@property (nonatomic, copy) void (^didSelectedAlbum)(NSString *title, PHFetchResult *fetchResult);

@end
