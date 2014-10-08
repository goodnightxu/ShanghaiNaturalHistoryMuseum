//
//  RightTableView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTableViewCell.h"
@class RightTableView;

@protocol RightTableViewDelegate <NSObject>

-(void)didSelectRightTable:(RightTableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end


@interface RightTableView : UITableView<UITableViewDataSource,UITableViewDelegate,RightTableViewCellDelegate> {
  
}

@property(nonatomic,strong)NSMutableArray *rightDataArray;
@property(nonatomic,weak)id<RightTableViewDelegate>delegate1;

@end
