//
//  DisplayRouteList.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "DisplayRouteList.h"
#import "InfoItem.h"

static NSString *reuseId = @"DisplayRouteList";


@interface DisplayRouteList ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DisplayRouteList

@synthesize datas;


- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 154)];
    headerView.backgroundColor=[UIColor clearColor];
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(32, 57, 180, 30)];
    label1.font=[UIFont fontWithName:LanTingHei size:24.0f];
    label1.textColor=[UIColor blackColor];
    label1.backgroundColor=[UIColor clearColor];
    label1.text=@"路线详情";
    [headerView addSubview:label1];
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(32, 97, 180, 30)];
    label2.font=[UIFont fontWithName:LanTingHei size:14.0f];
    label2.textColor=[UIColor lightGrayColor];
    label2.backgroundColor=[UIColor clearColor];
    label2.text=@"该路线已显示于左侧地图。";
    [headerView addSubview:label2];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.clipsToBounds = NO;
    CGSize size = [Help viewSize:self.tableView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bg.layer.shadowColor = [UIColor blackColor].CGColor;
    bg.layer.shadowOpacity = 0.05f;
    bg.layer.shadowOffset = CGSizeMake(-3, 0);
    self.tableView.backgroundView = bg;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, size.height)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [bg addSubview:bottomLine];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor=VISITROUTE_THEME_ORANGE_COLOR;

    //添加分割线
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 49, 220-45, 1)];
    separatorLine.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
    [cell.contentView addSubview:separatorLine];

    
    InfoItem *item=(InfoItem *)[datas objectAtIndex:indexPath.row];
    cell.textLabel.text=item.title;
    cell.textLabel.font=[UIFont fontWithName:LanTingHei size:14.0f];
    if (datas.count==1) {
        cell.textLabel.textColor=[UIColor blackColor];
    } else {
        if (indexPath.row==0) {
            cell.textLabel.textColor=[UIColor blackColor];
            cell.imageView.image=[UIImage imageNamed:@"display_route_up.png"];
        } else if (indexPath.row==datas.count-1) {
            cell.textLabel.textColor=VISITROUTE_THEME_ORANGE_COLOR;
            cell.imageView.image=[UIImage imageNamed:@"display_route_bottom.png"];
        } else {
            cell.textLabel.textColor=[UIColor grayColor];
            cell.imageView.image=[UIImage imageNamed:@"display_route_middle.png"];
        }
    }
    

    
    return cell;
}


#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    InfoItem *item=(InfoItem *)[datas objectAtIndex:indexPath.row];
//    self.selectedRoute(item);
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
