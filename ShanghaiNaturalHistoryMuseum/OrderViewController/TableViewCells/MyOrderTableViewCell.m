//
//  MyOrderTableViewCell.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

@synthesize titleLabel;
@synthesize iconImageView;
@synthesize orderCodeLabel;
@synthesize timeLabel;
@synthesize peopleLabel;
@synthesize statusImageView;
@synthesize mapButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 751-50, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = ORDERVIEW_THEME_GREEN_COLOR;
        titleLabel.font = [UIFont fontWithName:LanTingHei size:24.0f];
        [self.contentView addSubview:titleLabel];
        
        orderCodeLabel = [[DetailTextView alloc] initWithFrame:CGRectMake(190, 60, 751-190, 25)];
        orderCodeLabel.backgroundColor=[UIColor clearColor];
        orderCodeLabel.showShadow=@"NO";
        [self.contentView addSubview:orderCodeLabel];
        
        timeLabel = [[DetailTextView alloc] initWithFrame:CGRectMake(190, 90, 751-190, 25)];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.showShadow=@"NO";
        [self.contentView addSubview:timeLabel];
        
        peopleLabel = [[DetailTextView alloc] initWithFrame:CGRectMake(190, 120, 751-190, 25)];
        peopleLabel.backgroundColor=[UIColor clearColor];
        peopleLabel.showShadow=@"NO";
        [self.contentView addSubview:peopleLabel];
        
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 58, 120, 85)];
        iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
        iconImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:iconImageView];
        
        mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame=CGRectMake(751-163, 167-45, 163, 45);
        [mapButton setImage:[UIImage imageNamed:@"order_btn_map.png"] forState:UIControlStateNormal];
        [mapButton addTarget:self
                      action:@selector(clickBtn:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:mapButton];
        
        statusImageView=[[UIImageView alloc] initWithFrame:CGRectMake(751-170, 10, 164, 106)];
        statusImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:statusImageView];
        
        
        //添加分割线
        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 165, 751, 3)];
        separatorLine.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0f];
        [self.contentView addSubview:separatorLine];
    }
    return self;
}

-(void)clickBtn:(UIButton *)sender {
    self.clickMap();
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
