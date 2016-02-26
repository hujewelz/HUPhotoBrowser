# HUPhotoBrowser
##一个简单的ios图片浏览器 支持浏览本地图片及网络图片

HUPhotoBrowser仅仅就是为了浏览图片而生，暂不支持浏览视频及gif,使用起来非常简单。

![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/demo.gif)

## 使用
HUPhotoBrowser支持本地图片浏览
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images atIndex:indexPath.row];

HUPhotoBrowser同时支持网络图片浏览
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings atIndex:indexPath.row];

在需要浏览的图片的点击事件中调用即可：
```Objective-C
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images placeholderImage:nil atIndex:indexPath.row dismiss:nil];
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings atIndex:indexPath.row];
}
```
你还可以获取到当前浏览到的图片
```Objective-C
[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images placeholderImage:nil atIndex:indexPath.row dismiss:^(UIImage *image, NSInteger index) {
        
    }];
```
## 安装
1. 下载ZIP包,将HUPhotoBrowser拖到工程中。
2. cocoapods安装：`pod 'HUPhotoBrowser','~> 0.0.2' `
