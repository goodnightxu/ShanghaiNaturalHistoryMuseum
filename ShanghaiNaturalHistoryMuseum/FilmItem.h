//
//  FilmItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoItem.h"

typedef enum
{
    FilmType3D,
    FilmType4D,
} FilmType;

@interface FilmItem : NSObject

///影片id
@property (nonatomic, strong) NSNumber *sid;
///影片名称
@property (nonatomic, strong) NSString *name;
///标题图
@property (nonatomic, strong) NSString *titlePic;
///片长
@property (nonatomic, strong) NSString *playTime;
///影片介绍
@property (nonatomic, strong) NSString *introduction;
///浏览次数, 没有浏览 ＝ 0
@property (nonatomic, strong) NSNumber *browseNum;

///详细相关
///排片id
@property (nonatomic, strong) NSNumber *scheduleId;
///影片类型 3D 4D
@property (nonatomic, assign) FilmType filmType;
///开始日期
@property (nonatomic, strong) NSDate *beginTime;
///结束日期
@property (nonatomic, strong) NSDate *endTime;
///播放开始时间
@property (nonatomic, strong) NSString *playBeginTime;
///场次
@property (nonatomic, strong) NSNumber *screenings;
///放映地点
@property (nonatomic, strong) NSString *address;
///最大预约数
@property (nonatomic, strong) NSNumber *maxBookNum;
///已预约数, 没有预约 ＝ 0
@property (nonatomic, strong) NSNumber *bookNum;
///预约码, 没有码 ＝ nil
@property (nonatomic, strong) NSNumber *bookCode;
///预约日期
@property (nonatomic, strong) NSDate *bookDate;
///是否检票
@property (nonatomic, assign) BOOL check;
///预约ID, 没有id = nil
@property (nonatomic, strong) NSNumber *bookId;
///关联实体id
@property (nonatomic, strong) NSNumber *cId;
///关联实体类型
@property (nonatomic, assign) InfoType infoItemType;

@end
