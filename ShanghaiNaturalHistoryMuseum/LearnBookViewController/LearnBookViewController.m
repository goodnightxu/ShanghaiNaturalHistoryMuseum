//
//  LearnBookViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-29.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LearnBookViewController.h"
#import "LineMatchView.h"


@interface LearnBookViewController () {
    IBOutlet UIView *question1View;
    IBOutlet UIButton *buttonA;
    IBOutlet UIButton *buttonB;
    IBOutlet UIButton *buttonC;
    IBOutlet UIButton *buttonD;
    IBOutlet UIView *wrongView;
    IBOutlet UIView *rightView;
    IBOutlet UIView *infoView1;
    
    
    IBOutlet UIView *question2View;
    LineMatchView *mactchView;
}

@end

@implementation LearnBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    
    mactchView=[[LineMatchView alloc] initWithFrame:question2View.bounds];
    [question2View addSubview:mactchView];
    
    
    
    infoView1.hidden=YES;
    
    [buttonA setImage:[UIImage imageNamed:@"learnbook_un_a.png"] forState:UIControlStateNormal];
    [buttonA setImage:[UIImage imageNamed:@"learnbook_se_a.png"] forState:UIControlStateSelected];
    [buttonB setImage:[UIImage imageNamed:@"learnbook_un_b.png"] forState:UIControlStateNormal];
    [buttonB setImage:[UIImage imageNamed:@"learnbook_se_b.png"] forState:UIControlStateSelected];
    [buttonC setImage:[UIImage imageNamed:@"learnbook_un_c.png"] forState:UIControlStateNormal];
    [buttonC setImage:[UIImage imageNamed:@"learnbook_se_c.png"] forState:UIControlStateSelected];
    [buttonD setImage:[UIImage imageNamed:@"learnbook_un_d.png"] forState:UIControlStateNormal];
    [buttonD setImage:[UIImage imageNamed:@"learnbook_se_d.png"] forState:UIControlStateSelected];
}

-(IBAction)clickedBtn:(UIButton *)sender {
    if (sender.tag==5) {
        infoView1.hidden=NO;
        [UIView animateWithDuration:0.25f animations:^{
            infoView1.frame=CGRectMake(0, 0, 1024, 658);
        }];
    } else if (sender.tag==6) {
        [UIView animateWithDuration:0.25f animations:^{
            infoView1.frame=CGRectMake(-1024, 0, 1024, 658);
        } completion:^(BOOL finished) {
            infoView1.hidden=YES;
        }];
    }
    else {
        buttonA.selected=NO;
        buttonB.selected=NO;
        buttonC.selected=NO;
        buttonD.selected=NO;
        sender.selected=YES;
        if (sender.tag==1) {
            rightView.hidden=NO;
            wrongView.hidden=YES;
        } else {
            rightView.hidden=YES;
            wrongView.hidden=NO;
        }
    }
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:mactchView];
    [mactchView beginTouch:point];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *pointArray=[touches allObjects];
    CGPoint point=[pointArray[0] locationInView:mactchView];
    [mactchView moveTouch:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch=[touches anyObject];
    CGPoint point=[touch locationInView:mactchView];
    [mactchView endTouch:point];
}





#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = nil;
    nav.subBottomTitle = nil;
    
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}
- (void)onMenuBt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
