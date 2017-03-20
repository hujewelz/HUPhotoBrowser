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
#import "HUImageItem.h"

NSString * const kHUImagePickerOriginalImage = @"kHUImagePickerOriginalImage";
NSString * const kHUImagePickerThumbnailImage = @"kHUImagePickerThumbnailImage";

static const CGFloat kSpacing = 2.0;

@interface HUImagePickerRootViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *selectedStataArray;
@property (nonatomic, strong) NSMutableArray *selectedImages;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraRollHandler:) name:kDidFetchCameraRollSucceedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidFetchCameraRollSucceedNotification object:nil];

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
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:images.count];
        for (NSInteger i=0; i<images.count; i++) {
            HUImageItem *item = [HUImageItem imageItemWithImage:images[i]];
            [tmp addObject:item];
        }
        sself.images = [tmp copy];
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
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HUImagePickerCell reuserIdentifier] forIndexPath:indexPath];
    HUImageItem *item = self.images[indexPath.row];
    cell.imageView.image = item.image;
    cell.didSelected = item.selected;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HUImagePickerCell *cell = (HUImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.didSelected && self.selectedImages.count > self.maxCount-1) {
        [HUToast showToastWithMsg:@"已达最大数量了"];
        return;
    }

    HUImageItem *item = self.images[indexPath.row];
    item.selected = !item.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    
    UIImage *image = item.image;
    if (!cell.didSelected) {
        if (![self.selectedImages containsObject:image]) {
            [self.selectedImages addObject:image];
        }
    }
    else {
        [self.selectedImages removeObject:image];
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width-6)/4;
    return CGSizeMake(width, width);
}

#pragma mark - private

- (void)didFinishedPick {
    
    if (self.selectedImages.count < 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSMutableArray *thumbnail = [NSMutableArray array];
    __weak __typeof(self) wself = self;
    [self.images enumerateObjectsUsingBlock:^(HUImageItem  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.selected) {
             [thumbnail addObject:obj.image];
             if ([wself originalAllowed]) {
                 [[HUPhotoHelper sharedInstance] fetchSelectedOriginalPhotoAt:idx];
             }
         }
     }];
    
    self.imagesInfo[kHUImagePickerThumbnailImage] = thumbnail;
    NSArray *originals = [[HUPhotoHelper sharedInstance].originalImages copy];
    self.imagesInfo[kHUImagePickerOriginalImage] = originals;
    [[HUPhotoHelper sharedInstance].originalImages removeAllObjects];

     HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
     if ([navigationVc.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImagesWithInfo:)]) {
        [navigationVc.delegate imagePickerController:navigationVc didFinishPickingImagesWithInfo:_imagesInfo];
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

#pragma mark - getter

- (NSArray *)images {
    if (!_images) {
        _images = [NSArray array];
    }
    return _images;
}

- (NSMutableArray *)selectedStataArray {
    if (!_selectedStataArray) {
        _selectedStataArray = [NSMutableArray array];
    }
    return _selectedStataArray;
}

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

- (NSMutableDictionary *)imagesInfo {
    if (!_imagesInfo) {
        _imagesInfo = [NSMutableDictionary dictionary];
    }
    return _imagesInfo;
}

@end
