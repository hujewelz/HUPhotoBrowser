//
//  BAImageGridCell.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUImageSelectModel.h"

@interface HUImageGridCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UIButton *degradedButton;

@property (nonatomic, assign) BOOL isDegraded;
@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) HUImageSelectModel *model;

@end
