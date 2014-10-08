//
//  VisualSearchViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/2.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoItem;

@interface VisualSearchViewController : UIViewController <UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *tips;

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIScrollView *searchSV;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UITableView *tipTableView;
///没有找到提示
@property (nonatomic, weak) IBOutlet UIView *noFoundView;
///结果显示

@property (nonatomic, strong) void (^onLocate)(InfoItem *infoItem);

- (IBAction)onSearchBt:(id)sender;
- (IBAction)onSearchKeyChange:(id)sender;


@end
