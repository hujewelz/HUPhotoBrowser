//
//  Toast.m
//  Pods
//
//  Created by jewelz on 2017/9/16.
//
//

#import "HUToast.h"
#import "UIView+HUConstraint.h"

@interface HUToast ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation HUToast

+ (instancetype)sharedInstance {
    static HUToast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[self alloc] init];
    });
    return toast;
}

+ (void)makeToast:(NSString *)message inView:(UIView *)view {
    [[HUToast sharedInstance] makeToast:message inView:view];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 160, 100)];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.messageLabel.frame = self.bounds;
}

- (void)makeToast:(NSString *)message inView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        return;
    }
    
    self.alpha = 0;
    self.messageLabel.text = message;
    self.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(hide:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
    
}

- (void)hide:(NSTimer *)timer {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [timer invalidate];
       
    }];
    
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.messageLabel];
    
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

@end
