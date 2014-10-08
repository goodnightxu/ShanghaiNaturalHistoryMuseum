//
//  SystemInfoViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/18.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "SystemInfoViewController.h"
#import "DataManager.h"
#import "User.h"
#import "AccountManagerViewController.h"

@interface SystemInfoViewController ()

@end

@implementation SystemInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(User *)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeNavUI];
    
    [self onNavBt:self.browseBt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav UI
- (void)initializeNavUI
{
    self.browseBt.layer.borderColor = Color(255, 109, 121, 1.0).CGColor;
    self.browseBt.backgroundColor = Color(255, 109, 121, 1.0);
    [self.browseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.browseBt.layer.borderWidth = 1.0;
    self.browseBt.layer.cornerRadius = self.browseBt.bounds.size.width * 0.5;
    
    self.pathBt.layer.borderColor = Color(255, 132, 20, 1.0).CGColor;
    self.pathBt.backgroundColor = Color(255, 132, 20, 1.0);
    [self.pathBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pathBt.layer.borderWidth = 1.0;
    self.pathBt.layer.cornerRadius = self.browseBt.bounds.size.width * 0.5;
    
    self.messsageBt.layer.borderColor = Color(0, 154, 227, 1.0).CGColor;
    self.messsageBt.backgroundColor = Color(0, 154, 227, 1.0);
    [self.messsageBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.messsageBt.layer.borderWidth = 1.0;
    self.messsageBt.layer.cornerRadius = self.browseBt.bounds.size.width * 0.5;
}

- (IBAction)onNavBt:(UIButton *)navBt
{
    [self initializeNavUI];
    
    [navBt setTitleColor:navBt.backgroundColor forState:UIControlStateNormal];
    navBt.backgroundColor = [UIColor whiteColor];
    
    if (navBt == self.browseBt) {
        //
    }else if (navBt == self.pathBt)
    {
    
    }else if (navBt == self.messsageBt)
    {
        
    }
    
}

#pragma mark - 显示账号管理
- (void)showAccountManager
{
    if (self.accountManagerVC.view.superview != nil) {
        return;
    }
    User *user = [DataManager getUser];
    self.accountManagerVC = [[AccountManagerViewController alloc] initWithNibName:@"AccountManagerViewController" bundle:nil user:user];
    __weak SystemInfoViewController *weakSelf = self;
    [self.accountManagerVC setOnComplete:^(User *updatedUser){
        {
            //更新头像和昵称
            if (updatedUser != nil) {
                weakSelf.onUpdate(updatedUser);
            }
            
            //
            [weakSelf.accountManagerVC removeFromParentViewController];
            weakSelf.accountManagerVC = nil;
        }
    }];
    
    [self.view addSubview:self.accountManagerVC.view];
    [self addChildViewController:self.accountManagerVC];

}



#pragma mark － 进场、退场
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (parent != nil)
    {
        CGFloat aniDur = 0;
        if (self.animated) {
            aniDur = 0.25;
        }
        self.navSV.transform = CGAffineTransformMakeTranslation(0, -390);
        [self.navSV layoutIfNeeded];
        [UIView animateWithDuration:aniDur animations:^{
            self.navSV.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    [super didMoveToParentViewController:parent];
    if (parent == nil) {
        CGFloat aniDur = 0;
        if (self.animated) {
            aniDur = 0.25;
        }
        [self.navSV layoutIfNeeded];
        [UIView animateWithDuration:aniDur animations:^{
            self.navSV.transform = CGAffineTransformMakeTranslation(0, -390);
            [self.navSV layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    }
    
}



@end
