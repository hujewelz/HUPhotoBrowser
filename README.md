# HUPhotoBrowser
##一个简单的ios图片浏览器 支持浏览本地图片及网络图片

HUPhotoBrowser仅仅就是为了浏览图片而生，暂不支持浏览视频及gif,使用起来非常简单。

![screenshot]()

## 使用
HUPhotoBrowser支持本地图片浏览

```Objective-C
	[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images atIndex:indexPath.row];

```
HUPhotoBrowser同时支持网络图片浏览
```Objective-C
	[HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings atIndex:indexPath.row];

```
