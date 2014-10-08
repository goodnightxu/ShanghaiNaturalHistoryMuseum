//
//  GameDetailViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/16.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameViewController.h"
#import "GameTaskItem.h"
#import "GameThemeItem.h"
#import "DataManager.h"

@interface GameDetailViewController ()

@end

@implementation GameDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil taskButton:(TaskButton *)taskButton
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.taskButton = taskButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Icon
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width * 0.5;
    self.iconImageView.layer.borderColor = kColorGreen1.CGColor;
    self.iconImageView.layer.borderWidth = 4.0f;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.alpha = 0.95f;
    
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.iconImageView.bounds.size.width *1.2, self.iconImageView.bounds.size.height * 1.2)];
    blurImageView.image = self.taskButton.blurImage;
    
    [self.iconImageView addSubview:blurImageView];
    blurImageView.center = viewCenter(self.iconImageView.bounds);
    
    
    //Detail
    self.bgView.layer.cornerRadius = 10;
    self.detailLabel.text = self.taskButton.taskItem.prompt;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button
- (void)onStartBt:(id)sender
{
    if (self.onStart != nil) {
        self.onStart(self.taskButton);
    }
}

- (void)onCloseBt:(id)sender
{
    if (self.onClose != nil) {
        self.onClose();
    }
}

@end
