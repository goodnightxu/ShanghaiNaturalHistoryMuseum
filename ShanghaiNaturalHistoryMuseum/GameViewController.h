//
//  GameViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/9.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDFlipClockView;
@class GameThemeItem;
@class GameTaskItem;

@interface TaskView : UIView

@property (nonatomic, strong) GameTaskItem *taskItem;

@end

@interface TaskButton : UIButton

@property (nonatomic, strong) GameTaskItem *taskItem;
@property (nonatomic, strong) UIImage *blurImage;

@end

@interface ThemeButton : UIButton

@property (nonatomic, strong) GameThemeItem *theme;

@end


#pragma mark - GameViewController
@interface GameViewController : UIViewController <UIPopoverControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *menuSV;
@property (nonatomic, weak) IBOutlet UIView *stopwatch;

///开始寻宝游戏
@property (nonatomic, weak) IBOutlet UIButton *startBt;
///已完成任务数
@property (nonatomic, weak) IBOutlet UILabel *completeTaskLabel;

///
@property (nonatomic, weak) IBOutlet UIView *contentView;
///主题菜单
@property (nonatomic, weak) IBOutlet UIScrollView *themeSV;
///任务列表
@property (nonatomic, weak) IBOutlet UIScrollView *taskSV;

@property (nonatomic, strong) UIPopoverController *popover;

///Event
@property (nonatomic, strong) void (^onStartTask)(NSArray *infoItems);

- (IBAction)onStartBt:(id)sender;

@end
