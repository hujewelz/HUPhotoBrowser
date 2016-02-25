//
//  HUPhotoBrowserCell.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowserCell.h"
#import "const.h"
#import "HUWebImageDownloader.h"


@interface HUPhotoBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;


@end

@implementation HUPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale = 0.5;
    scrollView.delegate = self;

    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    [scrollView addSubview:imageView];
    _imageView = imageView;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _imageView.frame = _scrollView.bounds;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}



- (void)configureCellWithURLStrings:(NSString *)URLStrings {
    self.imageView.image = self.placeholderImage;
    NSURL *url = [NSURL URLWithString:URLStrings];
    [[HUWebImageDownloader sharedImageDownloader] downloadImageWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
        self.imageView.image = image;
    }];
//    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
//    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
//    if (image) {
//        self.imageView.image = image;
//    }
//    else {
//        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            NSLog(@"thread: %@", [NSThread currentThread]);
//            if (image) {
//                self.imageView.image = image;
//            }
//            
//        }];
//    }
}

@end
