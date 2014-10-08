//
//  SystemManagerViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "SystemManagerViewController.h"
#import "DataManager.h"
#import "User.h"
#import "SystemInfoViewController.h"
#import "LoginViewController.h"


@interface SystemManagerViewController ()

@end

@implementation SystemManagerViewController

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
    [self initializeUI];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)initializeUI
{
    User *user = [DataManager getUser];
    if (user.sid == nil) {
        //没有登录
        [self showLoginWithAnimation:NO];
        [self hideSystemInfoWithAnimation:NO];
    }else{
        [self showSystemInfo:user animation:NO];
    }
}

#pragma mark - Show Login 
- (void)showLoginWithAnimation:(BOOL)animation
{
    //
    CGFloat aniDur = 0;
    if (animation) {
        aniDur = 0.25;
    }
    
    //
    if (self.loginVC == nil) {
        self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        __weak SystemManagerViewController *weakSelf = self;
        [self.loginVC setOnLoginSuccess:^(User *user) {
            [weakSelf hideLoginWithAnimation:YES];
            [weakSelf showSystemInfo:user animation:YES];
        }];
    }
    
    //显示LoginVC
    self.loginVC.animated = animation;
    [self addChildViewController:self.loginVC];
    [self.contentView addSubview:self.loginVC.view];

    //显示提示信息
    self.alarmView.transform = CGAffineTransformMakeTranslation(kRightMenuWidth, 0);
    [self.alarmView layoutIfNeeded];
    [UIView animateWithDuration:aniDur animations:^{
        self.alarmView.transform = CGAffineTransformIdentity;
        [self.alarmView layoutIfNeeded];
    }];
}

- (void)hideLoginWithAnimation:(BOOL)animation
{
    //
    CGFloat aniDur = 0;
    if (animation) {
        aniDur = 0.25;
    }
    
    [self.loginVC removeFromParentViewController];
    self.loginVC = nil;
    
    [UIView animateWithDuration:aniDur animations:^{
         self.alarmView.transform = CGAffineTransformMakeTranslation(kRightMenuWidth, 0);
    }];
}

#pragma mark - Show SystemInfo View Controller
- (void)showSystemInfo:(User *)user animation:(BOOL)ani
{
    //
    CGFloat aniDur = 0;
    if (ani) {
        aniDur = 0.25;
    }
    
    //已经登陆
    if (self.systemInfoVC == nil) {
        self.systemInfoVC = [[SystemInfoViewController alloc] initWithNibName:@"SystemInfoViewController" bundle:nil user:user];
        __weak SystemManagerViewController *weakSelf = self;
        [self.systemInfoVC setOnUpdate:^(User *updatedUser) {
            //
            [weakSelf showSystemInfo:user animation:NO];
        }];
    }
    
    self.systemInfoVC.animated = ani;
    [self.contentView addSubview:self.systemInfoVC.view];
    [self addChildViewController:self.systemInfoVC];
    
    
    //-------------------------------------------------
    //右侧餐单栏
    //Icon
    [self initializeUserInfo:user];
    self.userInfoView.transform = CGAffineTransformMakeTranslation(kRightMenuWidth*2, 0);
    [UIView animateWithDuration:aniDur animations:^{
        self.userInfoView.transform = CGAffineTransformIdentity;
    }];
    
}


- (void)hideSystemInfoWithAnimation:(BOOL)ani
{
    //
    CGFloat aniDur = 0;
    if (ani) {
        aniDur = 0.25;
    }
    //隐藏
    self.systemInfoVC.animated = ani;
    [self.systemInfoVC removeFromParentViewController];
    self.systemInfoVC = nil;

    //隐藏
    [self.userInfoView layoutIfNeeded];
    [UIView animateWithDuration:aniDur animations:^{
        [self.userInfoView setTransform:CGAffineTransformMakeTranslation(kRightMenuWidth*2, 0)];
        [self.userInfoView layoutIfNeeded];
    }];
}

#pragma mark UserInfo Viewpo
- (void)initializeUserInfo:(User *)user
{
    self.userPortrait.clipsToBounds = YES;
    self.userPortrait.layer.cornerRadius = self.userPortrait.bounds.size.width * 0.5;
    [self.userPortrait setBackgroundImage:[UIImage imageNamed:@"portraitDefault.png"] forState:UIControlStateNormal];
    [DataManager loadPicWithPath:user.portraitPath inView:self.userPortrait callback:^(UIImage *image, BOOL useCache, BOOL success) {
        if (success&&image != nil) {
            if (useCache) {
                //使用缓存，不用动画效果
                [self.userPortrait setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                //第一次有动画切换效果
                UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
                bt.clipsToBounds = self.userPortrait.clipsToBounds;
                bt.layer.cornerRadius = self.userPortrait.layer.cornerRadius;
                [bt setBackgroundImage:image forState:UIControlStateNormal];
                bt.frame = self.userPortrait.frame;
                [self.iconView addSubview:bt];
                
                [UIView transitionFromView:self.userPortrait toView:bt duration:0.25 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                    
                    self.userPortrait = bt;
                }];
            }
        }
    }];
    //名字
    self.userName.text = user.nickname;
    //积分
    NSString *scoreString = [NSString stringWithFormat:@"社区积分：%i", user.score.integerValue];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:scoreString];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:kColorBlack1} range:NSMakeRange(0, 4)];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:Color(0, 164, 227, 1)} range:NSMakeRange(5, attributeString.length -5)];
    self.scoreLabel.attributedText = attributeString;
}

#pragma mark - Button
#pragma makr 账号管理
- (IBAction)onManageBt:(id)sender
{
    [self.systemInfoVC showAccountManager];
}

- (IBAction)onLogoutBt:(id)sender
{
    [self hideSystemInfoWithAnimation:YES];
    [self showLoginWithAnimation:YES];
    
    //本地User清空
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser];
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

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
