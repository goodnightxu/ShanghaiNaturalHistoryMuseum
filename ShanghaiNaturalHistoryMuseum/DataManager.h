//
//  DataManager.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LXDataManager.h"
@class User;
@class SystemItem;
@class SpecimenItem;
@class InfoItem;
@class RemoteVideoItem;
@class OrderItem;
@class ScheduleItem;
@class ExhibitItem;
@class FilmItem;
@class ActivityItem;
@class GameThemeItem;
@class GameTaskItem;
@class RecommendRouteItem;
#import "CommentItem.h"
#import <GCDAsyncUdpSocket.h>

#pragma mark - Constant
//
#define kUser @"User"

typedef enum
{
    Floor2 = 1,
    Floor1 = 2,
    FloorUnderGround1 = 3,
    FloorUnderGroundInter = 4,
    FloorUnderGround2 = 5,
    
} FloorType;

@interface DataManager : LXDataManager <GCDAsyncUdpSocketDelegate>

#pragma mark - 用户管理
#pragma mark 用户注册
+ (void)registWithUser:(User *)user callback:(void (^)(BOOL success))callback;

#pragma mark 登入
+ (void)loginWithUser:(User *)user callback:(void (^)(User *user, BOOL success))callback;

#pragma mark 获取已登录用户信息
/**获取已登录用户信息
 *没有登录返回nil
 */
+ (User *)getUser;

#pragma mark 修改会员信息
+ (void)updateUserInfo:(User *)user callback:(void (^)(BOOL success))callback;

#pragma mark 修改会员密码
+ (void)changePasswordWithUser:(User *)user newPassword:(NSString *)password callback:(void (^)(BOOL success))callback;


#pragma mark - 系统参数
+ (void)loadSystem:(void (^)(SystemItem *systemItem, BOOL success))callback;

#pragma mark - 可视化搜索
#pragma mark 关键字
+ (void)loadExhibitWithKeyword:(NSString *)keyword showHUD:(BOOL)showHUD inView:(UIView *)view callback:(void (^)(NSArray *exhibits, BOOL success))callback;

#pragma mark 关系
+ (void)loadRelationWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(NSArray *exhibits, BOOL success))callback;

#pragma mark 展品详细信息
+ (void)loadExhibitDetailWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(ExhibitItem *exhibitItem, BOOL success))callback;

#pragma mark 展品位置
+ (void)loadExhibitPositionWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(InfoItem *infoItem, BOOL success))callback;

#pragma mark 标本背后的故事
+ (void)loadSpecimenWithSpecimenId:(NSNumber *)specimenId callback:(void (^)(SpecimenItem *specimenItem, BOOL success))callback;

#pragma mark - 电子地图
#pragma mark 获取楼层信息点信息
+ (void)loadPointInfoWithUser:(User *)user floor:(NSInteger)floor inView:(UIView *)view callback:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark 6.2 获取信息点的地图所在位置
+ (void)loadPointInfoWithInfoItem:(InfoItem *)infoItem callback:(void (^)(InfoItem *infoItem, BOOL success))callback;

#pragma mark 获取信息点展品详细信息
+ (void)loadExhibitDetailWithInfo:(InfoItem *)infoItem callback:(void (^)(ExhibitItem *exhibitItem, BOOL success))callback;

#pragma mark 获取标本背后详细信息
+ (void)loadSpecimenDetailWithInfo:(InfoItem *)infoItem callback:(void (^)(SpecimenItem *specimenItem, BOOL success))callback;

#pragma mark 获取远程视频详细信息
+ (void)loadRemoteVideoWithInfo:(InfoItem *)infoItem callback:(void (^)(RemoteVideoItem *remoteVideoItem, BOOL success))callback;

#pragma mark 信息点点赞
+ (void)postPraiseWithInfoItem:(InfoItem *)infoItem callback:(void (^)(NSInteger praiseNum, BOOL success))callback;

#pragma mark 获取展区信息
+ (void)loadAreas:(void (^)(NSArray *areas, BOOL success))callback;

#pragma mark - 评论
#pragma mark 获取评论
+ (void)loadCommnetsWithUser:(User *)user type:(CommentType)commentType callback:(void (^)(NSArray *comments, BOOL success))callback;

#pragma mark - 预约
#pragma mark 获取受众类型
+ (void)loadPersonTypes:(void (^)(NSDictionary *personDic, BOOL success))callback;

#pragma mark 电影列表
+ (void)loadFilmsWithPersonType:(NSString *)personType user:(User *)user callback:(void (^)(NSArray *films, BOOL success))callback;

//#pragma mark 获取电影预约明细
//+ (void)loadFilmWithFilmItem:(FilmItem *)filmItem callback:(void (^)(FilmItem *filItem, BOOL success))callback;

