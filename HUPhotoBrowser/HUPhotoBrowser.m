//
//  HUPhotoBrowser.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowser.h"
#import "HUPhotoBrowserCell.h"
#import "hu_const.h"
#import "HUWebImage.h"

@interface HUPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    CGRect _endTempFrame;
    NSInteger _currentPage;
    NSIndexPath *_zoomingIndexPath;
    BOOL _imageDidLoaded;
    BOOL _animationCompleted;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *tmpImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, weak) UILabel *countLab;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger imagesCount;
@property (nonatomic, copy) DismissBlock dismissDlock;
@property (nonatomic, strong) NSArray *images;

@end

@implementation HUPhotoBrowser

- (void)dealloc {
    self.collectionView.delegate = nil; 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:image atIndex:index didSave:nil dismiss:block];
}


+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    return [self showFromImageView:imageView withImages:images atIndex:index didSave:nil dismiss:block];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index {

    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:nil atIndex:index dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index {
    return [self showFromImageView:imageView withImages:images atIndex:index dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock {
    return [self showFromImageView:imageView withImages:images atIndex:index didSave:saveBlock dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock {
    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:image atIndex:index didSave:saveBlock dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.images = images;
    browser.imagesCount = images.count;
    [browser resetCountLabWithIndex:index+1];
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];
    browser.dismissDlock = block;
    browser.didSaveBlock = saveBlock;
    
    return browser;
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.URLStrings = URLStrings;
    browser.imagesCount = URLStrings.count;
    [browser resetCountLabWithIndex:index+1];
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    browser.didSaveBlock = saveBlock;
    
    return browser;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.collectionView];
        
        [self setupToolBar];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadForScreenRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoCellDidZooming:) name:kPhotoCellDidZommingNotification object:nil];
        
    }
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.URLStrings) {
        count = _URLStrings.count;
    }else if (self.images) {
        count = _images.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell resetZoomingScale];
    __weak __typeof(self) wself = self;
    cell.tapActionBlock = ^(UITapGestureRecognizer *sender) {
        [wself dismiss];
    };
    cell.longActionBlock = ^(UILongPressGestureRecognizer *longGesture) {
        if (self.longTapBlock){
            HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self->_currentPage inSection:0]];
            UIImage *currImage = cell.imageView.image;
            if (currImage) {
                self.longTapBlock(currImage, self->_currentPage, longGesture);
            }
        }
    };
    if (self.URLStrings) {
        [cell startAnimating];
        __weak __typeof(cell) weakCell = cell;
        NSURL *url = [NSURL URLWithString:self.URLStrings[indexPath.row]];
        if (indexPath.row != _index) {
            if (_placeholderImage) {
                [cell stopAnimating];
                [cell.imageView hu_setImageWithURL:url placeholderImage:_placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageUrl) {
                    __strong __typeof(weakCell) strongCell = weakCell;
                    [strongCell resizeImageView];
                }];
            } else {
                [cell.imageView hu_setImageWithURL:url placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageUrl) {
                    if (image) {
                        __strong __typeof(weakCell) strongCell = weakCell;
                        [strongCell resizeImageView];
                        [strongCell stopAnimating];
                    }
                }];
            }
        } else {
            UIImage *placeHolder = _tmpImageView.image;
            [cell.imageView hu_setImageWithURL:url placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
                __strong __typeof(wself) strongSelf = wself;
                __strong __typeof(weakCell) strongCell = weakCell;
                [strongCell stopAnimating];
                [strongCell resizeImageView];
                if (!strongSelf->_imageDidLoaded) {
                     strongSelf->_imageDidLoaded = YES;
                    if (strongSelf->_animationCompleted) {
                        strongSelf.collectionView.hidden = NO;
                        [strongSelf->_tmpImageView removeFromSuperview];
                        strongSelf->_animationCompleted = NO;
                    }
                   
                }
            }];
        }
    }
    else if (self.images) {
        [cell stopAnimating];
        cell.imageView.image = self.images[indexPath.row];
        [cell resizeImageView];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenRect.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x/kScreenWidth + 0.5;
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,_imagesCount];
    
    if (_zoomingIndexPath) {
       [self.collectionView reloadItemsAtIndexPaths:@[_zoomingIndexPath]];
        _zoomingIndexPath = nil;
    }
    
}

