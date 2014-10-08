//
//  ExhibitItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/26.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ExhibitRelationDistant,
    ExhibitRelationNeighbour,
} ExhibitRelation;

@interface ExhibitItem : NSObject

@property (nonatomic, strong) NSNumber *sid;
///展品名称
@property (nonatomic, strong) NSString *name;
///标题图片
@property (nonatomic, strong) NSString *iconPath;
///编号
@property (nonatomic, strong) NSString *code;
///拉丁文名
@property (nonatomic, strong) NSString *latinName;
///英文名
@property (nonatomic, strong) NSString *englishName;
///中文俗名
@property (nonatomic, strong) NSString *popularName;
///年代
@property (nonatomic, strong) NSString *age;
///产地
@property (nonatomic, strong) NSString *gathering;
///展品描述
@property (nonatomic, strong) NSString *summary;
///展项名称
@property (nonatomic, strong) NSString *tName;
///标本背后故事id
@property (nonatomic, strong) NSNumber *sepicmenId;
///关联展示区域id
@property (nonatomic, strong) NSNumber *relationRegionId;
///于指定展品关系（远亲，近邻）
@property (nonatomic, assign) ExhibitRelation relation;
///展品图片
@property (nonatomic, strong) NSArray *pics;

@end
