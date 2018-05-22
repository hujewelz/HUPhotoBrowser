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
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
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

- (void)resume {
    if (self.isCancelled && !self.isFinished) {
        self.myExecuting = YES;
        [_downloadTask resume];
    }
}

- (void)start {
    if (self.isCancelled) {
        [self reset];
        return;
    }
    self.myExecuting = YES;
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    __weak __typeof(self) wself = self;
    
    self.downloadTask = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong __typeof(self) sself = wself;
        
        [sself end];
        
        if (!sself.completedBlock) {
            
            return ;
        }
        
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        [NSFileManager.defaultManager moveItemAtPath:location.path toPath:file error:nil];
        
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        [NSFileManager.defaultManager removeItemAtPath:file error:nil];
        
        if (data == nil || sself.isCancelled) {
            sself.completedBlock(nil, nil, error);
            return ;
        }
        
        UIImage *image = [UIImage hu_imageFromData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            sself.completedBlock(image, data, nil);
        }];
        
    }];
    
    [_downloadTask resume];
}

- (void)reset {
    [self end];
    self.completedBlock = nil;
    [[self.session dataTaskWithURL:_url] cancel];
}

- (void)end {
    self.myExecuting = NO;
    self.myFinished = YES;
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}


@end

