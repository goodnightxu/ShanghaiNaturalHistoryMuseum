//
//  VisitRouteTableViewCell.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-17.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "VisitRouteTableViewCell.h"

@implementation VisitRouteTableViewCell

@synthesize iconImageView;
@synthesize titleLabel;
@synthesize likedCount;
@synthesize likeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *verticalImageView=[[UIImageView alloc] initWithFrame:CGRectMake(51, 0, 7, 58)];
        verticalImageView.image=[UIImage imageNamed:@"route_vertivcal_line.png"];
        [self.contentView addSubview:verticalImageView];
        
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 44, 44)];
        iconImageView.backgroundColor=[UIColor clearColor];
        iconImageView.layer.cornerRadius=iconImageView.frame.size.width/2.0;
        iconImageView.layer.masksToBounds=YES;
        iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
        [self.contentView addSubview:iconImageView];
        
        UIImageView *maskImageView=[[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 44, 44)];
        maskImageView.image=[UIImage imageNamed:@"route_mask.png"];
        [self.contentView addSubview:maskImageView];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 8, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont fontWithName:LanTingHei size:14.0f];
        [self.contentView addSubview:titleLabel];
        
        
        likeView=[[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, 35, 77, 22)];
        
        UIImageView *likeBackImageView=[[UIImageView alloc] initWithFrame:likeView.bounds];
        likeBackImageView.image=[UIImage imageNamed:@"route_like_back.png"];
        likeBackImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [likeView addSubview:likeBackImageView];
        
        UIImageView *loveImageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 12)];
        loveImageView.image=[UIImage imageNamed:@"route_like_icon"];
        [likeView addSubview:loveImageView];
        
        likeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, likeView.frame.size.width-8, likeView.frame.size.height)];
        likeLabel.backgroundColor=[UIColor clearColor];
        likeLabel.text=@"0人点赞";
        likeLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        likeLabel.textAlignment=NSTextAlignmentRight;
        likeLabel.font=[UIFont fontWithName:LanTingHei size:9.0f];
        likeLabel.textColor=[UIColor whiteColor];
        [likeView addSubview:likeLabel];
        
        [self.contentView addSubview:likeView];
        
        
        
    }
    return self;
}


-(void)setLikedCount:(NSString *)_likedCount {
    likedCount=_likedCount;
    
    NSInteger length=_likedCount.length<3 ? 3 : _likedCount.length;
    
    CGRect rect1=likeView.frame;
    rect1.size.width=rect1.size.width + rect1.size.width*(length-3)/15.0;
    likeView.frame=rect1;
    
    likeLabel.text=[NSString stringWithFormat:@"%@人赞",_likedCount];
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
