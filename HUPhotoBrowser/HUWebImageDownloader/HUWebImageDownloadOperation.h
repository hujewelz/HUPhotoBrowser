//
//  HUWebImageDownloadOperation.h
//  Pods
//
//  Created by mac on 16/4/19.
//
//

#import <UIKit/UIKit.h>

typedef void (^HUWebImageDownloadCompltedBlock) (UIImage * __nullable image, NSData * __nullable data, NSError * __nullable error);

@interface HUWebImageDownloadOperation : NSOperation

- (nonnull instancetype)initWithURL:(nonnull NSURL *)url completed:(nullable HUWebImageDownloadCompltedBlock)completedBlock;

@end