#pragma mark - notification handler

- (void)reloadForScreenRotate {
     _collectionView.frame = kScreenRect;
   
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(kScreenWidth * _currentPage,0);
}

- (void)photoCellDidZooming:(NSNotification *)nofit {
    NSIndexPath *indexPath = nofit.object;
    _zoomingIndexPath = indexPath;
}

#pragma mark - getter & setter

- (void)setDidHideToolBar:(BOOL)didHideToolBar {
    _didHideToolBar = didHideToolBar;
    _toolBar.hidden = didHideToolBar;
}

- (void)setDidHideSaveButton:(BOOL)didHideSaveButton {
    didHideSaveButton = didHideSaveButton;
    _saveButton.hidden = didHideSaveButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.hidden = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

#pragma mark - private 

- (void)configureBrowser {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HUPhotoBrowserCell class] forCellWithReuseIdentifier:kPhotoBrowserCellID];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)setupToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-38, self.frame.size.width, 30)];
    _toolBar.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolBar];
    
    UILabel *countLab = [[UILabel alloc] init];
    countLab.textColor = [UIColor whiteColor];
    countLab.layer.cornerRadius = 2;
    countLab.layer.masksToBounds = YES;
    countLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    countLab.font = [UIFont systemFontOfSize:13];
    countLab.textAlignment = NSTextAlignmentCenter;
    [_toolBar addSubview:countLab];
    _countLab = countLab;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_toolBar.frame.size.width-58, 1, 50, 28);
    saveBtn.layer.cornerRadius = 2;
    [saveBtn setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.4]];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveBtn addTarget:self action:@selector(saveImae) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:saveBtn];
    _saveButton = saveBtn;
    
}

- (void)animateImageViewAtIndex:(NSInteger)index {
    _index = index;
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = kScreenRect;
    
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat ratio = image.size.width / image.size.height;
        
        if (ratio > kScreenRatio) {
            
            endFrame.size.width = kScreenWidth;
            endFrame.size.height = kScreenWidth / ratio;
            
        } else {
            endFrame.size.height = kScreenHeight;
            endFrame.size.width = kScreenHeight * ratio;
            
        }
        endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
        endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
        
    }
    
    _endTempFrame = endFrame;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
#endif
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    _tmpImageView = tempImageView;
    
    if (self.URLStrings && !self.images) {
        NSString *key = [HUWebImageDownloader cacheKeyForURL:[NSURL URLWithString:self.URLStrings[_index]]];
        UIImage *image = [HUWebImageDownloader imageFromDiskCacheForKey:key];
        _imageDidLoaded = image != nil;
    }
    [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        self->_currentPage = index;
        self->_animationCompleted = YES;
        if (self.images || self->_imageDidLoaded || (self.URLStrings && !self->_imageDidLoaded)) {
            self.collectionView.hidden = NO;
            [tempImageView removeFromSuperview];
            self->_animationCompleted = NO;
        }
        
    }];
    
    
}

- (void)dismiss {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
#endif
    
    if (self.dismissDlock) {
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        self.dismissDlock(cell.imageView.image, _currentPage);
    }
    
    if (_currentPage != _index) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        return;
    }
    
    CGRect endFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_endTempFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
        
    }];
    
}

- (void)resetCountLabWithIndex:(NSInteger)index {
    
    NSString *text = [NSString stringWithFormat:@"%zd%zd",_imagesCount,_imagesCount];
    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width+8;
    _countLab.frame = CGRectMake(8, 1, MAX(50, width), 28);
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd",index,_imagesCount];
}

- (void)saveImae {
    HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
    UIImage *seavedImage = cell.imageView.image;
    if (seavedImage) {
         UIImageWriteToSavedPhotosAlbum(seavedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
   
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (self.didSaveBlock) {
        self.didSaveBlock(image, error, contextInfo);
     }
}

@end
