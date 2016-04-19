//
//  HUWebImageDownloadOperation.m
//  Pods
//
//  Created by mac on 16/4/19.
//
//

#import "HUWebImageDownloadOperation.h"
#import "UIImage+HUExtension.h"

@interface HUWebImageDownloadOperation ()

@property (nonatomic, copy) HUWebImageDownloadCompltedBlock completedBlock;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HUWebImageDownloadOperation

- (instancetype)initWithURL:(NSURL *)url completed:(HUWebImageDownloadCompltedBlock)completedBlock {
    if (self = [super init]) {
        _url = url;
        _completedBlock = completedBlock;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        if (self.isCancelled) {
            [self reset];
            return;
        }
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLRequest *repuest = [NSURLRequest requestWithURL:_url];
        __weak __typeof(self) wself = self;
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:repuest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            __strong __typeof(self) sself = wself;
            if (!sself.completedBlock) {
                return ;
            }
            
            if (data == nil) {
                sself.completedBlock(nil, nil, error);
                return ;
            }
            
            if (sself.isCancelled) {
                [sself reset];
                return;
            }
            
            UIImage *image = [UIImage hu_imageFromData:data];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                sself.completedBlock(image, data, nil);
            }];
            
        }];
        [task resume];

    }
    
}

- (void)reset {
    self.completedBlock = nil;
    [[self.session dataTaskWithURL:_url] cancel];
}

@end
