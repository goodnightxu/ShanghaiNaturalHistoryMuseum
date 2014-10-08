//
//  MovieControlView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-28.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovieControlViewDelegate <NSObject>

-(void)videoNeedResizeToBig:(BOOL)flag button:(UIButton *)btn;//YES表示放大，NO表示缩小
-(void)videoNeedPause:(BOOL)flag button:(UIButton *)btn;//YES表示暂停，NO表示继续播放

@end


@interface MovieControlView : UIView {
    UIButton *resizeBtn;
    UIView *volumeView;
    UILabel *timeLabel;
    UISlider *volumeSlider;
    UISlider *progressSlider;
}

@property(nonatomic,weak)id<MovieControlViewDelegate>delegate;
@property(nonatomic,strong)UIButton *pauseBtn;
@property(nonatomic,assign)NSTimeInterval movieDuration;

- (id)initWithTitle:(NSString *)title;
-(void)showCurrentTime:(NSTimeInterval)time;
-(void)finish;

@end
