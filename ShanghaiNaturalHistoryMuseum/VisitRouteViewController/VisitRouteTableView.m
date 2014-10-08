//
//  VisitRouteTableView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-9.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "VisitRouteTableView.h"
#import "VisitRouteTableViewCell.h"
#import "InfoItem.h"
#import "DataManager.h"

@implementation VisitRouteTableView

@synthesize tableDataArray;

- (id)initWithFrame:(CGRect)frame withHeaderName:(NSString *)headerName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellZoomAnimationDuration=@0.75f;
        self.showsVerticalScrollIndicator=NO;
        self.delegate=self;
        self.dataSource=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor clearColor];
        
        
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , 64)];
        headerView.backgroundColor=[UIColor clearColor];
        
        UIImageView *headerIconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 28, 64)];
        headerIconImageView.image=[UIImage imageNamed:@"route_header_icon.png"];
        headerIconImageView.backgroundColor=[UIColor clearColor];
        [headerView addSubview:headerIconImageView];
        
        UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, headerView.frame.size.width-90, headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        headerLabel.numberOfLines = 2;
        headerLabel.textColor=[UIColor darkGrayColor];
        headerLabel.text=headerName;
        title=headerName;
        headerLabel.font=[UIFont fontWithName:LanTingHei size:24.0f];
        
        [headerView addSubview:headerLabel];
        self.tableHeaderView=headerView;
        

    }
    return self;
}


#pragma UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return tableDataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==tableDataArray.count) {
        static NSString *identifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *footerIconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 28, 47)];
            footerIconImageView.image=[UIImage imageNamed:@"route_footer_icon.png"];
            [cell.contentView addSubview:footerIconImageView];
        }
        
        return cell;
    } else {
        static NSString *identifier = @"VisitRouteTableViewCell";
        VisitRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[VisitRouteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if ([title rangeOfString:@"最热门"].length<=0) {
            cell.likeView.hidden=YES;
        } else {
            cell.likeView.hidden=NO;
        }
        InfoItem *item=(InfoItem *)[tableDataArray objectAtIndex:indexPath.row];
        cell.likedCount=[NSString stringWithFormat:@"%@",item.praise];
        cell.titleLabel.text=item.title;
        cell.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
        [DataManager loadPicWithPath:item.iconPath
                              inView:cell.iconImageView
                            callback:^(UIImage *image, BOOL userCache, BOOL success) {
                                if (success && image) {
                                    cell.iconImageView.image=image;
                                }
                            }];
        
        
        return  cell;
    }
    
}


#pragma UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.showsVerticalScrollIndicator=YES;
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
