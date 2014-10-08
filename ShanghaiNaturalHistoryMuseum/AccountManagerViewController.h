//
//  AccountManagerViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface AccountManagerViewController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate>

///UI
@property (nonatomic, weak) IBOutlet UIScrollView *sv;
@property (nonatomic, weak) IBOutlet UILabel *accountLabel;
@property (nonatomic, weak) IBOutlet UIView *portraitView;
@property (nonatomic, weak) IBOutlet UIButton *portraitBt;
@property (nonatomic, weak) IBOutlet UIView *nickView;
@property (nonatomic, weak) IBOutlet UITextField *nickTextField;
@property (nonatomic, weak) IBOutlet UIView *emailView;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UIView *mobileView;
@property (nonatomic, weak) IBOutlet UITextField *mobilTextField;

@property (nonatomic, strong) UIPopoverController *popover;

///Data
@property (nonatomic, strong) User *user;

///Event
@property (nonatomic, strong) void (^onComplete)(User *updatedUser);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(User *)user;

- (IBAction)onPasswordBt:(id)sender;
- (IBAction)onPortrartBt:(id)sender;
- (IBAction)onCancelBt:(id)sender;
- (IBAction)onSaveBt:(id)sender;

@end
