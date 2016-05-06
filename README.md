# HUPhotoBrowser
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hujewelz/HUPhotoBrowser/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/HUPhotoBrowser.svg)](https://img.shields.io/cocoapods/v/HUPhotoBrowser.svg)


**HUPhotoBrowser** ios图片浏览器，支持浏览本地图片及网络图片，暂不支持浏览视频及gif,使用起来非常简单,只需要一行代码。
**HUImagePickerViewController** 图片选择器，你可以像使用`UIImagePickerController`一样的使用它，支持图片多选。

![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/2016-04-3008_57_13.gif)
## PhotoBrowser的使用
在需要用到的地方 `#import "HUPhotoBrowser.h"`

HUPhotoBrowser支持本地图片浏览

	[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images atIndex:indexPath.row];

HUPhotoBrowser同时支持网络图片浏览

	[HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];

在需要浏览的图片的点击事件中调用即可：

```Objective-C
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_localImage) {
        [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.originalImages atIndex:indexPath.row];
    }
    else {
        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
    }

}
```

你还可以获取到当前浏览到的图片

```Objective-C
[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images placeholderImage:nil atIndex:indexPath.row dismiss:^(UIImage *image, NSInteger index) {
        
    }];
```
#HUPhotoPicker
![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/201604301836.png)

在需要用到的地方`#import "HUImagePickerViewController.h"`，并且遵循`HUImagePickerViewControllerDelegate,UINavigationControllerDelegate`代理.
现在你就可以像使用`UIImagePickerController`一样的使用它了:

```
HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
picker.delegate = self;
picker.maxAllowedCount = 10;
picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
[self presentViewController:picker animated:YES completion:nil];
```
在代理方法中你可以拿到你选择的图片

```
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    NSLog(@"images info: %@", info);
    _images = info[kHUImagePickerThumbnailImage];
    _originalImages = info[kHUImagePickerOriginalImage];
    
    [self.collectionView reloadData];
}
```

```
images info: {
    kHUImagePickerOriginalImage =     (
        "<UIImage: 0x7fbdb381f920>, {1668, 2500}",
        "<UIImage: 0x7fbdb15fbef0>, {4288, 2848}",
        "<UIImage: 0x7fbdb3914d40>, {3000, 2002}"
    );
    kHUImagePickerThumbnailImage =     (
        "<UIImage: 0x7fbdb15f36c0>, {40, 60}",
        "<UIImage: 0x7fbdb15f2b10>, {60, 40}",
        "<UIImage: 0x7fbdb15f4be0>, {60, 40}"
    );
}
```
## 安装
1. 下载ZIP包,将`HUPhotoBrowser`资源文件拖到工程中。
2. [CocoaPods](https://cocoapods.org/)安装：
```
pod 'HUPhotoBrowser','~> 1.1.3' 
```

您可以使用`pod search HUPhotoBrowser`查看所有版本，在`pod search`之前请先执行`pod setup`。请您安装最新1.1.3版本。

## 其他
为了不影响您项目中导入的其他第三方库，本库没有导入任何其他的第三方内容，可以放心使用。在使用前，您可以查看[示例程序](https://github.com/hujewelz/HUPhotoBrowser/tree/master/Example)
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果您有什么建议可以Issues我，谢谢
* 后续我会持续更新，为它添加更多的功能，欢迎star :)


