//
//  SearchRouteTableView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-5.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoItem;

@protocol SearchRouteTableViewDelegate <NSObject>

-(void)didSelectPlaceWithTableView:(UITableView *)tableView infoItem:(InfoItem *)item;

@end



@interface SearchRouteTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *dataArray;//这里是Infoitem
@property(nonatomic,weak)id<SearchRouteTableViewDelegate>delegate1;


@end
