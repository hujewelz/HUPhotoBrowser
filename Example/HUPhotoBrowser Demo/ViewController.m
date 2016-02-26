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
#import "UIImageView+HUWebImage.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *URLStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _URLStrings = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    [self getWebImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)images {
    if (!_images) {
        NSArray *array =  @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.png",@"5.jpg"];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:array.count];
        for (NSString *named in array) {
            UIImage *img = [UIImage imageNamed:named];
            [images addObject:img];
        }
        _images = [NSArray arrayWithArray:images];
    }
    return _images;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _URLStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
//    cell.imageView.image = self.images[indexPath.row];

    [cell.imageView hu_setImageWithURL:[NSURL URLWithString:_URLStrings[indexPath.row]]];
//    [[HUWebImageDownloader sharedImageDownloader] downloadImageWithURL:[NSURL URLWithString:_URLStrings[indexPath.row]] completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
//        cell.imageView.image = image;
//    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
//    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images placeholderImage:nil atIndex:indexPath.row dismiss:nil];
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings atIndex:indexPath.row];
}

- (void)getWebImages {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://api.tietuku.com/v2/api/getrandrec?key=bJiYx5aWk5vInZRjl2nHxmiZx5VnlpZkapRuY5RnaGyZmsqcw5NmlsObmGiXYpU="];
    
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
