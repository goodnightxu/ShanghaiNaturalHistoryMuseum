//
//  GameViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/9.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "GameViewController.h"
#import "DataManager.h"
#import "GameThemeItem.h"
#import "GameTaskItem.h"
#import "StopWatchView.h"
#import <JDFlipClockView.h>
#import "GlowLabel.h"
#import "GameDetailViewController.h"

#import <CoreImage/CoreImage.h>

//主题
#define kThemeButtonWidth 99
#define kThemeButtonHeight 42
#define kThemeButtonPadding 2
//任务
#define kTaskIconWidth 151
#define kTaskIconHeight 151

#define kTaskButtonWidth 87
#define kTaskButtonHeight 33

#define kTaskViewWidth 151
#define kTaskViewHeight 231
#define kTaskViewPadding 20


@implementation TaskButton



@end


@implementation ThemeButton


@end

@interface GameViewController ()
{
    GameThemeItem *_currentThemeItem;
    
    //
    StopwatchView *_clockView;
    //
    NSInteger _completeTaskNumber;
    
    //Temp
    UIView *_taskView;
    UIView *_maskView;
}

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    //可拖动
    [self.menuSV setContentSize:CGSizeMake(0, self.menuSV.bounds.size.height +1)];
    
    _clockView = [[StopwatchView alloc] initWithFrame:self.stopwatch.bounds imageBundleName:@"StopwatchGreen"];
    [self.stopwatch addSubview:_clockView];
    if (_clockView.isRunning)
    {
        [self.startBt setTitle:@"放弃寻宝" forState:UIControlStateNormal];
    }else{
        [self.startBt setTitle:@"开始寻宝" forState:UIControlStateNormal];
    }
    
    //主题菜单
    [self initializeThemeSV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 主题菜单
- (void)initializeThemeSV
{
    [self.themeSV setContentSize:CGSizeMake(0, 560)];
    [DataManager loadGameThemesInView:self.contentView callback:^(NSArray *themes, BOOL success) {
        if (success) {
            

            ThemeButton *firstBt = [self themeBtWithThemeItem:themes[0] index:0];
            [self.themeSV addSubview:firstBt];
            [self onThemeButton:firstBt];

            for (NSInteger n= 1; n< themes.count; n++) {
                GameThemeItem *themeItem = themes[n];
                ThemeButton *bt = [self themeBtWithThemeItem:themeItem index:n];
                [self.themeSV addSubview:bt];
            }
            
            
            
            self.themeSV.contentSize = CGSizeMake(themes.count * (kThemeButtonPadding + kThemeButtonWidth), 0);
        }
    }];
}

- (ThemeButton *)themeBtWithThemeItem:(GameThemeItem *)themeItem index:(NSInteger)index
{
    ThemeButton *bt = [ThemeButton buttonWithType:UIButtonTypeCustom];
    bt.theme = themeItem;

    bt.frame = CGRectMake(index *(kThemeButtonWidth + kThemeButtonPadding), 29, kThemeButtonWidth, kThemeButtonHeight);
    [bt setTitle:themeItem.title forState:UIControlStateNormal];
    [bt setTitleColor:kColorGary2 forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont fontWithName:kFontHeitiLight size:16];
    
    bt.titleLabel.backgroundColor = [UIColor clearColor];
    bt.backgroundColor = [UIColor whiteColor];
    
    
    
    [bt addTarget:self action:@selector(onThemeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return bt;
}

- (void)onThemeButton:(ThemeButton *)themeBt
{
    //已选择返回
    if (themeBt.theme == _currentThemeItem) {
        return;
    }
    
    //更新当前主题
    _currentThemeItem = themeBt.theme;

    //初始状态
    for (ThemeButton *bt in self.themeSV.subviews) {
        if ([bt isKindOfClass:[ThemeButton class]]) {
            bt.backgroundColor = [UIColor whiteColor];
            bt.titleLabel.textColor = kColorGary2;
        }
    }
    
    //选定状态
    themeBt.backgroundColor =  kColorGreen1;
    [themeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //
    [self initializeTaskSV:themeBt.theme];
}


#pragma mark - Task SV
- (void)initializeTaskSV:(GameThemeItem *)gameThemeItem
{
    NSAssert(gameThemeItem != nil, @"初始任务清单, gameThemeItem 不能为空");
    
    if (self.taskSV.alpha == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.taskSV.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self cleanTaskView];
            [self addTaskView:gameThemeItem];
            [UIView animateWithDuration:0.25 animations:^{
                self.taskSV.alpha = 1.0;
            }];
        }];
    }else{
        [self addTaskView:gameThemeItem];
    }
    
}

- (void)addTaskView:(GameThemeItem *)gameThemeItem
{
    [DataManager loadGameTasksWithTheme:gameThemeItem inView:self.contentView callback:^(NSArray *gameTasks, BOOL success) {
        if (success) {
            
            //NSMutableArray *temps = [NSMutableArray arrayWithArray:gameTasks];
            //[temps addObjectsFromArray:gameTasks];
            
            //任务数
            _completeTaskNumber = 0;
            for (NSInteger index = 0; index < gameTasks.count; index++) {
                GameTaskItem *taskItem = gameTasks[index];
                if (taskItem.status) {
                    _completeTaskNumber ++;
                }
                
                UIView *taskView = [self taskViewWithTaskItem:taskItem index:index];
                taskView.tag = 99;
                [self.taskSV addSubview:taskView];
            }
            
            
            self.completeTaskLabel.text = [NSString stringWithFormat:@"%li / 6", (long)_completeTaskNumber];
            
            
            
        }
    }];
}

- (void)cleanTaskView
{
    for (UIView *taskView in self.taskSV.subviews) {
        if (taskView.tag == 99) {
            [taskView removeFromSuperview];
        }
    }
}

- (UIView *)taskViewWithTaskItem:(GameTaskItem *)taskItem index:(NSInteger)index
{
    
    CGFloat offsetX = (1024-270) * 0.25;
    CGFloat offsetY = 0;
    if (index > 2) {
        offsetY = kTaskViewHeight + 20;
        offsetX = offsetX * (index + 1 -3);
    }else{
        offsetX = offsetX * (index + 1);
    }
    UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(offsetX- kTaskViewWidth * 0.5f, offsetY, kTaskViewWidth, kTaskViewHeight)];

    //Icon
    TaskButton *iconBt = [[TaskButton alloc] initWithFrame:CGRectMake(0, 0, kTaskIconWidth, kTaskIconHeight)];
    iconBt.taskItem = taskItem;
    iconBt.layer.cornerRadius = kTaskIconWidth * 0.5;
    iconBt.clipsToBounds = YES;
    iconBt.layer.borderWidth = 4;
    iconBt.layer.borderColor = [UIColor whiteColor].CGColor;
    [DataManager loadPicWithPath:taskItem.titlePic inView:iconBt callback:^(UIImage *image, BOOL useCaceh, BOOL success) {
        if (success) {
            if (!taskItem.status) {
                //未完成
                //模糊Icon
                CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
                CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
                [blurFilter setValue:inputImage forKey:kCIInputImageKey];
                [blurFilter setValue:[NSNumber numberWithFloat:10.0] forKey:kCIInputRadiusKey];
                CIImage *blurOutput = [blurFilter valueForKey:kCIOutputImageKey];
                UIImage *outputImage = [UIImage imageWithCIImage:blurOutput];
                
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTaskIconWidth *1.2, kTaskIconHeight *1.2)];
                iconImageView.image = outputImage;
                
                [iconBt addSubview:iconImageView];
                iconImageView.center = viewCenter(iconBt.bounds);
                iconBt.blurImage = outputImage;
                
                //locked
                UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:iconBt.bounds];
                lockImageView.image = [UIImage imageNamed:@"lockIcon.png"];
                lockImageView.contentMode = UIViewContentModeCenter;
                [iconBt addSubview:lockImageView];

                //Event
                [iconBt addTarget:self action:@selector(onIconBt:) forControlEvents:UIControlEventTouchUpInside];
    
            }else{
                //已完成
                [iconBt setBackgroundImage:image forState:UIControlStateNormal];
                iconBt.enabled = NO;
                
                
                UIImageView *complete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gameComplete.png"]];
                
                complete.center = CGPointMake(kTaskIconWidth * 0.5f, kTaskViewHeight - 107*0.5);
                [taskView addSubview:complete];
            }
        }
    }];
    [taskView addSubview:iconBt];
    
    
    //Label
    GlowLabel *titleLabel = [[GlowLabel alloc] initWithFrame:CGRectMake(0, kTaskIconHeight + 20, kTaskViewWidth, 15)];
    titleLabel.textColor = kColorBlack1;
    titleLabel.font = [UIFont fontWithName:kFontHeitiLight size:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = taskItem.title;
    [taskView addSubview:titleLabel];
    
    //
//    UIButton *startBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    startBt.frame = CGRectMake((kTaskViewWidth - kTaskButtonWidth) *0.5, kTaskIconWidth + 20 + 15+ 20, kTaskButtonWidth, kTaskButtonHeight);
//    startBt.backgroundColor = kColorGreen1;
//    startBt.layer.cornerRadius = 5.0f;
//    startBt.titleLabel.font = [UIFont fontWithName:kFontHeitiLight size:15];
//    [startBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [startBt setTitle:@"开始任务" forState:UIControlStateNormal];
//    [startBt addTarget:self  action:@selector(onTaskStartBt:) forControlEvents:UIControlEventTouchUpInside];
//    if (!taskItem.status) {
//        //完成
//        startBt.enabled = YES;
//        [startBt setBackgroundColor:kColorGreen1];
//    }else{
//        [startBt setBackgroundColor:kColorGary2];
//        startBt.enabled = NO;
//    }
//    
//    
//    [taskView addSubview:startBt];
    
    return taskView;
}

