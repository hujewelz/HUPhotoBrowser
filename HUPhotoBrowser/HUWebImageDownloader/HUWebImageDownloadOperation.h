//
//  HUWebImageDownloadOperation.h
//  Pods
//
//  Created by mac on 16/4/19.
//
//

#import <UIKit/UIKit.h>

typedef void (^HUWebImageDownloadCompltedBlock) (UIImage *image, NSData *data, NSError *error);

@interface HUWebImageDownloadOperation : NSOperation

- (instancetype)initWithURL:(NSURL *)url completed:(HUWebImageDownloadCompltedBlock)completedBlock;

@end
