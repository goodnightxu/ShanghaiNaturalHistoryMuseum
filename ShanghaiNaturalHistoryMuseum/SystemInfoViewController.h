//
//  SystemInfoViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/18.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class AccountManagerViewController;
@interface SystemInfoViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIScrollView *navSV;
@property (nonatomic, weak) IBOutlet UIButton *browseBt;
@property (nonatomic, weak) IBOutlet UIButton *pathBt;
@property (nonatomic, weak) IBOutlet UIButton *messsageBt;

@property (nonatomic, strong) AccountManagerViewController *accountManagerVC;

@property (nonatomic, assign) BOOL animated;

//Data
@property (nonatomic, strong) User *user;
///更新用户信息
@property (nonatomic, strong) void (^onUpdate)(User *user);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(User *)user;

- (void)showAccountManager;


@end
