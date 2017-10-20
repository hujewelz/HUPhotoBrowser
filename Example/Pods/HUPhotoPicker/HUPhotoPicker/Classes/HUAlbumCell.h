//
//  BAAlbumCell.h
//  beautyAssistant
//
//  Created by jewelz on 2017/6/26.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAlbumCell : UITableViewCell

+ (UINib *)nib;
+ (NSString *)reuseIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *album;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
