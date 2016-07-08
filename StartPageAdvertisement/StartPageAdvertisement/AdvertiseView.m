//
//  AdvertiseView.m
//  StartPageAdvertisement
//
//  Created by heivr.mxy on 16/7/8.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import "AdvertiseView.h"

@interface AdvertiseView ()

@property (nonatomic,strong)UIImageView *adView;
@property (nonatomic,strong)UIButton *countBtn;
@property (nonatomic,strong)NSTimer *countTimer;
@property (nonatomic,assign)NSInteger count;
@end

//广告显示时间
static int const showTime = 5;

@implementation AdvertiseView

- (NSTimer *)countTimer{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //1.广告图片
        _adView = [[UIImageView alloc]initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
        [self addSubview:_adView];
        // 2.跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kscreenWidth - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showTime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_countBtn];

    }
    return self;
}
//复写set方法
- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}
- (void)pushToAd{
    
    [self dismiss];
    //点击后发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

- (void)countDown
{
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%ld",(long)_count] forState:UIControlStateNormal];
    if (_count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self dismiss];
    }
}

- (void)show{
    // 倒计时方法1：GCD
    //    [self startCoundown];
    
    // 倒计时方法2：定时器
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

}
- (void)startTimer{
    _count = showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

- (void)startCountdown{
    __block int timeout = showTime + 1;
    //创建同步队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {//倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //回到主线程移除
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    //移除
    dispatch_resume(_timer);

}




// 移除广告页面
- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

@end
