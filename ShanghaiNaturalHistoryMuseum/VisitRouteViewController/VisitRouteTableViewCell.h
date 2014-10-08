//
//  VisitRouteTableViewCell.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-17.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitRouteTableViewCell : UITableViewCell {
    UILabel *likeLabel;
}

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,copy)NSString *likedCount;
@property(nonatomic,strong)UIView *likeView;

@end
