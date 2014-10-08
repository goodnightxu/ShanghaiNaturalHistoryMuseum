//
//  MovieControlView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-28.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MovieControlView.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation MovieControlView

@synthesize delegate;
@synthesize pauseBtn;
@synthesize movieDuration;

- (id)initWithTitle:(NSString *)title
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    CGRect frame=CGRectMake(0, 543, 1024, 115);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, 1024, 35)];
        titleLabel.text=title;
        titleLabel.font=[UIFont fontWithName:LanTingHei size:30.0f];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        resizeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        resizeBtn.frame=CGRectMake(790, 0, 40, 40);
        resizeBtn.showsTouchWhenHighlighted=YES;
        [resizeBtn setImage:[UIImage imageNamed:@"video_tobig.png"] forState:UIControlStateNormal];
        [resizeBtn setImage:[UIImage imageNamed:@"video_tosmall.png"] forState:UIControlStateSelected];
        [resizeBtn addTarget:self
                      action:@selector(clickResizeBtn:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resizeBtn];
        
        volumeView=[[UIView alloc] initWithFrame:CGRectMake(609, 0, 175 , 40)];
        volumeView.backgroundColor=[UIColor clearColor];
        [self addSubview:volumeView];
        
        UIImageView *volBackImageView=[[UIImageView alloc] initWithFrame:volumeView.bounds];
        volBackImageView.image=[UIImage imageNamed:@"video_volume_back.png"];
        volBackImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [volumeView addSubview:volBackImageView];
        
        UIImageView *volIconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        volIconImageView.image=[UIImage imageNamed:@"video_volume_icon.png"];
        [volumeView addSubview:volIconImageView];
        
        volumeSlider=[[UISlider alloc] initWithFrame:CGRectMake(40, 4, 119, 31)];
        volumeSlider.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [volumeSlider setThumbImage:[UIImage imageNamed:@"video_slider_thumb.png"] forState:UIControlStateNormal];
        [volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"video_slider_left.png"] forState:UIControlStateNormal];
        [volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"video_slider_right.png"] forState:UIControlStateNormal];
        volumeSlider.maximumValue = 1.0;
        volumeSlider.minimumValue = 0.0;
        volumeSlider.value = [self volume];
        [volumeSlider addTarget:self action:@selector(changeSliderValue) forControlEvents:UIControlEventValueChanged];
        [volumeView addSubview:volumeSlider];
        
        
        
        pauseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        pauseBtn.frame=CGRectMake(559, 0, 40, 40);
        pauseBtn.showsTouchWhenHighlighted=YES;
        [pauseBtn setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateSelected];
        [pauseBtn addTarget:self
                      action:@selector(clickPauseBtn:)
            forControlEvents:UIControlEventTouchUpInside];
        pauseBtn.enabled=NO;
        [self addSubview:pauseBtn];
        
        
        progressSlider=[[UISlider alloc] initWithFrame:CGRectMake(293, 17, 243, 6)];
        progressSlider.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [progressSlider setThumbImage:[UIImage alloc] forState:UIControlStateNormal];
        [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"video_slider_left.png"] forState:UIControlStateNormal];
        [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"video_slider_right.png"] forState:UIControlStateNormal];
        progressSlider.maximumValue = 1.0;
        progressSlider.minimumValue = 0.0;
        progressSlider.value = 0;
        progressSlider.userInteractionEnabled=NO;
        [self addSubview:progressSlider];
        
        
        timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 100 , 40)];
        timeLabel.text=@"00'00\"";
        timeLabel.textAlignment=NSTextAlignmentRight;
        timeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:timeLabel];
        
       
        
    }
    return self;
}

#warning 后期有时间完善：检测静音、监听耳机插拔、airplay开关
-(void)changeSliderValue{
    [self setVolume:volumeSlider.value];
}
-(void)volumeChanged:(NSNotification *)noti {
    float volume =[[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]floatValue];
    volumeSlider.value=volume;
}
- (float)volume {
    return [[MPMusicPlayerController applicationMusicPlayer] volume];
}
- (void)setVolume:(float)newVolume {
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:newVolume];
}



-(void)finish {
    pauseBtn.selected=YES;
    timeLabel.text=[self convertTimeToString:movieDuration];
}
-(void)showCurrentTime:(NSTimeInterval)time {
    progressSlider.value = 1-time/movieDuration;
    pauseBtn.enabled=YES;
    timeLabel.text=[self convertTimeToString:time];
}

-(NSString *)convertTimeToString:(NSTimeInterval)time {
    int minute=(int)time/60;
    int second=time-minute*60;
    return [NSString stringWithFormat:@"%02i'%02i\"",minute,second];
}

-(void)clickPauseBtn:(UIButton *)sender {
    sender.enabled=NO;
    BOOL flag = sender.selected ? NO : YES;
    if ([delegate respondsToSelector:@selector(videoNeedPause:button:)]) {
        [delegate videoNeedPause:flag button:sender];
    }
    sender.selected=!sender.selected;
}
-(void)clickResizeBtn:(UIButton *)sender {
    sender.enabled=NO;
    BOOL flag = sender.selected ? NO : YES;
    [self changeUIToBig:flag];
    if ([delegate respondsToSelector:@selector(videoNeedResizeToBig:button:)]) {
        [delegate videoNeedResizeToBig:flag button:sender];
    }
    sender.selected=!sender.selected;
}

-(void)changeUIToBig:(BOOL)flag {
    if (flag) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             pauseBtn.frame=CGRectMake(700, 25, 40, 40);
                             volumeView.frame=CGRectMake(750, 25, 175 , 40);
                             resizeBtn.frame=CGRectMake(935, 25, 40, 40);
                             timeLabel.frame=CGRectMake(0, 25, 100 , 40);
                             progressSlider.frame=CGRectMake(153, 25+17, 523, 6);
                         }];
        
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             pauseBtn.frame=CGRectMake(559, 0, 40, 40);
                             volumeView.frame=CGRectMake(609, 0, 175 , 40);
                             resizeBtn.frame=CGRectMake(790, 0, 40, 40);
                             timeLabel.frame=CGRectMake(150, 0, 100 , 40);
                             progressSlider.frame=CGRectMake(293, 17, 243, 6);
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
