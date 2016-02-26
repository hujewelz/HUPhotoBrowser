# HUPhotoBrowser
##一个简单的ios图片浏览器 支持浏览本地图片及网络图片

HUPhotoBrowser仅仅支持图浏览，暂不支持浏览视频及gif,使用起来非常简单。

![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/demo.gif)

## 使用
在需要用到的地方 `#import "HUPhotoBrowser.h"`

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
1. 下载ZIP包,将`HUPhotoBrowser`拖到工程中。
2. [CocoaPods](https://cocoapods.org/)安装：
```
pod 'HUPhotoBrowser','~> 0.0.2' 
```

在使用`cocoapods`安装时，请先执行 `pod search HUPhotoBrowser`，如果搜索不到，请执行`pod setup`命令。

## 其他
由于HUPhotoBrowser在加载网络图片时对图片有做本地缓存操作，如果您的项目中也使了其他的图片下载工具，所以为了避免在做缓存时生成多个缓存目录，建议在下载网络图片时可以使用`HUPhotoBrowser`中的`HUWebImageDownloader`下载图片，例如demo中的：

```Objective-C
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    [cell.imageView hu_setImageWithURL:[NSURL URLWithString:_URLStrings[indexPath.row]]];
    
    return cell;
}
```

只需在需要的地方 ` #import "UIImageView+HUWebImage.h" `即可。
