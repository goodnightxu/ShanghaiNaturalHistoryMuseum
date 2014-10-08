//
//  RightTableViewCell.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JDFlipNumberView.h>


@protocol RightTableViewCellDelegate <NSObject>

-(void)eventDidStartForIndexPath:(NSIndexPath *)indexPath;

@end

@interface RightTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,copy)NSString *startTimeString;
@property(nonatomic,weak)id<RightTableViewCellDelegate>delegate;
@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)JDFlipNumberView *hourNumberView;
@property(nonatomic,strong)JDFlipNumberView *minNumberView;
@property(nonatomic,strong)JDFlipNumberView *secNumberView;

@end
