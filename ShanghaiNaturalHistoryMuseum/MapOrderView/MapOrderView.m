//
//  MapOrderView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MapOrderView.h"


@implementation MapOrderView


- (id)initWithFloor:(FloorType)floor position:(CGPoint)point orderItem:(OrderItem *)orderItem
{
    
    CGRect frame=CGRectMake(point.x-187, point.y-144, 187 , 144);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        hourString=orderItem.beginTime;
        
        UIColor *color;
        UIImageView *backImageView=[[UIImageView alloc] initWithFrame:self.bounds];
        if (floor==Floor1) {
            color=kColorL1;
            backImageView.image=[UIImage imageNamed:@"mapporder_1.png"];
        } else if(floor==Floor2) {
            color=kColorL2;
            backImageView.image=[UIImage imageNamed:@"mapporder_2.png"];
        } else if(floor==FloorUnderGround1) {
            color=kColorB1;
            backImageView.image=[UIImage imageNamed:@"mapporder_3.png"];
        }else if(floor==FloorUnderGroundInter) {
            color=kColorB2M;
            backImageView.image=[UIImage imageNamed:@"mapporder_4.png"];
        }else if(floor==FloorUnderGround2) {
            color=kColorB2;
            backImageView.image=[UIImage imageNamed:@"mapporder_5.png"];
        }
        [self addSubview:backImageView];
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 20, self.frame.size.width-80, 40)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=color;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont fontWithName:LanTingHei size:16.0f];
        titleLabel.numberOfLines=2;
        titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
//        titleLabel.text=orderItem.name;
        titleLabel.text=@"影片名影片名影片名";
        [self addSubview:titleLabel];
        
        UILabel *beginTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(9, 58, self.frame.size.width, 40)];
        beginTimeLabel.backgroundColor=[UIColor clearColor];
        beginTimeLabel.textColor=color;
        beginTimeLabel.textAlignment=NSTextAlignmentCenter;
        beginTimeLabel.font=[UIFont fontWithName:@"DINCondensed-Bold" size:20.0f];
        beginTimeLabel.numberOfLines=2;
        beginTimeLabel.lineBreakMode=NSLineBreakByWordWrapping;
//        beginTimeLabel.text=orderItem.beginTime;
        beginTimeLabel.text=@"14:00";
        [self addSubview:beginTimeLabel];
        
        hourNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        hourNumberView.reverseFlippingDisabled = YES;
        hourNumberView.frame=CGRectMake(48, 109, 30, 25);
        [self addSubview:hourNumberView];

        minNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        minNumberView.reverseFlippingDisabled = YES;
        minNumberView.frame=CGRectMake(hourNumberView.frame.origin.x+40, hourNumberView.frame.origin.y, 30, 25);
        [self addSubview:minNumberView];

        secNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        secNumberView.reverseFlippingDisabled = YES;
        secNumberView.frame=CGRectMake(minNumberView.frame.origin.x+40, hourNumberView.frame.origin.y, 30, 25);
        [self addSubview:secNumberView];
        
        
        orderTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(showTime)
                                                  userInfo:nil
                                                   repeats:YES];
        //重要：解决滑动tableview时动画不动
        [[NSRunLoop currentRunLoop] addTimer:orderTimer
                                     forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)showTime {

    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
    
    NSString *startTimeString=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
    startTimeString=[NSString stringWithFormat:@"%@ %@:00",startTimeString,hourString];
    NSDate *startDate=[dateFormatter dateFromString:startTimeString];
    NSTimeInterval timeInterval=[startDate timeIntervalSinceNow];
    
    int hour=(int)timeInterval/3600;
    int minute=(int)(timeInterval-hour*3600)/60;
    int second=timeInterval-hour*3600-minute*60;
    [hourNumberView setValue:hour animated:YES];
    [minNumberView setValue:minute animated:YES];
    [secNumberView setValue:second animated:YES];
    
    
    if ([startDate timeIntervalSinceNow]<=0) {
        [orderTimer invalidate];
        orderTimer=nil;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
