//
//  BAAlbumTableViewController.m
//  beautyAssistant
//
//  Created by jewelz on 2017/6/22.
//  Copyright © 2017年 Service+. All rights reserved.
//

#import "HUAlbumTableViewController.h"
#import "HUImageGridViewController.h"
#import <Photos/Photos.h>
#import "HUAlbumCell.h"
#import "HUPhotoAlbum.h"

@interface HUAlbumTableViewController () <PHPhotoLibraryChangeObserver> {
    PHFetchResult<PHAssetCollection *> *_smartAlbums;
    PHFetchResult<PHCollection *> *_userCollectons;
}

@property (nonatomic, strong) PHFetchResult<PHAsset *> *allPhotos;
//@property (nonatomic, strong) NSArray<PHAssetCollection *> *smartAlbums;
//@property (nonatomic, strong) NSArray<PHCollection *> *userCollectons;

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;


@property (nonatomic, strong) NSArray<HUPhotoAlbum *>  *allAlbums;

@end

@implementation HUAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined) {
        // 无权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self setupData];
                return ;
            }
            [self rightBarItemClicked];
        }];
        return;
    }
    
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        [self rightBarItemClicked];
        return;
    }
    
    [self setupData];
    
}

- (void)dealloc {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItemClicked {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allAlbums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = nil;
    HUAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:[HUAlbumCell reuseIdentifier] forIndexPath:indexPath];
    HUPhotoAlbum *album = self.allAlbums[indexPath.row];
    cell.titleLabel.text = album.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%zd", album.assetCount];
    
    PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:album.collection options:nil];
    asset = [results firstObject];
    
    [_cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeDefault options:_options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        NSLog(@"result: %@", result);
        cell.album.image = result;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUPhotoAlbum *album = self.allAlbums[indexPath.row];
    
    //HUImageGridViewController *vc = [[HUImageGridViewController alloc] init];
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:album.collection options:options];
//    vc.title = album.title;
//    vc.fetchResult = results;
//    [self.navigationController pushViewController:vc animated:true];
    
    if (_didSelectedAlbum) {
         _didSelectedAlbum(album.title, results);
    }
   
}


- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        PHFetchResultChangeDetails *all = [changeInstance changeDetailsForFetchResult:_allPhotos];
        PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:_smartAlbums];
        PHFetchResultChangeDetails *users = [changeInstance changeDetailsForFetchResult:_userCollectons];
        
        if (all) {
            _allPhotos = [all fetchResultAfterChanges];
        }
        
        if (details) {
            _smartAlbums = [details fetchResultAfterChanges];
        }
        
        if (users) {
            _userCollectons = [users fetchResultAfterChanges];
        }
        
        self.allAlbums = [self getPhotoAlbumsFromSmallAlbumsAndUserCollections];
        [self.tableView reloadData];
        
    });
}

# pragma mark - Private

- (void)setupData {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[HUAlbumCell nib] forCellReuseIdentifier:[HUAlbumCell reuseIdentifier]];
    _cachingImageManager = [[PHCachingImageManager alloc] init];
    
    PHFetchOptions *options = [PHFetchOptions new];
    options.includeAssetSourceTypes = PHAssetResourceTypePhoto;
    
    _smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:options];
    _userCollectons = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:options];
    
    self.allAlbums = [self getPhotoAlbumsFromSmallAlbumsAndUserCollections];
    
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _allPhotos = [PHAsset fetchAssetsWithOptions:options];
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (NSArray<HUPhotoAlbum *> *)getPhotoAlbumsFromSmallAlbumsAndUserCollections {
    NSMutableArray<HUPhotoAlbum *> *allAlums = [NSMutableArray array];
    NSArray<HUPhotoAlbum *> *smarts = [self getPhotoAlbumsWithPHAssetCollection:_smartAlbums];
    [allAlums addObjectsFromArray:smarts];
    NSArray<HUPhotoAlbum *> *users = [self getPhotoAlbumsWithPHAssetCollection:_userCollectons];
    [allAlums addObjectsFromArray:users];
    
    return [allAlums copy];
}

- (NSArray<HUPhotoAlbum *> *)getPhotoAlbumsWithPHAssetCollection:(id)assetCollections {
    NSMutableArray<HUPhotoAlbum *> *collections = [NSMutableArray array];
    
    HUPhotoAlbum *album = nil;
    for (PHCollection *collection in assetCollections) {
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:nil];
            if (results.count > 0) {
                album = [HUPhotoAlbum photoAlbumWithAssetCollection:(PHAssetCollection*)collection assetCount:results.count];
                [collections addObject: album];
            }
        }
    }
    
    return collections;
}

#pragma mark - getter & setter

- (NSArray *)allAlbums {
    if (_allAlbums == nil) {
        _allAlbums = [NSArray array];
    }
    return _allAlbums;
}


- (PHImageRequestOptions *)options {
    if (_options == nil) {
        _options = [PHImageRequestOptions new];
        _options.resizeMode = PHImageRequestOptionsResizeModeFast;
        [_options setSynchronous:false];
        [_options setNetworkAccessAllowed:false];
    }
    return _options;
}

@end
