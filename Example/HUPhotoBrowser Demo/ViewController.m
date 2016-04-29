//
//  ViewController.m
//  HUPhotoBrowser Demo
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
#import "HUPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import "HUImagePickerViewController.h"


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _localImage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *originalImages;
@property (nonatomic, strong) NSMutableArray *URLStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HUPhotoBrowser Demo";
    _URLStrings = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    [self getWebImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _localImage ? _images.count : _URLStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    if (_localImage) {
        cell.imageView.image = self.images[indexPath.row];
    }
    else {

        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_URLStrings[indexPath.row]]];
    }
    
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_localImage) {
        [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.originalImages placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
    }
    else {
        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
    }
}

#pragma mark - HUImagePickerViewControllerDelegate

- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images imageInfo:(NSDictionary *)info{
    NSLog(@"dismiss: %@", info);
    _images = images;
    _originalImages = info[kHUImagePickerOriginalImage];
    _localImage = YES;
    [self.collectionView reloadData];
}

#pragma mark - IBAction

- (IBAction)pickImage:(id)sender {
    HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
    picker.delegate = self;
    picker.maxAllowedCount = 10;
    [self presentViewController:picker animated:YES completion:nil];
}



#pragma mark - private 

- (void)getWebImages {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://api.tietuku.cn/v2/api/getrandrec?key=bJiYx5aWk5vInZRjl2nHxmiZx5VnlpZkapRuY5RnaGyZmsqcw5NmlsObmGiXYpU="];
    
    NSURLRequest *repuest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:repuest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *dict in result) {
            NSString *linkurl = dict[@"linkurl"];
            
            [_URLStrings addObject:linkurl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
         
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

@end
