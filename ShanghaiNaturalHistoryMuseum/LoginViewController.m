//
//  LoginViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "User.h"
#import "PictureSelectViewController.h"

#define kHUDOffset -170

#pragma mark - UIImageViewPicker


@implementation UIImagePickerController(Private)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end

#pragma mark - LoginViewController
@interface LoginViewController ()
{
    User *_user;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    //UI
    [self initializeUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //Keyboard
    [self addKeyboard];
    //
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.sv setContentSize:CGSizeMake(0, self.sv.bounds.size.height+1)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initializeUI
{
    //默认自动登录
    self.checkBt.selected = YES;
    [self.checkBt setImage:[UIImage imageNamed:@"checkedBox.png"] forState:UIControlStateNormal];
    
    //头像
    self.portraitBt.layer.cornerRadius = self.portraitBt.bounds.size.width * 0.5f;
    self.portraitBt.clipsToBounds = YES;
    self.portraitBt.imageView.contentMode = UIViewContentModeScaleAspectFill;

}

#pragma mark - Button
- (IBAction)onLoginBt:(id)sender
{
    NSString *message = nil;
    if (self.userTextField.text == nil || [self.userTextField.text isEqualToString:@""]) {
        message = @"请输入用户名";
    }
    
    if (self.passwordTextField.text == nil || [self.passwordTextField.text isEqualToString:@""]) {
        message = @"请输入密码";
    }
    
    if (message != nil) {
#warning AutoLayout 会造成hud不能正常使用
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        if (self.sv.contentOffset.y > 5 || self.sv.contentOffset.y <-5 ) {
            hud.yOffset =  kHUDOffset;
        }
        [hud show:YES];
        
        [hud removeFromSuperViewOnHide];
        [hud hide:YES afterDelay:1.5];
        
        return;
    }
    
    [self hideKeyboard];
    
    _user = [[User alloc] init];
    _user.account = self.userTextField.text;
    _user.pwd = self.passwordTextField.text;
    _user.isAutoLogin = self.checkBt.selected;
    
    __weak LoginViewController *weakSelf = self;
    [DataManager loginWithUser:_user callback:^(User *user, BOOL success) {
        ///登入成功
        if (success && weakSelf.onLoginSuccess != nil) {
            //
            weakSelf.onLoginSuccess(user);
            //
            [self hideKeyboard];
        }
    }];
    
}

- (IBAction)onForgetBt:(id)sender
{

}

- (IBAction)onAutoLoginBt:(id)sender
{
    self.checkBt.selected = !self.checkBt.selected;
    
    if (self.checkBt.selected) {
        [self.checkBt setImage:[UIImage imageNamed:@"checkedBox.png"] forState:UIControlStateNormal];
    }else{
        [self.checkBt setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    }

}

- (IBAction)onRegistBt:(id)sender
{
    [self switchLoginToRegist];
}

#pragma mark 注册提交
- (IBAction)onSubmitBt:(id)sender
{
    NSString *message = nil;
    if (self.userTextField.text == nil||[self.userTextField.text isEqualToString:@""]) {
        message = @"请输入用户名";
    }
    if (self.passwordTextField.text == nil||[self.passwordTextField.text isEqualToString:@""]) {
        message = @"请输入密码";
    }
    if (![self.passwordTextField.text isEqualToString:self.p2TextField.text]){
        message = @"两次输入密码不一致";
    }
    if (self.nickNameTextField.text == nil||[self.nickNameTextField.text isEqualToString:@""]) {
        message = @"请输入昵称";
    }
    if (self.emailTextField.text == nil||[self.emailTextField.text isEqualToString:@""]) {
        message = @"请输入Email";
    }else if (![self confirmEmail:self.emailTextField.text]) {
        message= @"请输入有效的Email";
    }
    if (self.mobileTextField.text == nil || [self.mobileTextField.text isEqualToString:@""]) {
        message = @"请输入手机号码";
    }else if (![self confirmMobile:self.mobileTextField.text]){
        message = @"请输入有效手机号码";
    }
    
    if (message != nil) {
#warning AutoLayout 会造成hud不能正常使用
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        if (self.sv.contentOffset.y > 5 || self.sv.contentOffset.y <-5 ) {
             hud.yOffset =  kHUDOffset;
        }
        
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        
        return;
    }
    
    User *user = [[User alloc] init];
    user.account = self.userTextField.text;
    user.pwd = self.passwordTextField.text;
    user.portraitImage = self.portraitBt.imageView.image;
    user.nickname = self.nickNameTextField.text;
    user.mail = self.emailTextField.text;
    user.mobile = self.mobileTextField.text;
    //默认
    user.isAutoLogin = YES;
    
    [self hideKeyboard];
    
    
    __weak LoginViewController *weakSelf = self;
    [DataManager registWithUser:user callback:^(BOOL success) {
        if (success) {
            //
            [DataManager loginWithUser:user callback:^(User *user, BOOL success) {
                if (success) {
                    weakSelf.onLoginSuccess(user);
                }
            }];
        }
    }];
}

- (IBAction)onCancelBt:(id)sender
{
    [self switchRegistToLogin];
}

#pragma mark - 上传头像
- (IBAction)onPortraitBt:(UIButton *)portraitBt{

    if (self.popover == nil) {
        PictureSelectViewController *pictureSelectVC = [[PictureSelectViewController alloc] initWithNibName:@"PictureSelectViewController" bundle:nil contentVC:self];
        __weak LoginViewController *weakSelf = self;
        
        [pictureSelectVC setOnComplete:^(UIImage *image){
            //popover dismiss
            [weakSelf.popover dismissPopoverAnimated:NO];
            //设置image
            if (image != nil) {
                [weakSelf.portraitBt setImage:image forState:UIControlStateNormal];
            }
        }];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:pictureSelectVC];
        self.popover.delegate = self;
    }
    
    self.popover.popoverContentSize = kPopoverContentSize;
    CGRect frame = [self.contentView convertRect:portraitBt.frame toView:self.view];
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}



#pragma mark - Keyboard
- (void)addKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)hideKeyboard
{
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.p2TextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];

}


