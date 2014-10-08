//
//  StopWatchView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/10.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStopwatchStartDate @"StopwatchStartDate"

@interface StopwatchView : UIView

///stopwatch每次start使用保存在系统的开始时间计数
///运行中
@property (nonatomic, assign) BOOL isRunning;

- (id)initWithFrame:(CGRect)frame imageBundleName:(NSString *)imageBundleName;

//
- (void)start;
- (void)stop;

@end
