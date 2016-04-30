//
//  HUImagePickerViewController.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUImagePickerRootViewController.h"
#import "HUImagePickerCell.h"
#import "HUPhotoHelper.h"
#import "HUImagePickerViewController.h"
#import "HUToast.h"

NSString * const kHUImagePickerOriginalImage = @"kHUImagePickerOriginalImage";
NSString * const kHUImagePickerThumbnailImage = @"kHUImagePickerThumbnailImage";

static const CGFloat kSpacing = 2.0;

@interface HUImagePickerRootViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    NSMutableDictionary *_selectedIndexPaths;
    NSMutableArray *_selectedImages;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableDictionary *imagesInfo;

@end

@implementation HUImagePickerRootViewController

- (instancetype)initWithAssetCollection:(id)assetCollection {
    self = [self init];
    _assetCollection = assetCollection;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndexPaths = [NSMutableDictionary dictionary];
        _imagesInfo = [NSMutableDictionary dictionary];
        _selectedImages = [NSMutableArray array];
        _images = [NSArray array];
        if (!IS_IOS8_LATER) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraRollHandler:) name:kDidFetchCameraRollSucceedNotification object:nil];
        }
    }
    return self;
}

- (void)dealloc {
    if (!IS_IOS8_LATER) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidFetchCameraRollSucceedNotification object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didFinishedPick)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:HUImagePickerCell.nib forCellWithReuseIdentifier:HUImagePickerCell.reuserIdentifier];
    
    [self startFetchPhotosWithCollection:_assetCollection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startFetchPhotosWithCollection:(id)collection {
    __weak __typeof(self) wself = self;
    [HUPhotoHelper fetchAssetsInAssetCollection:collection resultHandler:^(NSArray *images, NSString *albumTitle) {
        __strong __typeof(self) sself = wself;
        sself.title = albumTitle;
        sself.images = images;
        [sself.collectionView reloadData];
    }];
}

- (void)cameraRollHandler:(NSNotification *)notif {
    [self startFetchPhotosWithCollection:notif.object];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kSpacing;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

#pragma mark - Collection view data source 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HUImagePickerCell reuserIdentifier] forIndexPath:indexPath];
    cell.imageView.image = _images[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HUImagePickerCell *cell = (HUImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_selectedIndexPaths[@(indexPath.row)]) {
        [_selectedIndexPaths removeObjectForKey:@(indexPath.row)];
        cell.didSelected = NO;
    }
    else {
        NSArray *allValues = _selectedIndexPaths.allValues;
        if (allValues.count >= self.maxCount) {
            
            [HUToast showToastWithMsg:@"已达最大数量了"];
            return;
        }

        [_selectedIndexPaths setObject:indexPath forKey:@(indexPath.row)];
        cell.didSelected = YES;
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width-6)/4;
    return CGSizeMake(width, width);
}

#pragma mark - private

- (void)didFinishedPick {
    NSArray *allValues = _selectedIndexPaths.allValues;
    NSMutableArray *thumbnails = [NSMutableArray arrayWithCapacity:allValues.count];
    if (allValues.count > 0) {
        
        for (NSIndexPath *indexPath in allValues) {
            [thumbnails addObject:_images[indexPath.row]];
            [[HUPhotoHelper sharedInstance] fetchSelectedPhoto:indexPath.row];
        }
        _imagesInfo[kHUImagePickerThumbnailImage] = thumbnails;
        
        if ([self originalAllowed]) {
            NSArray *originals = [[HUPhotoHelper sharedInstance].originalImages copy];
            _imagesInfo[kHUImagePickerOriginalImage] = originals;
            [[HUPhotoHelper sharedInstance].originalImages removeAllObjects];
        }
        
        HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
        if ([navigationVc.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImagesWithInfo:)]) {
            [navigationVc.delegate imagePickerController:navigationVc didFinishPickingImagesWithInfo:_imagesInfo];
        }
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)maxCount {
    HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
    return navigationVc.maxAllowedCount;
}

- (BOOL)originalAllowed {
    HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
    return navigationVc.originalImageAllowed;
}

- (BOOL)didSelectedAtIndexPath:(NSIndexPath *)indexPath withSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (!selectedIndexPath) return NO;
    
    return indexPath.row == selectedIndexPath.row;
}

@end
