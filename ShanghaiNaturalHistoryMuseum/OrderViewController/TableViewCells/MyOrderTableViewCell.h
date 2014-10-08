//
//  MyOrderTableViewCell.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface MyOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)DetailTextView *orderCodeLabel;
@property(nonatomic,strong)DetailTextView *timeLabel;
@property(nonatomic,strong)DetailTextView *peopleLabel;
@property(nonatomic,strong)UIImageView *statusImageView;
@property(nonatomic,strong)UIButton *mapButton;
@property(nonatomic,strong)void (^clickMap)(void);


@end
