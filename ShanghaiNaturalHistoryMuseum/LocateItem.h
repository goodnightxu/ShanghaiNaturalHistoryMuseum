//
//  LocateItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/26.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface LocateItem : NSObject

@property (nonatomic, assign) CGPoint pt;
@property (nonatomic, assign) BOOL isIn;
@property (nonatomic, assign) FloorType floorType;
@property (nonatomic, assign) NSInteger areaID;
@property (nonatomic, strong) NSString *ip;

@end
