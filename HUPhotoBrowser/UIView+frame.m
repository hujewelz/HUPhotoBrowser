//
//  UIView+Extension.m
//  微博
//
//  Created by jewelz on 15/4/23.
//  Copyright (c) 2015年 yangtzeu. All rights reserved.
//

#import "UIView+frame.h"
#import <objc/runtime.h>

@implementation UIView (frame)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigion:(CGPoint)origion {
    CGRect frame = self.frame;
    frame.origin = origion;
    self.frame = frame;
}

- (CGPoint)origion {
    return self.frame.origin;
}

//- (void)addLineAtButtonFrom:(CGPoint)fromPoint to:(CGPoint)toPoint {
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    path.lineWidth = 0.5;
//    UIColor *lineColor = kSEPARATOR_COLOR;
//    [lineColor setStroke];
//    
//    [path moveToPoint:fromPoint];
//    [path addLineToPoint:toPoint];
//    
//    [path stroke];
//    
//
//}
- (void)addLineFrom:(CGPoint)fromPoint to:(CGPoint)toPoint {
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx, 1.0);  //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);  //颜色
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, fromPoint.x, fromPoint.y);  //起点坐标
    CGContextAddLineToPoint(ctx,toPoint.x, toPoint.y);   //终点坐标
    CGContextStrokePath(ctx);
}



@end
