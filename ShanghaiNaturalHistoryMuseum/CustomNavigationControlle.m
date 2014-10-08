//
//  CustomNavigationControllerViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "CustomNavigationController.h"
#import <FRDLivelyButton.h>

#define kBottomLineHeight 1

@interface CustomNavigationController ()
{
    UIView *_navBarView;
    
    UILabel *_subTopTitleLabel;
    UILabel *_subBottomTitleLabel;
}
@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Status Bar
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //nav
    self.navigationBarHidden = YES;
    
    [self initializeNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeNavBar
{
    //Logo 和 背景
    [self initiailzeBgAndLogo];
    
    //KVO
    [self addObserver:self forKeyPath:@"barButton" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"subTopTitle" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"subBottomTitle" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)initiailzeBgAndLogo
{
    if (_navBarView.superview != nil) {
        return;
    }
    //添加自定义Bar
    //CGSize size = self.view.bounds.size;
    CGSize size = CGSizeMake(1024, 768);
    CGSize barSize = CGSizeMake(size.width, kNavBarHeight);
    
    
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barSize.width, barSize.height)];
    _navBarView.autoresizingMask = UIViewAutoresizingNone;
    _navBarView.backgroundColor = [UIColor whiteColor];
    _navBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    _navBarView.layer.shadowOpacity = 0.05f;
    _navBarView.layer.shadowOffset = CGSizeMake(0, 3);
    
    //下划线
    CGSize lineSize = CGSizeMake(size.width, kBottomLineHeight);
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, barSize.height - lineSize.height, lineSize.width, lineSize.height)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [_navBarView addSubview:bottomLine];
    
    //Logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    CGRect logoFrame = CGRectMake(25, 30, 0, 0);
    logo.frame = logoFrame;
    [logo sizeToFit];
    [_navBarView addSubview:logo];
    
    [self.view addSubview:_navBarView];

}

- (void)initializeSubUpTitleWithString:(NSString *)title
{
    if (_subTopTitleLabel == nil) {
        _subTopTitleLabel = [[UILabel alloc] init];
        [_navBarView addSubview:_subTopTitleLabel];
    }
    
    
    //切换动画
    UILabel *tempLabel = [[UILabel alloc] init];

    if (![title isEqual:[NSNull null]] && title.length >= 2) {
        //首字符navSubTitleAttribute1， 剩余字符使用navSubTitleAttribute2
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedString setAttributes:[Help navSubTitleAttribute1] range:NSMakeRange(0, 1)];
        [attributedString setAttributes:[Help navSubTitleAttribute2] range:NSMakeRange(1, self.subTopTitle.length -1)];
        tempLabel.attributedText = attributedString;
    }
    
    
    //位置 最右侧位于912，上边16
    tempLabel.frame = CGRectZero;
    [tempLabel sizeToFit];
    CGRect subTitleFrame = tempLabel.frame;
    tempLabel.frame = CGRectOffset(subTitleFrame, 910-subTitleFrame.size.width, 14);
    [_navBarView addSubview:tempLabel];
    
    tempLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        tempLabel.alpha = 1.0f;
        _subTopTitleLabel.alpha =0.0f;
    }completion:^(BOOL finished) {
        _subTopTitleLabel.attributedText = tempLabel.attributedText;
        _subTopTitleLabel.frame = tempLabel.frame;
        _subTopTitleLabel.alpha = 1.0f;
        [tempLabel removeFromSuperview];
    }];
    
    
}


- (void)initializeSubBottomTitleWithString:(NSString *)title
{
    if (_subBottomTitleLabel == nil) {
        _subBottomTitleLabel = [[UILabel alloc] init];
        [_navBarView addSubview:_subBottomTitleLabel];
    }
    
    //切换动画
    UILabel *tempLabel = [[UILabel alloc] init];
    
    if (![title isEqual:[NSNull null]]) {
        tempLabel.text = title;

    }
    
   
    //Font Color
    tempLabel.Font = [UIFont fontWithName:@"STHeitiTC-Medium" size:22.0f];
    tempLabel.textColor = [UIColor blackColor];
    
    //位置 最右侧位于900，上边75
    tempLabel.frame = CGRectZero;
    [tempLabel sizeToFit];
    CGRect subTitleFrame = tempLabel.frame;
    tempLabel.frame = CGRectOffset(subTitleFrame, 900-subTitleFrame.size.width, 75);
    tempLabel.alpha = 0.0f;
    [_navBarView addSubview:tempLabel];
    
    [UIView animateWithDuration:0.25 animations:^{
        tempLabel.alpha = 1.0f;
        _subBottomTitleLabel.alpha = 0.0f;
    }completion:^(BOOL finished) {
        _subBottomTitleLabel.text = tempLabel.text;
        _subBottomTitleLabel.font = tempLabel.font;
        _subBottomTitleLabel.textColor = tempLabel.textColor;
        _subBottomTitleLabel.frame = tempLabel.frame;
        _subBottomTitleLabel.alpha = 1.0f;
        
        [tempLabel removeFromSuperview];
    }];
}

- (void)initializeBarButton
{
    if (self.barButton.superview != nil) {
        return;
    }
    
    //居中

    //[_navBarView addSubview:self.barButton];
    
}

#warning ？？？？好像没用
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //BarButton
    if ([keyPath isEqualToString:@"barButton"]) {
        
        FRDLivelyButton *newBt = change[@"new"];
        newBt.frame = CGRectMake(0, 0, 44, 44);
        newBt.center = CGPointMake(965, 44+22);
        [_navBarView addSubview:newBt];
        
        kFRDLivelyButtonStyle buttonStyle = newBt.buttonStyle;
        if ([change[@"old"] isKindOfClass:[FRDLivelyButton class]]) {
            FRDLivelyButton *oldBt = change[@"old"];
            [oldBt removeFromSuperview];
            
            [newBt setStyle:oldBt.buttonStyle animated:NO];
        }
        [newBt setStyle:buttonStyle animated:YES];
        
    }
    
    
    //Title
    if ([keyPath isEqualToString:@"subTopTitle"]) {

        NSString *newString = change[@"new"];
        [self initializeSubUpTitleWithString:newString];
    }
    
    if ([keyPath isEqualToString:@"subBottomTitle"]) {
        
        NSString *newString = change[@"new"];
        [self initializeSubBottomTitleWithString:newString];
    }
}

#pragma mark - 方向支持(UIImagePickerView)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
