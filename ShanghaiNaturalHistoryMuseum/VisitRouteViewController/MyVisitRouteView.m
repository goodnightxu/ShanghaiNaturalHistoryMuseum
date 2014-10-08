//
//  MyVisitRouteView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-18.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "MyVisitRouteView.h"
#import "VisitRouteTableViewCell.h"


@implementation MyVisitRouteView

@synthesize delegate1;
@synthesize title;

- (id)initWithFrame:(CGRect)frame withHeaderName:(NSString *)headerName data:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    if (self) {
        title=headerName;
        
        backView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width-18, self.frame.size.height-10)];
        backView.layer.borderColor=VISITROUTE_THEME_ORANGE_COLOR.CGColor;
        backView.layer.cornerRadius=10.0f;
        backView.layer.masksToBounds=YES;
        backView.backgroundColor=[UIColor clearColor];
        backView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backView];
        
        VisitRouteTableView *tableView=[[VisitRouteTableView alloc] initWithFrame:CGRectMake(0, 10, backView.frame.size.width, backView.frame.size.height-60-20) withHeaderName:headerName];
        tableView.tableDataArray=[NSArray arrayWithArray:dataArray];
        visitRouteDataArray=[NSArray arrayWithArray:dataArray];
        tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backView addSubview:tableView];
        
        CGRect rect=self.deleteButton.frame;
        self.deleteButton.frame=CGRectMake(rect.origin.x-10, rect.origin.y, rect.size.width, rect.size.height);
        
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, tableView.frame.origin.y+tableView.frame.size.height, backView.frame.size.width, 60)];
        bottomView.backgroundColor=[UIColor clearColor];
        bottomView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [backView addSubview:bottomView];
        
        UIButton *showRouteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        showRouteBtn.frame=CGRectMake(35, 15, bottomView.frame.size.width-70, 45);
        [showRouteBtn setTitle:@"显示线路" forState:UIControlStateNormal];
        [showRouteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [showRouteBtn setBackgroundColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f]];
        showRouteBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [showRouteBtn addTarget:self
                         action:@selector(clickedBtn:)
               forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:showRouteBtn];
    }
    return self;
}

-(void)clickedBtn:(UIButton *)sender {
    if ([delegate1 respondsToSelector:@selector(willShowRouteForData:routeView:)]) {
        [delegate1 willShowRouteForData:visitRouteDataArray routeView:self];
    }
}


-(void)startShake {
    [super startShake];
    
    if (self.canShake) {
        backView.layer.borderWidth=4.0f;

        //长按一个，其余都停止shake
        UIView *superView=self.superview;
        for (int i=0; i<superView.subviews.count; i++) {
            MyVisitRouteView *routeView=[superView.subviews objectAtIndex:i];
            if ([routeView isKindOfClass:[MyVisitRouteView class]]) {
                if (!routeView.isShaking && routeView.canShake) {
                    [routeView startShake];
                }
            }
        }
    }
}
-(void)stopShake {
    [super stopShake];
    backView.layer.borderWidth=0.0f;
  
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
