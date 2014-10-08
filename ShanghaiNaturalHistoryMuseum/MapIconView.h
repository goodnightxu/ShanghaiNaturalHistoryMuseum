//
//  MapButton.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/1.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoItem;
@class MapIconView;

/*
typedef enum{
    newTypeSpecimen=8,      //标本背后的故事
    newTypeExhibit,         //展品
    newTypeRemoteVideo,     //远程视屏
    newTypeShowroom,        //展区
    newTypePublic ,         //公共设施
    newTypeClassroom ,      //教室
    newTypeCinema ,         //电影院
    newTypeDisplayRoute ,   //显示的线路上的点
    newTypeCraft,           //寻宝地图
} newType;
 */

typedef enum{
    newTypeSpecimen,        //标本背后的故事
    newTypeExhibit,         //展品
    newTypeRemoteVideo,     //远程视屏
    newTypeShowroom,        //展区
    newTypePublic = 6,      //公共设施
    newTypeClassroom = 5,   //教室
    newTypeCinema = 7 ,     //电影院
    newTypeDisplayRoute ,   //显示的线路上的点
    newTypeCraft,           //寻宝地图
    newTypeAll = 99,        //所有
} newType;



@protocol MapIconViewDelegate <NSObject>

-(void)didTappedMapIconView:(MapIconView *)mapIconView infoItem:(InfoItem *)item;
-(void)willEnglargeMapIconView:(MapIconView *)mapIconView infoItem:(InfoItem *)item;


@end


@interface MapIconView : UIView

@property (nonatomic, strong) InfoItem *infoItem;
@property (nonatomic, assign, readonly) BOOL isEnlarged;
@property (nonatomic, assign, readonly) BOOL canEnglarge;
@property (nonatomic, weak)id<MapIconViewDelegate>delegate;

///
- (id)initWithInfoItem:(InfoItem *)infoItem canEnglarge:(BOOL)flag;
- (id)initWithInfoItem:(InfoItem *)infoItem iconImageName:(NSString *)imageName canEnglarge:(BOOL)flag;
- (void)onCloseBt;
- (void)enlarge;


@end