#pragma mark 活动列表
+ (void)loadActivitesWithPersonType:(NSString *)personType user:(User *)user callback:(void (^)(NSArray *activities, BOOL success))callback;
//#pragma mark 获取活动预约明细
//+ (void)loadActivityWithActivityItem:(ActivityItem *)activityItem callback:(void (^)(ActivityItem *activityItem, BOOL success))callback;

#pragma mark 查询活动或影片安排的信息
+ (void)loadSchedulesWithItem:(NSObject *)item user:(User *)user callback:(void (^)(NSArray *schudules, BOOL success))callback;

#pragma mark 在线预约
+ (void)loadPreorderWithScheduleItem:(ScheduleItem *)scheduleItem user:(User *)user num:(NSNumber *)num callback:(void (^)(NSString *code, BOOL success))callback;

#pragma mark 获取我的预约列表
+ (void)loadAppointmentWithUser:(User *)user callback:(void (^)(NSArray *orders, BOOL success))callback;

#pragma mark 获取电影预约明细
+ (void)loadFilmWithScheduleItem:(ScheduleItem *)scheduleItem user:(User *)user callback:(void (^)(FilmItem *filmItem, BOOL success))callback;

#pragma mark 获取活动预约明细
+ (void)loadActivityWithScheduleItem:(ScheduleItem *)scheduleItem user:(User *)user callback:(void (^)(ActivityItem *activityItem, BOOL success))callback;

#pragma mark 获取信息点的影片或活动信息合集
+ (void)loadOrdersWithFloor:(NSInteger)floorCode callback:(void (^)(NSArray *orders, BOOL success))callback;

#pragma mark 取消预约
+ (void)postCancelWithOrder:(OrderItem *)orderItem user:(User *)user callback:(void (^)(BOOL success))callback;

#pragma mark 记录浏览数
+ (void)postPreorderBrowseCountWithItem:(NSObject *)orderItem callback:(void (^)(BOOL success))callback;

#pragma mark - 参观路线
#pragma mark 根据关键字获取展馆资源
+ (void)loadRouteWithKeyword:(NSString *)keyword callback:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark 获取公共设施列表
///根据用户的所在楼层搜索同一楼层的所有公共设施，并按照用户所在位置与公共设施距离由近到远排序。参数x或y坐标为空的情况下视为点击更多查询其他所有楼层的公共设施，不排序
///pt ＝ CGPointZero, x,y 为空
+ (void)loadFacilityWithFloor:(FloorType)floor point:(CGPoint)pt callback:(void (^)(NSArray *facilities, BOOL success))callback;

#pragma mark 获取推荐路线
+ (void)loadRecommendRoutes:(void (^)(NSArray *routes, BOOL success))callback;

#pragma mark 推荐路线引导点
+ (void)loadInfoItemsWithRecommendRoute:(RecommendRouteItem *)recommendRouteItem callback:(void (^)(NSArray *infos, BOOL successs))callback;

#pragma mark 最热门参观路线
+ (void)loadPraiseRoute:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark 最热门参观引导点
+ (void)loadPraiseRouteInfoItems:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark 用户自定义寻路
+ (void)loadPathWithFloor:(FloorType)floor point:(CGPoint)point targetInfoItem:(InfoItem *)infoItem callback:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark 自定义规化路线
+ (void)loadCustomRouteWithFloor:(FloorType)floor point:(CGPoint)point routes:(NSArray *)infos callback:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark - 寻宝游戏
#pragma mark 查询所有游戏主题
+ (void)loadGameThemesInView:(UIView *)view callback:(void (^)(NSArray *themes, BOOL success))callback;

#pragma mark 游戏任务列表
+ (void)loadGameTasksWithTheme:(GameThemeItem *)themeItem inView:(UIView *)view callback:(void (^)(NSArray *gameTasks, BOOL success))callback;

#pragma mark 游戏任务相关展品的信息点
+ (void)loadExhibitsWithGameTheme:(GameThemeItem *)themeItem callback:(void (^)(NSArray *infos, BOOL success))callback;

#pragma mark Game Check
+ (void)loadCheckWithGameTask:(GameTaskItem *)taskItem user:(User *)user infoItem:(InfoItem *)infoItem callback:(void (^)(BOOL success))callback;

#pragma mark - 图片下载
+ (void)loadPicWithPath:(NSString *)picPath inView:(UIView *)view callback:(void (^)(UIImage *image, BOOL useCache, BOOL success))callback;

#pragma mark - 定位
+ (void)startLocate:(void (^)(NSString *result, BOOL success))callback;
@end
