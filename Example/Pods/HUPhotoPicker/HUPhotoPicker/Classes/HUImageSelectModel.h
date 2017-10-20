//
//  BAImageSelectModel.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;
@interface HUImageSelectModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
