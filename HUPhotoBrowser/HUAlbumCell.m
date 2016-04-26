//
//  HUAlbumCell.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUAlbumCell.h"
#import "HUAlbum.h"

@interface HUAlbumCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover2;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *albumCountLab;


@end

@implementation HUAlbumCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"HUAlbumCell" bundle:nil];
}

+ (NSString *)reuserIdentifier {
    return @"HUAlbumCell";
}

- (void)setAlbum:(HUAlbum *)album {
    _album = album;
    _albumImageView.image = album.album;
    _cover2.hidden = album.imageCount < 2;
    _cover2.image = album.album;
    _albumTitleLab.text = album.title;
    _albumCountLab.text = [NSString stringWithFormat:@"%zd",album.imageCount];
}

@end
