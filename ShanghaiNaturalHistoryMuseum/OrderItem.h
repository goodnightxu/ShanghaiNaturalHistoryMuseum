//
//  OrderItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PreorderType
{
    PreorderFilm,
    PreorderActivity,
    PreorderOther,
} PreorderType;

@interface OrderItem : NSObject

///预约id
@property (nonatomic, strong) NSNumber *sid;
///活动安排或排片id
@property (nonatomic, strong) NSNumber *scheduleId;
///分类
@property (nonatomic, assign) PreorderType preorderType;
///临展电影或教育活动ID
@property (nonatomic, strong) NSNumber *cid;
///临展电影或教育活动名称
@property (nonatomic, strong) NSString *name;
///地址
@property (nonatomic, strong) NSString *address;
///预约日期
@property (nonatomic, strong) NSDate *bookDate;
///预约码
@property (nonatomic, strong) NSNumber *bookCode;
///预约人数
@property (nonatomic, strong) NSNumber *bookNum;
///开始时间, 场次
@property (nonatomic, strong) NSString *beginTime;
///是否检票
@property (nonatomic, assign) BOOL check;


///位置
@property (nonatomic, assign) CGPoint pt;
@end
