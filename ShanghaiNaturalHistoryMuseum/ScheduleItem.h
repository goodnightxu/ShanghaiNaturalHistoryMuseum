//
//  ScheduleItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 9/11/14.
//  Copyright (c) 2014 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"
#import "InfoItem.h"

@interface ScheduleItem : NSObject

///安排id
@property (nonatomic, strong) NSNumber *sid;
///开始时间，场次
@property (nonatomic, strong) NSString *beginTime;
///地址id，信息点关联实体id
@property (nonatomic, strong) NSNumber *cid;
///信息点类型
@property (nonatomic, assign) PreorderType preoderType;
///信息点类型
@property (nonatomic, assign) InfoType infoItemType;
///地址
@property (nonatomic, strong) NSString *address;
///已预约人数
@property (nonatomic, strong) NSNumber *bookNum;
///预约号
@property (nonatomic, strong) NSNumber *bookCode;

@end
