//
//  EventTableViewCell.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface EventTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)DetailTextView *contentLabel;
@property(nonatomic,strong)DetailTextView *filmTimeLabel;
@property(nonatomic,strong)NSArray *tagsArray;
@property(nonatomic,strong)UILabel *peopleLabel;
@property(nonatomic,strong)UIScrollView *tagScrollView;

@end