- (void)onKeyboardShow:(NSNotification *)notification
{
    [self.sv setContentOffset:CGPointMake(0, 208) animated:YES];
    if (self.viewState == RegistState) {
        [self.sv setContentInset:UIEdgeInsetsMake(0, 0, 360, 0)];
    }else{
        [self.sv setContentInset:UIEdgeInsetsMake(0, 0, 216, 0)];
    }
    
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    //[self.sv setContentInset:UIEdgeInsetsZero];
    [self.sv setContentOffset:CGPointZero animated:YES];
    [self performSelector:@selector(cleanSVInsert) withObject:nil afterDelay:0.3];
}

- (void)cleanSVInsert
{
    [self.sv setContentInset:UIEdgeInsetsZero];
}

#pragma mark - 进场 退场
//进场
- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if (parent != nil) {
        CGFloat aniDur = 0;
        if (self.animated) {
            aniDur = 0.25;
        }
        self.view.transform = CGAffineTransformMakeTranslation(0, 768 - kNavBarHeight);
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:aniDur animations:^{
            
            self.view.transform = CGAffineTransformIdentity;
            [self.view layoutIfNeeded];
        }];

    };
}

//退场
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (parent == nil) {
        CGFloat aniDur = 0;
        if (self.animated) {
            aniDur = 0.25;
        }
        [UIView animateWithDuration:aniDur animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 768 - kNavBarHeight);;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)showLoginView
{
    
}

#pragma mark - 切换到注册
#define kOffset1 650
- (void)switchLoginToRegist
{
    [self hideKeyboard];
    //-----------------------------------------
    //按钮退场
    self.forgetBt.transform = CGAffineTransformIdentity;
    [self.forgetBt layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.forgetBt.transform = CGAffineTransformMakeTranslation(kOffset1, 0);
        self.forgetBt.alpha = 0.0;
        [self.forgetBt layoutIfNeeded];
    } completion:nil];
    
    self.checkBt.transform = CGAffineTransformIdentity;
    [self.checkBt layoutIfNeeded];
    self.checkLabel.transform = CGAffineTransformIdentity;
    [self.checkLabel layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.checkBt.transform = CGAffineTransformMakeTranslation(-kOffset1, 0);
        self.checkBt.alpha = 0.0;
        [self.checkBt layoutIfNeeded];
        self.checkLabel.transform  = CGAffineTransformMakeTranslation(-kOffset1, 0);
        self.checkLabel.alpha = 0.0;
        [self.checkLabel layoutIfNeeded];
    } completion:nil];
    
    self.loginBt.transform = CGAffineTransformIdentity;
    [self.loginBt layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loginBt.transform = CGAffineTransformMakeTranslation(kOffset1, 0);
        self.loginBt.alpha = 0.0;
        [self.loginBt layoutIfNeeded];
    } completion:nil];
    
    self.registBt.transform = CGAffineTransformIdentity;
    [self.registBt layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.registBt.transform = CGAffineTransformMakeTranslation(-kOffset1, 0);
        self.registBt.alpha = 0.0;
        [self.registBt layoutIfNeeded];
    } completion:^(BOOL finished) {
        //-----------------------------------------
        //按钮进场
        self.portraitBt.transform = CGAffineTransformMakeTranslation(0, -200);
        self.portraitBt.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.portraitBt.transform = CGAffineTransformIdentity;
            self.portraitBt.alpha = 1.0;
            [self.portraitBt layoutIfNeeded];
        } completion:nil];
        
        self.portraitLabel.transform = CGAffineTransformMakeTranslation(0, -200);
        self.portraitLabel.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.portraitLabel.transform = CGAffineTransformIdentity;
            self.portraitLabel.alpha = 1.0;
            [self.portraitLabel layoutIfNeeded];
        } completion:nil];
        
        self.p2.transform = CGAffineTransformMakeTranslation(0, 300);
        self.p2.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.p2.transform = CGAffineTransformIdentity;
            self.p2.alpha = 1.0;
            [self.p2 layoutIfNeeded];
        } completion:nil];

        
        self.nickView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.nickView.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.nickView.transform = CGAffineTransformIdentity;
            self.nickView.alpha = 1.0;
            [self.nickView layoutIfNeeded];
        } completion:nil];
        
        self.emailView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.emailView.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.emailView.transform = CGAffineTransformIdentity;
            self.emailView.alpha = 1.0;
            [self.emailView layoutIfNeeded];
        } completion:nil];
        
        self.mobileView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.mobileView.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.mobileView.transform = CGAffineTransformIdentity;
            self.mobileView.alpha = 1.0;
            [self.mobileView layoutIfNeeded];
        } completion:nil];
        
        self.submitBt.transform = CGAffineTransformMakeTranslation(0, 300);
        self.submitBt.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.submitBt.transform = CGAffineTransformIdentity;
            self.submitBt.alpha = 1.0;
            [self.submitBt layoutIfNeeded];
        } completion:nil];
        
        self.cancelBt.transform = CGAffineTransformMakeTranslation(0, 300);
        self.cancelBt.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.45 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.cancelBt.transform = CGAffineTransformIdentity;
            self.cancelBt.alpha = 1.0;
            [self.cancelBt layoutIfNeeded];
        } completion:nil];
        
        
        self.viewState = RegistState;
    }];
}


