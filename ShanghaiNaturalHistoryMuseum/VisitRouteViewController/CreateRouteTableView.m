//
//  CreateRouteTableView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-3.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "CreateRouteTableView.h"
#import "CreateRouteTableViewCell.h"
#import "PublicMethod.h"


@implementation CreateRouteTableView {
    UITextField *lastTextField;
}

@synthesize dataArray;
@synthesize delegate1;
@synthesize needAddInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.dataSource=self;
        self.showsVerticalScrollIndicator=YES;

        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor clearColor];
        
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
    static NSString *identifier = @"CreateRouteTableViewCell";
    CreateRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CreateRouteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.nameTextField.delegate=self;
        [cell.nameTextField addTarget:self
                               action:@selector(textFieldDidInput:)
                     forControlEvents:UIControlEventEditingChanged];
        [cell.addButton addTarget:self
                           action:@selector(didClickAddButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteButton addTarget:self
                           action:@selector(didClickDeleteButton:)
                 forControlEvents:UIControlEventTouchUpInside];
       
    }
    cell.addButton.tag=indexPath.row;
    cell.deleteButton.tag=indexPath.row;
    cell.nameTextField.tag=indexPath.row-1;
    InfoItem *item=[dataArray objectAtIndex:indexPath.row];
    
    
    if (self.tag==0) {
        if (indexPath.row==0) {
            cell.backgroundColor=[UIColor blackColor];
            cell.iconImageView.image=[UIImage imageNamed:@"route_point_down.png"];
            cell.nameTextField.text=@"开始位置";
            cell.nameTextField.enabled=NO;
            cell.addButton.hidden=YES;
            cell.deleteButton.hidden=YES;
            
        } else if (indexPath.row==dataArray.count-1) {
            
            if ([[(InfoItem *)[dataArray lastObject] title] isEqualToString:@"last"]) {
                cell.backgroundColor=VISITROUTE_THEME_ORANGE_COLOR;
                cell.iconImageView.image=[UIImage imageNamed:@"route_point_up.png"];
                cell.nameTextField.text=@"";
                cell.nameTextField.enabled=YES;
                cell.deleteButton.hidden=YES;
                //            cell.addButton.hidden=NO;
                cell.addButton.hidden=YES;
                lastTextField=cell.nameTextField;
            } else {
                cell.backgroundColor=[UIColor lightGrayColor];
                cell.iconImageView.image=[UIImage imageNamed:@"route_point_up.png"];
                cell.nameTextField.text=item.title;
                cell.nameTextField.enabled=NO;
                cell.deleteButton.hidden=NO;
                cell.addButton.hidden=YES;
            }
        } else {
            cell.backgroundColor=[UIColor lightGrayColor];
            cell.iconImageView.image=[UIImage imageNamed:@"route_point_full.png"];
            cell.nameTextField.text=item.title;
            cell.nameTextField.enabled=NO;
            cell.deleteButton.hidden=NO;
            cell.addButton.hidden=YES;
        }
    } else {
        if (indexPath.row==0) {
            cell.backgroundColor=[UIColor blackColor];
            cell.iconImageView.image=[UIImage imageNamed:@"route_point_down.png"];
            if (dataArray.count==1) {
                cell.iconImageView.image=[UIImage imageNamed:@"route_point_alone.png"];
            }
            cell.nameTextField.text=@"开始位置";
            cell.nameTextField.enabled=NO;
            cell.addButton.hidden=YES;
            cell.deleteButton.hidden=YES;
            
        }  else {
            cell.backgroundColor=[UIColor lightGrayColor];
            cell.iconImageView.image=[UIImage imageNamed:@"route_point_full.png"];
            if (indexPath.row==dataArray.count-1) {
                cell.iconImageView.image=[UIImage imageNamed:@"route_point_up.png"];
            }
            cell.nameTextField.text=item.title;
            cell.nameTextField.enabled=NO;
            cell.deleteButton.hidden=NO;
            cell.addButton.hidden=YES;
        }
    }
   
    
    
    return  cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [dataArray removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
    } else {
        if (self.tag==0) {
            [dataArray insertObject:needAddInfo atIndex:dataArray.count-1];
        } else {
            [dataArray addObject:needAddInfo];
        }
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
        
    }
    [self performSelector:@selector(reloadTableView)
               withObject:nil
               afterDelay:0.25f];
}

-(void)reloadTableView {
    if (dataArray.count==12) {
        [dataArray removeLastObject];
    } else {
        if (![[(InfoItem *)[dataArray lastObject] title] isEqualToString:@"last"] && self.tag==0) {
            InfoItem *infoLast=[[InfoItem alloc] init];
            infoLast.title=@"last";
            [dataArray addObject:infoLast];
        }
    }

    
    [self reloadData];
    
}


#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([delegate1 respondsToSelector:@selector(nameTextFieldDidBeginEditing:)]) {
        [delegate1 nameTextFieldDidBeginEditing:textField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([delegate1 respondsToSelector:@selector(nameTextFieldDidEndEditing:)]) {
        [delegate1 nameTextFieldDidEndEditing:textField];
    }
}
-(void)textFieldDidInput:(UITextField *)textField {
//    needAddInfo=lastTextField.text;
    if ([delegate1 respondsToSelector:@selector(nameTextFieldDidInput:)]) {
        [delegate1 nameTextFieldDidInput:textField];
    }
}




-(void)didClickAddButton:(UIButton *)sender {
    if (lastTextField.text.length<=0) {
        [PublicMethod HUDOnlyLabelForView:self.superview.superview withMessage:@"请先输入目的地"];
    } else {
        [self tableView:self
     commitEditingStyle:UITableViewCellEditingStyleInsert
      forRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    }
    
}
-(void)didClickDeleteButton:(UIButton *)sender {
    [self tableView:self
 commitEditingStyle:UITableViewCellEditingStyleDelete
  forRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
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
