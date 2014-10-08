//
//  MyVisitRouteView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-18.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ShakeAndDeleteView.h"
#import "VisitRouteTableView.h"
@class MyVisitRouteView;

@protocol MyVisitRouteViewDelegate <NSObject>

-(void)willShowRouteForData:(NSArray *)dataArray routeView:(MyVisitRouteView *)routeView;

@end


@interface MyVisitRouteView : ShakeAndDeleteView {
    VisitRouteTableView *routeTableView;
    NSArray *visitRouteDataArray;
    UIView *backView;
}

@property(nonatomic,weak)id<MyVisitRouteViewDelegate> delegate1;
@property(nonatomic,copy,readonly)NSString *title;
- (id)initWithFrame:(CGRect)frame withHeaderName:(NSString *)headerName data:(NSArray *)dataArray;


@end
