//
//  StopWatchView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/10.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "StopwatchView.h"
#import <JDFlipNumberView.h>

#define kWidth 30
#define kHeight 50
#define kCount 2

@interface StopwatchView()
{
    JDFlipNumberView *_hourView;
    JDFlipNumberView *_minuteView;
    JDFlipNumberView *_secondView;
    
    NSTimer *_orderTimer;
    NSDate *_startDate;
}

@end

@implementation StopwatchView

- (id)initWithFrame:(CGRect)frame imageBundleName:(NSString *)imageBundleName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _hourView = [[JDFlipNumberView alloc] initWithDigitCount:kCount imageBundleName:imageBundleName];
        _hourView.reverseFlippingDisabled = YES;
        _hourView.frame=CGRectMake(0, 0, kWidth*kCount, kHeight);
        _hourView.center = CGPointMake(viewCenter(frame).x - kWidth*2 - 15, viewCenter(frame).y);
        [self addSubview:_hourView];
        
        _minuteView = [[JDFlipNumberView alloc] initWithDigitCount:kCount imageBundleName:imageBundleName];
        _minuteView.reverseFlippingDisabled = YES;
        _minuteView.frame=CGRectMake(0, 0, kWidth*kCount, kHeight);
        _minuteView.center = viewCenter(frame);
        [self addSubview:_minuteView];
        
        _secondView =[[JDFlipNumberView alloc] initWithDigitCount:kCount imageBundleName:imageBundleName];
        _secondView.reverseFlippingDisabled = YES;
        _secondView.frame=CGRectMake(0, 0, kWidth*kCount, kHeight);
        _secondView.center = CGPointMake(viewCenter(frame).x + kWidth*2 + 15, viewCenter(frame).y);
        [self addSubview:_secondView];
        
        
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kStopwatchStartDate];
        if (lastDate != nil) {
            [self start];
        }
    }

    return self;
    
}

#pragma mark - 开始、停止
-(void)start
{
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kStopwatchStartDate];
    if (lastDate == nil) {
        _startDate = [NSDate date];
    }else{
        _startDate = lastDate;
    }
    //保存开始时间
    [[NSUserDefaults standardUserDefaults] setObject:_startDate forKey:kStopwatchStartDate];



    if (_orderTimer != nil) {
        [_orderTimer invalidate];
        _orderTimer = nil;
    }
    _orderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                                 selector:@selector(updateTime)
                                              userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_orderTimer forMode:NSDefaultRunLoopMode];
    [_orderTimer fire];
    
    self.isRunning = YES;
}

- (void)stop
{

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kStopwatchStartDate];
    
    [_orderTimer invalidate];
    _orderTimer = nil;
    
    self.isRunning = NO;
}


#pragma mark - 时间更新
-(void)updateTime {
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSinceDate:_startDate];
    
    int hour=(int)timeInterval/(60*60);
    int minute=(int)(timeInterval-hour*60*60)/60;
    int second=timeInterval-hour*60*60-minute*60;
    [_hourView setValue:hour animated:YES];
    [_minuteView setValue:minute animated:YES];
    [_secondView setValue:second animated:YES];
}




@end
