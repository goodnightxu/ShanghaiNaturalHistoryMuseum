//
//  OrderHeaderView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-25.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "OrderHeaderView.h"
#import "DataManager.h"
#import "PublicMethod.h"

@implementation OrderHeaderView {
//    UILabel *right_big_Label;
//    UILabel *right_small_Label;
}

@synthesize eventCount;
@synthesize eventDataArray;
@synthesize delegate;
@synthesize eventBtn;
@synthesize movieBtn;
@synthesize myOrderBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=ORDERVIEW_THEME_GREEN_COLOR;
        
        movieBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        movieBtn.frame=CGRectMake(64, 35, 80, 25);
        [movieBtn setBackgroundColor:[UIColor clearColor]];
        [movieBtn setTitle:@"电影" forState:UIControlStateNormal];
        [movieBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [movieBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        movieBtn.titleLabel.font=[UIFont fontWithName:LanTingHei size:20.0f];
        movieBtn.tag=1;
        movieBtn.hidden=YES;
        [movieBtn addTarget:self
                     action:@selector(didClickButton:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:movieBtn];
        
        myOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        myOrderBtn.frame=CGRectMake(370, 35, 80, 25);
        [myOrderBtn setBackgroundColor:[UIColor clearColor]];
        [myOrderBtn setTitle:@"我的预约" forState:UIControlStateNormal];
        [myOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myOrderBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        myOrderBtn.titleLabel.font=[UIFont fontWithName:LanTingHei size:20.0f];
        myOrderBtn.tag=2;
        myOrderBtn.hidden=YES;
        myOrderBtn.selected=YES;
        [myOrderBtn addTarget:self
                     action:@selector(didClickButton:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:myOrderBtn];
                
//        right_big_Label = [[UILabel alloc]initWithFrame:CGRectMake(468, 0, 200, self.bounds.size.height)];
//        right_big_Label.textColor=[UIColor whiteColor];
//        right_big_Label.textAlignment=NSTextAlignmentRight;
//        right_big_Label.backgroundColor=[UIColor clearColor];
//        right_big_Label.font=[UIFont fontWithName:LanTingHei size:36.0f];
//        right_big_Label.text=@"0";
//        right_big_Label.hidden=YES;
//        [self addSubview:right_big_Label];
//        
//        right_small_Label = [[UILabel alloc]initWithFrame:CGRectMake(518, 0, 200, self.bounds.size.height)];
//        right_small_Label.textColor=[UIColor whiteColor];
//        right_small_Label.textAlignment=NSTextAlignmentRight;
//        right_small_Label.backgroundColor=[UIColor clearColor];
//        right_small_Label.font=[UIFont fontWithName:LanTingHei size:16.0f];
//        right_small_Label.hidden=YES;
//        [self addSubview:right_small_Label];
        
    }
    return self;
}


-(void)setEventDataArray:(NSArray *)_eventDataArray {
    eventBtn=[[PopoverButton alloc] initWithFrame:CGRectMake(190, 23, 120, 48) withTitle:@"教育活动" withData:_eventDataArray];
    eventBtn.selectedItem=[_eventDataArray objectAtIndex:0];
    eventBtn.delegate=self;
    eventBtn.selected=YES;
    [self addSubview:eventBtn];
    
    movieBtn.hidden=NO;
    myOrderBtn.hidden=NO;
}


-(void) setEventCount:(NSInteger)_eventCount {
//    right_big_Label.text=[NSString stringWithFormat:@"%i",_eventCount];
//    NSString *labelText=@"共找到";
//    for (int i=0; i<right_big_Label.text.length; i++) {
//        labelText=[NSString stringWithFormat:@"%@      ",labelText];
//    }
//    labelText=[NSString stringWithFormat:@"%@个活动",labelText];
//    right_small_Label.text=labelText;
//    
//    right_big_Label.hidden=NO;
//    right_small_Label.hidden=NO;

}

-(void)didClickButton:(UIButton *)sender {//button.tag,1为电影，2为我的预约
    switch (sender.tag) {
        case 1:
            movieBtn.selected=NO;
            myOrderBtn.selected=YES;
            eventBtn.selected=YES;
            if ([delegate respondsToSelector:@selector(didSelectHeaderViewForItem:)]) {
                [delegate didSelectHeaderViewForItem:@"movie"];
            }
            break;
        case 2:
            if (![DataManager getUser]) {
                [PublicMethod HUDOnlyLabelForView:self.superview
                                      withMessage:@"请先在系统管理处登录"];
                return;
            }
            eventBtn.selected=YES;
            movieBtn.selected=YES;
            myOrderBtn.selected=NO;
            if ([delegate respondsToSelector:@selector(didSelectHeaderViewForItem:)]) {
                [delegate didSelectHeaderViewForItem:@"myOrder"];
            }
            break;
        default:
            break;
    }
    
    
}

#pragma PopoverButtonDelegate
-(void)didSelectPopoverButtonForItem:(NSString *)item {
    eventBtn.selected=NO;
    movieBtn.selected=YES;
    myOrderBtn.selected=YES;
    
    if ([delegate respondsToSelector:@selector(didSelectHeaderViewForItem:)]) {
        [delegate didSelectHeaderViewForItem:item];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