#pragma mark - 切换到登录
- (void)switchRegistToLogin
{
    [self hideKeyboard];
    //按钮退场
    [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.portraitBt.transform = CGAffineTransformMakeTranslation(0, -200);
        self.portraitBt.alpha = 0.0;
        [self.portraitBt layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.portraitLabel.transform = CGAffineTransformMakeTranslation(0, -200);
        self.portraitLabel.alpha = 0.0;
        [self.portraitLabel layoutIfNeeded];
    } completion:nil];
    
    
    [UIView animateWithDuration:0.25 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.p2.transform = CGAffineTransformMakeTranslation(0, 300);
        self.p2.alpha = 0.0;
        [self.p2 layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.nickView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.nickView.alpha = 0.0;
        [self.nickView layoutIfNeeded];
    } completion:nil];
    

    [UIView animateWithDuration:0.25 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.emailView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.emailView.alpha = 0.0;
        [self.emailView layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mobileView.transform = CGAffineTransformMakeTranslation(0, 300);
        self.mobileView.alpha = 0.0;
        [self.mobileView layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.submitBt.transform = CGAffineTransformMakeTranslation(0, 300);
        self.submitBt.alpha = 0.0;
        [self.submitBt layoutIfNeeded];
    } completion:nil];

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cancelBt.transform = CGAffineTransformMakeTranslation(0, 300);
        self.cancelBt.alpha = 0.0;
        [self.cancelBt layoutIfNeeded];
    } completion:^(BOOL finished) {
        //按钮进场


        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.forgetBt.transform = CGAffineTransformIdentity;
            self.forgetBt.alpha = 1.0;
            [self.forgetBt layoutIfNeeded];
        } completion:nil];
        

        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.checkBt.transform = CGAffineTransformIdentity;
            self.checkBt.alpha = 1.0;
            [self.checkBt layoutIfNeeded];
            self.checkLabel.transform  = CGAffineTransformIdentity;
            self.checkLabel.alpha = 1.0;
            [self.checkLabel layoutIfNeeded];
        } completion:nil];
        

        [UIView animateWithDuration:0.25 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.loginBt.transform = CGAffineTransformIdentity;
            self.loginBt.alpha = 1.0;
            [self.loginBt layoutIfNeeded];
        } completion:nil];
        

        [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.registBt.transform = CGAffineTransformIdentity;
            self.registBt.alpha = 1.0;
            [self.registBt layoutIfNeeded];
        } completion:nil];
        
        self.viewState = LoginState;
    }];
}


#pragma mark - 验证手机、eMail
- (BOOL)confirmMobile:(NSString *)mobile
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(1(([35][0-9])|(47)|[8][01236789]))\\d{8}$" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:mobile options:0 range:NSMakeRange(0, mobile.length)];
    if (matches.count == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)confirmEmail:(NSString *)email
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:email options:0 range:NSMakeRange(0, email.length)];
    if (matches.count == 0) {
        return NO;
    }
    return YES;
}


@end
