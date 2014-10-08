//
//  AccountManagerViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "User.h"
#import "DataManager.h"
#import "PictureSelectViewController.h"
#import "UpdatePasswordViewController.h"

#define kFrameSelectedColor Color(255, 84, 0, 1.0).CGColor

@interface AccountManagerViewController ()

@end

@implementation AccountManagerViewController

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
    [self initializeUI];
    [self addKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initializeUI
{
    CGFloat cornerRaidus = 10;
    self.portraitView.layer.cornerRadius = cornerRaidus;
    self.nickView.layer.cornerRadius = cornerRaidus;
    self.emailView.layer.cornerRadius = cornerRaidus;
    self.mobileView.layer.cornerRadius = cornerRaidus;
    
    //账号
    self.accountLabel.text = [self.accountLabel.text stringByAppendingString:self.user.account];
    
    //头像
    //self.portraitBt.layer.cornerRadius = self.portraitBt.bounds.size.width * 0.5;
    self.portraitBt.clipsToBounds = YES;
    self.portraitBt.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.user.portraitPath == nil) {
        [self.portraitBt setImage:[UIImage imageNamed:@"portraitDefault.png"] forState:UIControlStateNormal];
    }else{
        [DataManager loadPicWithPath:self.user.portraitPath inView:self.portraitBt callback:^(UIImage *image, BOOL useCache, BOOL success) {
            if (success) {
                [self. portraitBt setImage:image forState:UIControlStateNormal];
            }
        }];
    }
    
    //昵称
    self.nickTextField.text = self.user.nickname;
    self.nickTextField.delegate = self;
    
    //email
    self.emailTextField.text = self.user.mail;
    self.emailTextField.delegate = self;
    
    //手机
    self.mobilTextField.text = self.user.mobile;
    self.mobilTextField.delegate = self;
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.popover dismissPopoverAnimated:YES];
    UIView *parentView = textField.superview;
    parentView.layer.borderWidth = 2.0f;
    parentView.layer.borderColor = kFrameSelectedColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIView *parentView = textField.superview;
    parentView.layer.borderWidth = 0.0f;
}

#pragma mark - Keyboard
- (void)addKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)hideKeyboard
{
    [self.nickTextField resignFirstResponder];
    [self.mobilTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}


- (void)onKeyboardShow:(NSNotification *)notification
{
    [self.sv setContentOffset:CGPointMake(0, 208) animated:YES];

}

- (void)onKeyboardHide:(NSNotification *)notification
{
    [self.sv setContentOffset:CGPointZero animated:YES];
    [self.popover dismissPopoverAnimated:YES];
    
}

#pragma mark - Button
#pragma mark 点击修改头像
- (IBAction)onPortrartBt:(UIButton *)portraitBt
{
    PictureSelectViewController *pictureVC = [[PictureSelectViewController alloc] initWithNibName:@"PictureSelectViewController" bundle:nil contentVC:self];
    __weak AccountManagerViewController *weakSelf = self;
    [pictureVC setOnComplete:^(UIImage *image){
        //Keyboard
        [weakSelf hideKeyboard];
        //popover dismiss
        [weakSelf.popover dismissPopoverAnimated:NO];
        //设置image
        if (image != nil) {
            [weakSelf.portraitBt setImage:image forState:UIControlStateNormal];
        }
    }];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:pictureVC];
    self.popover.popoverContentSize = kPopoverContentSize;
    self.popover.delegate = self;
    
    CGRect frame = [self.view convertRect:self.portraitBt.frame fromView:self.portraitView];
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


#pragma mark 保存修改
- (IBAction)onSaveBt:(id)sender{

    [DataManager updateUserInfo:self.user callback:^(BOOL success) {
        if (success && self.onComplete != nil) {
            self.onComplete(self.user);
        }
    }];
}
#pragma mark 放弃修改
- (IBAction)onCancelBt:(id)sender
{
    if (self.onComplete!= nil) {
        self.onComplete(nil);
    }
}

- (IBAction)onPasswordBt:(id)sender
{
    UpdatePasswordViewController *updatePasswordVC = [[UpdatePasswordViewController alloc] initWithNibName:@"UpdatePasswordViewController" bundle:nil];
    __weak AccountManagerViewController *weakSelf = self;
    [updatePasswordVC setOnComplete:^(UIImage *image){
        //Keyboard
        [weakSelf hideKeyboard];
        //popover dismiss
        [weakSelf.popover dismissPopoverAnimated:YES];
        //设置image
        if (image != nil) {
            [weakSelf.portraitBt setImage:image forState:UIControlStateNormal];
        }
    }];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:updatePasswordVC];
    self.popover.popoverContentSize = CGSizeMake(400, 300);
    self.popover.delegate = self;
    
    [self.popover presentPopoverFromRect:CGRectMake(0, 0, 753, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark － 进场、退场
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (parent != nil)
    {
        self.view.transform = CGAffineTransformMakeTranslation(0, 768 -kNavBarHeight);
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    [super didMoveToParentViewController:parent];
    if (parent == nil) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 768 -kNavBarHeight);
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    }
    
}

@end
