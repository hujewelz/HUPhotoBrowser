//
//  HUAlbumsViewController.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUAlbumsViewController.h"
#import "HUPhotoHelper.h"
#import "HUAlbum.h"
#import "HUAlbumCell.h"
#import "HUImagePickerRootViewController.h"

@interface HUAlbumsViewController ()

@property (nonatomic, strong) NSArray *albums;

@end

@implementation HUAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[HUAlbumCell nib] forCellReuseIdentifier:[HUAlbumCell reuserIdentifier]];
    
    __weak __typeof(self) wself = self;
    [HUPhotoHelper fetchAlbums:^(NSArray *albums) {
        wself.albums = albums;
        [wself.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _albums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    HUAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:[HUAlbumCell reuserIdentifier] forIndexPath:indexPath];
    
    HUAlbum *album = self.albums[indexPath.row];
    cell.album = album;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUImagePickerRootViewController *vc = [[HUImagePickerRootViewController alloc] initWithAssetCollection:[HUPhotoHelper sharedInstance].allCollections[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


#pragma mark - private
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
