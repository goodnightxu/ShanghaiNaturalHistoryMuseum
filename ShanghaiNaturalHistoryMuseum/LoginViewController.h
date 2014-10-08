//
//  LoginViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

typedef enum
{
    LoginState,
    RegistState
    
} ViewState;
@interface LoginViewController : UIViewController <UIPopoverControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *sv;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIButton *portraitBt;
@property (nonatomic, weak) IBOutlet UILabel *portraitLabel;

@property (nonatomic, weak) IBOutlet UIView *userView;
@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UIView *passwordView;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIView *p2;
@property (nonatomic, weak) IBOutlet UITextField *p2TextField;
@property (nonatomic, weak) IBOutlet UIView *nickView;
@property (nonatomic, weak) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, weak) IBOutlet UIView *emailView;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UIView *mobileView;
@property (nonatomic, weak) IBOutlet UITextField *mobileTextField;

@property (nonatomic, weak) IBOutlet UIButton *checkBt;
@property (nonatomic, weak) IBOutlet UILabel *checkLabel;
@property (nonatomic, weak) IBOutlet UIButton *forgetBt;
@property (nonatomic, weak) IBOutlet UIButton *loginBt;
@property (nonatomic, weak) IBOutlet UIButton *registBt;
@property (nonatomic, weak) IBOutlet UIButton *submitBt;
@property (nonatomic, weak) IBOutlet UIButton *cancelBt;

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, assign) ViewState viewState;

@property (nonatomic, assign) BOOL animated;

- (IBAction)onLoginBt:(id)sender;
- (IBAction)onRegistBt:(id)sender;
- (IBAction)onForgetBt:(id)sender;
- (IBAction)onSubmitBt:(id)sender;
- (IBAction)onCancelBt:(id)sender;

//Event
@property (nonatomic, strong) void (^onLoginSuccess)(User *user);

@end
