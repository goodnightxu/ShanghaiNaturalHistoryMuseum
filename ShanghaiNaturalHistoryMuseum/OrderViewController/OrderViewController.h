//
//  OrderViewController.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-22.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"

@interface OrderViewController : UIViewController

@property (nonatomic, strong) void (^showInMap)(InfoItem *item);


@end
