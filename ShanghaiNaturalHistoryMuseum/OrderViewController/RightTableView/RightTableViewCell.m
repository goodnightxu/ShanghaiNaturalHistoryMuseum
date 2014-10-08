//
//  RightTableViewCell.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell {
      NSTimer *orderTimer;
}

@synthesize nameLabel;
@synthesize startTimeString;
@synthesize delegate;
@synthesize startTimeLabel;
@synthesize hourNumberView;
@synthesize minNumberView;
@synthesize secNumberView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 159)];
        backImageView.backgroundColor=[UIColor clearColor];
        backImageView.image=[UIImage imageNamed:@"order_myorder_back.png"];
        [self.contentView addSubview:backImageView];
        
        
        startTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 11, 270, 37)];
        startTimeLabel.backgroundColor=[UIColor clearColor];
        startTimeLabel.textAlignment=NSTextAlignmentCenter;
        startTimeLabel.textColor=[UIColor whiteColor];
        startTimeLabel.font=[UIFont fontWithName:@"DINCondensed-Bold" size:20.0f];
        startTimeLabel.text=@"%%  ##";
        startTimeLabel.hidden=YES;
        [self.contentView addSubview:startTimeLabel];
        
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(39, 45, 179, 45)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 2;
        nameLabel.font=[UIFont fontWithName:LanTingHei size:16.0f];
        [self.contentView addSubview:nameLabel];
        
        hourNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        hourNumberView.reverseFlippingDisabled = YES;
        hourNumberView.frame=CGRectMake(74, 117, 30, 25);
        [self.contentView addSubview:hourNumberView];
        
        minNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        minNumberView.reverseFlippingDisabled = YES;
        minNumberView.frame=CGRectMake(hourNumberView.frame.origin.x+40, hourNumberView.frame.origin.y, 30, 25);
        [self.contentView addSubview:minNumberView];
        
        secNumberView=[[JDFlipNumberView alloc] initWithDigitCount:2];
        secNumberView.reverseFlippingDisabled = YES;
        secNumberView.frame=CGRectMake(minNumberView.frame.origin.x+40, hourNumberView.frame.origin.y, 30, 25);
        [self.contentView addSubview:secNumberView];
        
        
    }
    return self;
}

-(void)setStartTimeString:(NSString *)_startTimeString {
    startTimeString=_startTimeString;
    
    orderTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                              selector:@selector(showTime)
                                              userInfo:nil
                                               repeats:YES];
    //重要：解决滑动tableview时动画不动
   [[NSRunLoop currentRunLoop] addTimer:orderTimer
                                forMode:NSRunLoopCommonModes];
    
}

-(void)showTime {
//    NSArray *myArray1=[[[startTimeString componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
//    startTimeLabel.text=[startTimeLabel.text stringByReplacingOccurrencesOfString:@"%%" withString:[myArray1 objectAtIndex:0]];
//    startTimeLabel.text=[startTimeLabel.text stringByReplacingOccurrencesOfString:@"##" withString:[myArray1 objectAtIndex:1]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
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
        if ([delegate respondsToSelector:@selector(eventDidStartForIndexPath:)]) {
            [delegate eventDidStartForIndexPath:[NSIndexPath indexPathForRow:self.tag inSection:0]];
        }
    }
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
