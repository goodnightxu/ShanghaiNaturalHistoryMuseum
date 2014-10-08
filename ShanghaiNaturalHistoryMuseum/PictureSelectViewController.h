//
//  PictureSelectViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/19.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPopoverContentSize CGSizeMake(205, 142)

@interface PictureSelectViewController : UIViewController <UIImagePickerControllerDelegate>

//ViewController
@property (nonatomic, weak) UIViewController *contentVC;

//Event
@property (nonatomic, strong) void (^onComplete)();


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentVC:(UIViewController *)contentVC;

- (IBAction)onLocalBt:(id)sender;
- (IBAction)onCameraBt:(id)sender;

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                                        type:(UIImagePickerControllerSourceType)sourceType;

@end
