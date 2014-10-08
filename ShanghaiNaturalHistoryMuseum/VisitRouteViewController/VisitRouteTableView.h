//
//  VisitRouteTableView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-9.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ZoomTableView.h"

@interface VisitRouteTableView : ZoomTableView<UITableViewDataSource,UITableViewDelegate> {
    NSString *title;
}


@property(nonatomic,strong)NSArray *tableDataArray;
- (id)initWithFrame:(CGRect)frame withHeaderName:(NSString *)headerName;

@end
