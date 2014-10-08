//
//  EventTableViewCell.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize titleLabel;
@synthesize iconImageView;
@synthesize filmTimeLabel;
@synthesize tagsArray;
@synthesize contentLabel;
@synthesize peopleLabel;
@synthesize tagScrollView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 751-50, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = ORDERVIEW_THEME_GREEN_COLOR;
        titleLabel.font = [UIFont fontWithName:LanTingHei size:24.0f];
        [self.contentView addSubview:titleLabel];
        
        contentLabel = [[DetailTextView alloc] initWithFrame:CGRectMake(190, 60, 751-190, 25)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.showShadow=@"NO";
        [self.contentView addSubview:contentLabel];
        
        
        filmTimeLabel = [[DetailTextView alloc] initWithFrame:CGRectMake(190, 90, 751-190, 25)];
        filmTimeLabel.backgroundColor=[UIColor clearColor];
        filmTimeLabel.showShadow=@"NO";
        [self.contentView addSubview:filmTimeLabel];
        
        tagScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(190, 90, 751-190, 25)];
        tagScrollView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:tagScrollView];
 
        UIView *downBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 120, 751, 172-120-3)];
        downBackView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0f];
        [self.contentView addSubview:downBackView];
        
        peopleLabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 0, downBackView.frame.size.width, downBackView.frame.size.height)];
        peopleLabel.textColor=[UIColor grayColor];
        peopleLabel.backgroundColor=[UIColor clearColor];
        peopleLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
        [downBackView addSubview:peopleLabel];
        
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 58, 120, 85)];
        iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
        iconImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:iconImageView];
        
    
        //添加分割线
        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, 751, 3)];
        separatorLine.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0f];
        [self.contentView addSubview:separatorLine];
    }
    return self;
}

-(void)setTagsArray:(NSArray *)_tagsArray {
    for (int i=0; i<_tagsArray.count; i++) {
        UILabel *tagLabel=[[UILabel alloc] initWithFrame:CGRectMake(90*i, 0, 73, 25)];
        tagLabel.backgroundColor=[UIColor colorWithRed:241.0f/255.0 green:241.0f/255.0 blue:241.0f/255.0 alpha:1.0f];;
        tagLabel.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        tagLabel.font=[UIFont fontWithName:LanTingHei size:12.0f];
        tagLabel.textAlignment=NSTextAlignmentCenter;
        tagLabel.text=[_tagsArray objectAtIndex:i];
        [tagScrollView addSubview:tagLabel];
        if (i+1==_tagsArray.count) {
            tagScrollView.contentSize=CGSizeMake(tagLabel.frame.size.width+tagLabel.frame.origin.x, tagScrollView.frame.size.height);
        }
    }
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
