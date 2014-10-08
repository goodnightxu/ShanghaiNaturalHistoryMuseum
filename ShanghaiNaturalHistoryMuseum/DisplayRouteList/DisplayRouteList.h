//
//  DisplayRouteList.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoItem;

@interface DisplayRouteList : UITableViewController

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) void (^selectedRoute)(InfoItem *item);


@end
