//
//  GameDetailViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/16.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskButton;

@interface GameDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) TaskButton *taskButton;
//Event
@property (nonatomic, strong) void (^onStart)(TaskButton *taskBt);
@property (nonatomic, strong) void (^onClose)();


- (IBAction)onStartBt:(id)sender;
- (IBAction)onCloseBt:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil taskButton:(TaskButton *)taskButton;

@end
