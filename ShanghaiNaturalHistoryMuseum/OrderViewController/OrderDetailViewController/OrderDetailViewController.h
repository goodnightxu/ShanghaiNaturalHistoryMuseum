//
//  OrderDetailViewController.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-28.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"

@interface OrderDetailViewController : UIViewController

@property(nonatomic,assign)NSInteger originalIndex;
@property(nonatomic,strong)NSMutableArray *detailDataArray;
@property (nonatomic, strong) void (^didOrderSuccess)(void);
@property (nonatomic, strong) void (^showInMap)(InfoItem *item);


-(void)reloadCurrentUI;

@end
