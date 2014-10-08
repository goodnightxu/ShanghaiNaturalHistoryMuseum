//
//  CustomNavigationControllerViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNavBarHeight 110

@interface CustomNavigationController: UINavigationController

//右侧子标题
@property (nonatomic, strong) NSString *subTopTitle;
//右侧子标题
@property (nonatomic, strong) NSString *subBottomTitle;

//右侧按钮
@property (nonatomic, strong) UIButton *barButton;

@end
