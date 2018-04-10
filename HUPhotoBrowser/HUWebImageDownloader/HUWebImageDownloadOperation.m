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
@property (nonatomic, assign) BOOL myFinished;
@property (nonatomic, assign) BOOL myExecuting;

@end

@implementation HUWebImageDownloadOperation

- (instancetype)initWithURL:(NSURL *)url completed:(HUWebImageDownloadCompltedBlock)completedBlock {
    if (self = [super init]) {
        _url = url;
        _completedBlock = completedBlock;
    }
    return self;
}

//- (void)main {
//
//    @autoreleasepool {
//        if (self.isCancelled) {
//            [self reset];
//            return;
//        }
//
//
//        [self beginTask];
//    }
//
//}

- (void)start {
    if (self.isCancelled) {
        [self end];
        [self reset];
        return;
    }
    _myExecuting = YES;
    [self beginTask];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _myFinished;
}

- (BOOL)isExecuting {
    return _myExecuting;
}

- (void)setMyExecuting:(BOOL)myExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _myExecuting = myExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setMyFinished:(BOOL)myFinished {
    [self willChangeValueForKey:@"isFinished"];
    _myFinished = myFinished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)beginTask {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLRequest *repuest = [NSURLRequest requestWithURL:_url];
    __weak __typeof(self) wself = self;
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:repuest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong __typeof(self) sself = wself;
        if (!sself.completedBlock) {
            [sself end];
            return ;
        }
        
        if (data == nil) {
            sself.completedBlock(nil, nil, error);
            [sself end];
            return ;
        }
        
        if (sself.isCancelled) {
            [sself reset];
            return;
        }
        
        UIImage *image = [UIImage hu_imageFromData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            sself.completedBlock(image, data, nil);
            [sself end];
        }];
        
    }];
    [task resume];
}

- (void)reset {
    self.completedBlock = nil;
    [[self.session dataTaskWithURL:_url] cancel];
    [self end];
}

- (void)end {
    _myExecuting = NO;
    _myFinished = YES;
}

@end
