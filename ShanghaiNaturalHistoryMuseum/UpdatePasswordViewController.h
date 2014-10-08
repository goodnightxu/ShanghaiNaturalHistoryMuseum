//
//  UpdatePasswordViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *oldTextField;
@property (nonatomic, strong) IBOutlet UITextField *password1TextField;
@property (nonatomic, strong) IBOutlet UITextField *password2TextField;

///
@property (nonatomic, strong) void (^onComplete)();

- (IBAction)onUpdatePasswordBt:(id)sender;

@end
