# HUPhotoBrowser
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hujewelz/HUPhotoBrowser/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/HUPhotoBrowser.svg)](https://img.shields.io/cocoapods/v/HUPhotoBrowser.svg)

⚠️最新的版本不再集成[HUPhotoPicker](https://github.com/hujewelz/HUPhotoPicker)了，需要使用的同学可以指定版本为 `1.2.5`，推荐单独使用[HUPhotoPicker](https://github.com/hujewelz/HUPhotoPicker)

**HUPhotoBrowser** ios图片浏览器，支持浏览本地图片及网络图片，暂不支持浏览视频及gif,使用起来非常简单,只需要一行代码。
**HUImagePickerViewController** 图片选择器，你可以像使用`UIImagePickerController`一样的使用它，支持图片多选。

![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/2016-04-3008_57_13.gif)

## PhotoBrowser的使用

在需要用到的地方 `#import <HUPhotoBrowser.h>`

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

## 安装

1. [CocoaPods](https://cocoapods.org/)安装：
```
pod 'HUPhotoBrowser' 
```
2. 下载ZIP包,将`HUPhotoBrowser`资源文件拖到工程中。
3. 将`HUPhotoBrowser.xcodeproj`工程文件和`HUPhotoBrowser`源文件一同拖入工程目录下，在工程中右键选择 "Add Files to ..."，选择`HUPhotoBrowser.xcodeproj`。

	![](http://image18-c.poco.cn/mypoco/myphoto/20170320/12/18436043320170320121521061.jpg?542x710_120)
	
	然后在 "Build Settings -> Header Search Paths" 中添加源文件路径。


## 其他

为了不影响您项目中导入的其他第三方库，本库没有导入任何其他的第三方内容，可以放心使用。在使用前，您可以查看[示例程序](https://github.com/hujewelz/HUPhotoBrowser/tree/master/Example)
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果您有什么建议可以Issues我，谢谢
* 后续我会持续更新，为它添加更多的功能，欢迎star :)


