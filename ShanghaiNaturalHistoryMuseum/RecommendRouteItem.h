//
//  RecommendRouteItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendRouteItem : NSObject

@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *introduction;
///由InfoItem 构成
@property (nonatomic, strong) NSArray *routesRooms;

@end
