//
//  UpdatePasswordViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "DataManager.h"
#import "User.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button
- (IBAction)onUpdatePasswordBt:(id)sender
{
    
    NSString *message = nil;
    
    
    if (self.oldTextField.text == nil || [self.oldTextField.text isEqualToString:@""]) {
        message = @"请输入当前密码";
    }
    
    if (self.password1TextField.text == nil || [self.password1TextField.text isEqualToString:@""]) {
        message = @"请输入新密码";
    }
    
    if (![self.password1TextField.text isEqualToString:self.password2TextField.text]) {
        message = @"两次输入密码不一致";
    }
    
    if (message != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];

    }else
    {
        User *user = [DataManager getUser];
        user.pwd = self.oldTextField.text;
        [DataManager changePasswordWithUser:user newPassword:self.password1TextField.text callback:^(BOOL success) {
            if (success) {
                self.onComplete();
            }
        }];
    }
}

@end
