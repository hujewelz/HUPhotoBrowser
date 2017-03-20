//
//  HUPhotoBrowserCell.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowserCell.h"
#import "hu_const.h"
#import "UIImageView+HUWebImage.h"

@interface HUPhotoBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;

@end

@implementation HUPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupView];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
}

- (void)setupView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.maximumZoomScale = 4;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.delegate = self;

    [self addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:imageView];
    _imageView = imageView;
    
}

- (void)resetZoomingScale {
    
    if (self.scrollView.zoomScale !=1) {
         self.scrollView.zoomScale = 1;
    }
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _imageView.frame = _scrollView.bounds;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoCellDidZommingNotification object:_indexPath];
}

#pragma mark - gesture handler

- (void)doubleTapGestrueHandle:(UITapGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self];
    if (self.scrollView.zoomScale <=1.0) {
        //CGFloat scaleX = p.x + self.scrollView.contentOffset.x;
        //CGFloat scaley = p.y + self.scrollView.contentOffset.y;
        CGRect rect = [self zoomRectForScale:_scrollView.zoomScale*3 withCenter:p];
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)singleTapGestrueHandle:(UITapGestureRecognizer *)sender {
    if (self.tapActionBlock) {
        self.tapActionBlock(sender);
    }
    
}

#pragma mark - private

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = _scrollView.frame.size.height/scale;
    zoomRect.size.width  = _scrollView.frame.size.width/scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width/2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height/2.0);
    
    return zoomRect;
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - getter

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestrueHandle:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestrueHandle:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

@end
