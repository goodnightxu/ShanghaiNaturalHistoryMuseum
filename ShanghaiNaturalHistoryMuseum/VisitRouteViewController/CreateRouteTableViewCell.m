//
//  CreateRouteTableViewCell.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-3.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "CreateRouteTableViewCell.h"

@implementation CreateRouteTableViewCell

@synthesize iconImageView;
@synthesize nameTextField;
@synthesize addButton;
@synthesize deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 15, 50)];
        iconImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:iconImageView];
        
        nameTextField=[[UITextField alloc] initWithFrame:CGRectMake(45, 10, 160, 29)];
        nameTextField.borderStyle=UITextBorderStyleNone;
        nameTextField.textColor=[UIColor whiteColor];
        UIColor *whiteColor = [UIColor whiteColor];
        nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"下一个目标" attributes:@{NSForegroundColorAttributeName:whiteColor}];
        nameTextField.font=[UIFont fontWithName:LanTingHei size:18.0f];
        [self.contentView addSubview:nameTextField];
        
        addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectMake(210, 9, 32, 32);
        [addButton setImage:[UIImage imageNamed:@"route_add_btn.png"] forState:UIControlStateNormal];
        addButton.hidden=YES;
        [self.contentView addSubview:addButton];
        
        deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame=CGRectMake(210, 9, 32, 32);
        [deleteButton setImage:[UIImage imageNamed:@"route_delete_btn.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:deleteButton];
        
        //添加分割线
        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 257, 1)];
        separatorLine.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0f];
        [self.contentView addSubview:separatorLine];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
