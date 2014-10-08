//
//  SystemManagerViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;
@class SystemInfoViewController;

@interface SystemManagerViewController : UIViewController

///ContentView
@property (nonatomic, weak) IBOutlet UIView *contentView;
///提示登录
@property (nonatomic, weak) IBOutlet UIView *alarmView;
///用户信息
@property (nonatomic, weak) IBOutlet UIView *userInfoView;
@property (nonatomic, weak) IBOutlet UIView *iconView;
@property (nonatomic, weak) IBOutlet UIButton *userPortrait;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;



//ViewController
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) SystemInfoViewController *systemInfoVC;

- (IBAction)onManageBt:(id)sender;
- (IBAction)onLogoutBt:(id)sender;

@end
