//
//  MenuList.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/28.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItem : NSObject

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *title;

@end

@interface MenuList : UITableViewController

@property (nonatomic, strong) NSArray *datas;

///Event
@property (nonatomic, strong) void (^selectedMenu)(MenuItem *menuItem);

@end
