//
//  RightTableView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "RightTableView.h"
#import "OrderItem.h"

@implementation RightTableView

@synthesize rightDataArray;
@synthesize delegate1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate=self;
        self.dataSource=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor clearColor];
    
        
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 159.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return rightDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderItem *item=(OrderItem *)[rightDataArray objectAtIndex:indexPath.row];
    
    
    static NSString *identifier = @"RightTableViewCell";
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.tag=indexPath.row;
        cell.delegate=self;
    }
    
    cell.nameLabel.text=item.name;

    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
    NSString *s=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
    cell.startTimeString=[NSString stringWithFormat:@"%@ %@:00",s,item.beginTime];
    NSArray *myArray1=[[[cell.startTimeString componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
    cell.startTimeLabel.text=[cell.startTimeLabel.text stringByReplacingOccurrencesOfString:@"%%" withString:[myArray1 objectAtIndex:0]];
    cell.startTimeLabel.text=[cell.startTimeLabel.text stringByReplacingOccurrencesOfString:@"##" withString:[myArray1 objectAtIndex:1]];
    cell.startTimeLabel.hidden=NO;
    
    NSDate *startDate=[dateFormatter dateFromString:cell.startTimeString];
    NSTimeInterval timeInterval=[startDate timeIntervalSinceNow];
    
    int hour=(int)timeInterval/3600;
    int minute=(int)(timeInterval-hour*3600)/60;
    int second=timeInterval-hour*3600-minute*60;
    [cell.hourNumberView setValue:hour animated:YES];
    [cell.minNumberView setValue:minute animated:YES];
    [cell.secNumberView setValue:second animated:YES];
    
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([delegate1 respondsToSelector:@selector(didSelectRightTable:atIndexPath:)]) {
        [delegate1 didSelectRightTable:self atIndexPath:indexPath];
    }
}


#pragma RightTableViewCellDelegate
-(void)eventDidStartForIndexPath:(NSIndexPath *)indexPath {
    if (rightDataArray.count>indexPath.row) {
        [rightDataArray removeObjectAtIndex:indexPath.row];
        [self reloadData];
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
