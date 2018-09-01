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

@property (nonatomic, strong, readwrite) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
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
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.indicatorView];
}

- (void)resetZoomingScale {
    
    if (self.scrollView.zoomScale !=1) {
         self.scrollView.zoomScale = 1;
    }
}

- (void)resizeImageView {
    CGSize size = self.imageView.image.size;
    CGFloat scale = size.height / size.width;
    BOOL flag = scale > kScreenHeight / kScreenWidth;
    if (size.height > kScreenHeight * 2 && flag) {
        CGFloat height = kScreenWidth * size.height / size.width;
        self.imageView.frame = CGRectMake(0, 0, kScreenWidth, height);
    } else {
        self.imageView.frame = self.scrollView.bounds;
    }
}

- (void)startAnimating {
    [self.indicatorView startAnimating];
}

- (void)stopAnimating {
    [self.indicatorView stopAnimating];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.scrollView.bounds;
    self.indicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
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
        CGRect rect = [self zoomRectForScale:self.scrollView.zoomScale*3 withCenter:p];
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
    zoomRect.size.height = self.scrollView.frame.size.height/scale;
    zoomRect.size.width = self.scrollView.frame.size.width/scale;
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

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.maximumZoomScale = 4;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

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