- (void)onTaskStartBt:(TaskButton *)taskButton
{
    NSLog(@"on start bt");
    GameThemeItem *themeItem = [[GameThemeItem alloc] init];
    themeItem.sid = taskButton.taskItem.tid;
    __weak GameViewController *weakSelf = self;
    [DataManager loadExhibitsWithGameTheme:themeItem callback:^(NSArray *infos, BOOL success) {
        //
        if (success && weakSelf.onStartTask != nil) {
            
            weakSelf.onStartTask(infos);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)onIconBt:(TaskButton *)iconBt
{
    //显示DetailView
    CGPoint iconCenter = [self.view convertPoint:iconBt.center fromView:iconBt.superview];
    
    if (_maskView.superview == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        
        [self.contentView addSubview:_maskView];
    }

    GameDetailViewController *detailVC = [[GameDetailViewController alloc] initWithNibName:@"GameDetailViewController" bundle:nil taskButton:iconBt];
    detailVC.view.center = CGPointMake(iconCenter.x , iconCenter.y + (385-151)*0.5f);
    detailVC.view.alpha =0.0f;
    [self.view addSubview:detailVC.view];
    [self addChildViewController:detailVC];
    [detailVC didMoveToParentViewController:self];
    
    /*
    CGFloat x = CGRectGetMinX(detailVC.view.frame);
    if (x< 0 ) {
        [detailVC.view layoutIfNeeded];
        detailVC.contentView.transform= CGAffineTransformMakeTranslation(-x, 0);
    }
     */
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.3f;
        detailVC.view.alpha = 1.0f;
    }];
    
    
    //移除
    __weak GameDetailViewController *weakDetailVC = detailVC;
    [detailVC setOnClose:^{
        [UIView animateWithDuration:0.25 animations:^{
            _maskView.alpha = 0.0;
            weakDetailVC.view.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [_maskView removeFromSuperview];
            _maskView = nil;
            
            [weakDetailVC willMoveToParentViewController:nil];
            [weakDetailVC.view removeFromSuperview];
            [weakDetailVC removeFromParentViewController];
            [weakDetailVC didMoveToParentViewController:nil];
        }];
    }];
    
    [detailVC setOnStart:^(TaskButton *taskBt){
        [UIView animateWithDuration:0.25 animations:^{
            _maskView.alpha = 0.0;
            weakDetailVC.view.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [_maskView removeFromSuperview];
            _maskView = nil;
            
            [weakDetailVC willMoveToParentViewController:nil];
            [weakDetailVC.view removeFromSuperview];
            [weakDetailVC removeFromParentViewController];
            [weakDetailVC didMoveToParentViewController:nil];
        }];
        
        
        [self onTaskStartBt:taskBt];
         //[self.navigationController popViewControllerAnimated:YES];
        
    }];
 
}



#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = nil;
    nav.subBottomTitle = nil;
    
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}

- (void)onMenuBt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button 开始寻宝
- (IBAction)onStartBt:(id)sender
{
    
    if (_clockView.isRunning) {
        [self.startBt setTitle:@"开始寻宝" forState:UIControlStateNormal];
        [_clockView stop];
    }else{
        [self.startBt setTitle:@"放弃寻宝" forState:UIControlStateNormal];
        [_clockView start];
    }
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
