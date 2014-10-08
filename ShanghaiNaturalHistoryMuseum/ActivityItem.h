//
//  ActivityItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoItem.h"

typedef enum
{
    //教室
    ActivityItemClassroom = 1,
     //展区
    ActivityItemShowroom = 2,
} ActivityItemAddressType;

@interface ActivityItem : NSObject

///活动ID
@property (nonatomic, strong) NSNumber *sid;
///活动名称
@property (nonatomic, strong) NSString *name;
///标题图
@property (nonatomic, strong) NSString *titlePic;
///内容
@property (nonatomic, strong) NSString *contents;
///浏览次数
@property (nonatomic, strong) NSNumber *browseNum;


///详细
@property (nonatomic, strong) NSNumber *scheduleId;
@property (nonatomic, strong) NSString *address;
///活动地点类型
@property (nonatomic, assign) ActivityItemAddressType addressType;
///活动日期
@property (nonatomic, strong) NSDate *activityDate;
///活动开始日期
@property (nonatomic, strong) NSString *beginTime;
///活动结束日期
@property (nonatomic, strong) NSString *endTime;
///受众类型
@property (nonatomic, strong) NSNumber *personType;
///预约最大数量
@property (nonatomic, strong) NSNumber *maxBookNum;
///已预约数
@property (nonatomic, strong) NSNumber *bookNum;
///预约码
@property (nonatomic, strong) NSNumber *bookCode;
///预约日期
@property (nonatomic, strong) NSDate *bookDate;
///是否检票
@property (nonatomic, assign) BOOL check;
///预约ID
@property (nonatomic, strong) NSNumber *bookId;
///关联id
@property (nonatomic, strong) NSNumber *cId;
///信息点类型
@property (nonatomic, assign) InfoType infoItemType;
///活动图片集
@property (nonatomic, strong) NSArray *pics;






@end
