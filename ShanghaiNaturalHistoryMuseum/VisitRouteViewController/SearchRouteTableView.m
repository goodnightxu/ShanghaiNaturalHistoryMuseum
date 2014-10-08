//
//  SearchRouteTableView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-5.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "SearchRouteTableView.h"
#import "InfoItem.h"

@implementation SearchRouteTableView

@synthesize dataArray;
@synthesize delegate1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator=YES;

        self.delegate=self;
        self.dataSource=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor whiteColor];
        
        
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 253, 102)];
        headerView.backgroundColor=[UIColor whiteColor];
        
        UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(14, headerView.frame.size.height-50, headerView.frame.size.width, 50)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.textColor=VISITROUTE_THEME_ORANGE_COLOR;
        headerLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
        headerLabel.text=@"你是否想找";
        [headerView addSubview:headerLabel];
        
        self.tableHeaderView=headerView;
        
        UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 44)];
        footerView.backgroundColor=[UIColor whiteColor];
        self.tableFooterView=footerView;
        

    }
    return self;
}


#pragma UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SearchRouteTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
        cell.textLabel.textColor=[UIColor grayColor];
        
    }
    
    InfoItem *item=[dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=item.title;

    
    
    return  cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([delegate1 respondsToSelector:@selector(didSelectPlaceWithTableView:infoItem:)]) {
        InfoItem *item=[dataArray objectAtIndex:indexPath.row];
        [delegate1 didSelectPlaceWithTableView:self infoItem:item];
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
