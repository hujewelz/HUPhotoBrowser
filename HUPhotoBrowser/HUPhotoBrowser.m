//
//  HUPhotoBrowser.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowser.h"
#import "HUPhotoBrowserCell.h"
#import "const.h"

@interface HUPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    CGRect _endTempFrame;
    NSInteger _currentPage;
}

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) DismissBlock dismissDlock;
@property (nonatomic, strong) NSArray *images;

@end

@implementation HUPhotoBrowser

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.URLStrings = URLStrings;
    [browser configureBrowser];
    if (imageView) {
        [browser animateImageViewAtIndex:index];
    }
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    return browser;
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index {
    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:image atIndex:index dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    
    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:nil atIndex:index dismiss:block];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index {

    return [self showFromImageView:imageView withURLStrings:URLStrings atIndex:index];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.images = images;
    [browser configureBrowser];
    if (imageView) {
        [browser animateImageViewAtIndex:index];
    }
    
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    return browser;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        collectionView.hidden = YES;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
        [self addSubview:collectionView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadForScreenRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)configureBrowser {
   
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HUPhotoBrowserCell class] forCellWithReuseIdentifier:kPhotoBrowserCellID];
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)animateImageViewAtIndex:(NSInteger)index {
    _index = index;
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = kScreenRect;

//    self.imageView.hidden = YES;
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat ratio = image.size.width / image.size.height;
        
//        if (ratio < startFrame.size.width / startFrame.size.height ) {
//            CGFloat midX = CGRectGetMaxX(startFrame);
//            startFrame.size.width = startFrame.size.height * ratio;
//            startFrame.origin.x = midX - startFrame.size.width / 2;
//        } else {
//            CGFloat midY = CGRectGetMidY(startFrame);
//            startFrame.size.height = startFrame.size.width / ratio;
//            startFrame.origin.y = midY - startFrame.size.height / 2;
//        }
        
        
        if (ratio > kScreenRatio) {
           // CGFloat width = MIN(image.size.width, kScreenWidth);
            
//            endFrame.size.width = width;
//            endFrame.size.height = width / ratio;
            endFrame.size.height = kScreenWidth / ratio;
            
           
        } else {
//            CGFloat height =  MIN(image.size.height, kScreenHeight);
//            
//            endFrame.size.width = height * ratio;
//            endFrame.size.height = height;
            endFrame.size.height = kScreenHeight * ratio;
        }
        endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
        endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
        
    }

    _endTempFrame = endFrame;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
//    NSLog(@"start: %@, end: %@", NSStringFromCGRect(startFrame),NSStringFromCGRect(endFrame));
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
    } completion:^(BOOL finished) {
        _currentPage = index;
        [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
        self.collectionView.hidden = NO;
        [tempImageView removeFromSuperview];
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tempImageView removeFromSuperview];
//    });
}

- (void)dismiss {
    
    if (self.dismissDlock) {
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        self.dismissDlock(cell.imageView.image, _currentPage);
    }
    
    if (_currentPage != _index) {
        
        [self removeFromSuperview];
        return;
    }
    
    
    CGRect endFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_endTempFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
//    NSLog(@"start: %@, end: %@", NSStringFromCGRect(startFrame),NSStringFromCGRect(endFrame));
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
        
        
    }];
   
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.URLStrings) {
        count = _URLStrings.count;
    }
    else if (self.images) {
        count = _images.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserCellID forIndexPath:indexPath];
    
    cell.placeholderImage = self.placeholderImage;
    if (self.URLStrings) {
        [cell configureCellWithURLStrings:self.URLStrings[indexPath.row]];
    }
    else if (self.images) {
        cell.imageView.image = self.images[indexPath.row];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenRect.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x/kScreenWidth + 0.5;
    
}

- (void)reloadForScreenRotate {
     _collectionView.frame = kScreenRect;
   // NSLog(@"screen: %@", NSStringFromCGRect(_collectionView.frame));
   
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(kScreenWidth * _currentPage,0);
}


@end
