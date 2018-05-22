//
//  const.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#ifndef HUPhotoBrowser_const_h
#define HUPhotoBrowser_const_h

#define kScreenRect [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenRatio kScreenWidth / kScreenHeight
#define kScreenMidX CGRectGetMaxX(kScreenRect)
#define kScreenMidY CGRectGetMaxY(kScreenRect)

#define dispatch_async_main(block) if ([NSThread isMainThread]) { \
    block;\
} else { \
    dispatch_async(dispatch_get_main_queue(), ^{ \
        block; \
    }); \
} \

#endif
