
//
//  HUPhotoBrowser.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ __nullable DismissBlock)(UIImage * __nullable image, NSInteger index);

typedef void(^ __nullable DidSaveBlock)(UIImage * image, NSError * error, void * contextInfo);

typedef void(^ __nullable LongTapBlock)(UIImage * image, NSInteger index,UILongPressGestureRecognizer *longGesture);

@interface HUPhotoBrowser : UIView

@property (nonatomic, strong, readonly) UIButton *saveButton;

/*
 * 是否隐藏工具栏，默认不隐藏
 */
@property (nonatomic) BOOL didHideToolBar;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index dismiss:(DismissBlock)block;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param didSave      photo保存到m相册的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param didSave      photo保存到m相册的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photo保存到m相册的回调
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock dismiss:(DismissBlock)block;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param didSave      photo保存到m相册的回调
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index didSave:(DidSaveBlock)saveBlock dismiss:(DismissBlock)block;



@property (nonatomic, strong, nullable) UIImage *placeholderImage;

/*
 * 保存到相册回调
 */
@property (nonatomic, copy) DidSaveBlock didSaveBlock;

/*
 * 长按图片回调
 */
@property (nonatomic, copy) LongTapBlock longTapBlock;


/*
 * 是否隐藏保存按钮，默认不隐藏
 */
@property (nonatomic) BOOL didHideSaveButton;

@end
