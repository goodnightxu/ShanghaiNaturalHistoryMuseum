//
//  DataManagerTest.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "DataManagerTest.h"
#import "DataManager.h"
#import "User.h"
#import "ExhibitItem.h"
#import "InfoItem.h"
#import "FilmItem.h"
#import "ActivityItem.h"
#import "ScheduleItem.h"
#import "GameTaskItem.h"


@interface DataManagerTest ()

@end

@implementation DataManagerTest

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.datas = @[@"Regist user", @"Login", @"Update user info", @"Change password", @"Appointment personTypes", @"Films", @"Activities", @"Preorder", @"My Preorder", @"预约 记录浏览数", @"系统参数", @"可视化搜索 关键字", @"可视化搜索 关系", @"展品详细信息", @"展品背后的故事 标本信息", @"展品所在位置", @"评论列表", @"楼层信息点信息", @"展品详细信息 通过infoItem", @"标本背后的故事 通过infoItem", @"远程视频 详细", @"信息点 点赞", @"展区信息", @"游戏主题", @"活动或影片 安排信息", @"电影明细", @"活动明细", @"信息点的影片或活动合集", @"删除预约", @"游戏任务列表", @"游戏任务相关的展品的信息点", @"游戏检查", @"关键字获取展馆资源", @"公共设施列表", @"获取推荐路线", @"推荐路线引导点", @"最热门参观线路", @"最热门参观引导路点" @"用户自定义寻路"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *message = self.datas[indexPath.row];
 
    cell.textLabel.text = message;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [[User alloc] init];
    user.account = @"BriscTest1";
    user.pwd = @"BriscTest1";
    user.nickname = @"nickname";
    user.mail = @"briscTest1@brisc.net.cn";
    user.mobile = @"13917059633";
    switch (indexPath.row) {
            //Regist
        case 0:
        {
            [DataManager registWithUser:user callback:^(BOOL success) {
                //
            }];
        }
            break;
            
            //Login
        case 1:
        {
            [DataManager loginWithUser:user callback:^(User *user, BOOL success) {
                //
                if (success) {
                    NSLog(@"user: %@", user.sid);
                }
            }];
        }
            break;
            
            //Update user info
        case 2:
        {
            user.mobile = @"13912345678";
            user.mail = @"update@brisc.net.cn";
            [DataManager updateUserInfo:user callback:^(BOOL success) {
                //
            }];
        }
            break;
            //Change password
        case 3:
        {
            NSString *pwd =@"123456";
            [DataManager changePasswordWithUser:user newPassword:pwd callback:^(BOOL success) {
                //
            }];
        }
            break;
            
        case 4:
        {
            [DataManager loadPersonTypes:^(NSDictionary *personDic, BOOL success) {
                {
                    if (success) {
                        NSLog(@"persionDic1: %@", personDic[@"1"]);
                    }
                }
            }];
        }
            break;
            
        case 5:
        {
            [DataManager loadFilmsWithPersonType:nil user:nil callback:^(NSArray *films, BOOL success) {
                //
                NSLog(@"films: %@", films);
            }];
        }
            break;
         
            //活动列表
        case 6:
        {
            [DataManager loadActivitesWithPersonType:@"1" user:nil callback:^(NSArray *activities, BOOL success) {
                NSLog(@"activities:%@", activities);
            }];

        }
            break;
            
            ///Preoder
            case 7:
        {
        
            [DataManager loadPersonTypes:^(NSDictionary *personDic, BOOL success) {
                {
                    if (success) {
                        [DataManager loadFilmsWithPersonType:nil user:nil callback:^(NSArray *films, BOOL success) {
                            //
                            [DataManager loadSchedulesWithItem:films[0] user:nil callback:^(NSArray *schudules, BOOL success) {
                                [DataManager loginWithUser:user callback:^(User *user, BOOL success) {
                                    //
                                    
                                    ScheduleItem *schItem = schudules[2];
            
                                    if (success) {
                                        NSLog(@"user: %@", user.sid);
                                        [DataManager loadPreorderWithScheduleItem:schItem user:user num:@1 callback:^(NSString *code, BOOL success) {
                                            NSLog(@"preorder: %@", code);
                                        }];
                                    }
                                }];
                            }];
                            
                            
                        }];
                    }
                }
            }];
        }
            break;
            
            ///我的预约列表
            case 8:
        {
            
            [DataManager loginWithUser:user callback:^(User *user, BOOL success) {
                //
                if (success) {
                    [DataManager loadAppointmentWithUser:user callback:^(NSArray *result, BOOL success) {
                        //
                        NSLog(@"my appointment: %@", result);
                    }];
                }
                
            }];
            
        }
            break;
            
            ///记录浏览数
        case 9:
        {
            FilmItem *filmItem = [[FilmItem alloc] init];
            filmItem.sid = @4;
            [DataManager  postPreorderBrowseCountWithItem:filmItem callback:^(BOOL success) {
                //
                NSLog(@"recorder browseCount: %@", success?@"YES":@"NO");
            }];
        }
            break;
            
            ///系统参数
        case 10:
        {
            [DataManager loadSystem:^(SystemItem *systemItem, BOOL success) {
                
                NSLog(@"systemItem: %@", systemItem);
            }];
        }
            break;
            
            ///可视化搜索 关键词
        case 11:
        {
            [DataManager loadExhibitWithKeyword:@"1" showHUD:YES inView:nil callback:^(NSArray *exhibits, BOOL success) {
                NSLog(@"exhibits: %@", exhibits);
            }];
        }
            break;
            
            ///可视化搜索 关系
        case 12:
        {
            ExhibitItem *exhibitItem = [[ExhibitItem alloc] init];
            exhibitItem.sid = @22;
            [DataManager loadRelationWithExhibit:exhibitItem callback:^(NSArray *exhibits, BOOL success) {
                NSLog(@"exhibits: %@", exhibits);
            }];
        }
            break;
            
            ///展品详细信息
        case 13:
        {
            ExhibitItem *exhibitItem = [[ExhibitItem alloc] init];
            exhibitItem.sid = @23;
            [DataManager loadExhibitDetailWithExhibit:exhibitItem callback:^(ExhibitItem *exhibitItem, BOOL success) {
                //
                NSLog(@"exhibit: %@", exhibitItem);
            }];
        }
            break;
            
            ///标本背后的故事 标本信息
        case 14:
        {
            [DataManager loadSpecimenWithSpecimenId:@32 callback:^(SpecimenItem *specimenItem, BOOL success) {
                NSLog(@"specmenItem: %@", specimenItem);
            }];
        }
            break;
            
            
            ///展品所在位置
        case 15:
        {
            ExhibitItem *exhibitItem = [[ExhibitItem alloc] init];
            exhibitItem.sid = @22;
             [DataManager loadExhibitPositionWithExhibit:exhibitItem callback:^(InfoItem *infoItem, BOOL success) {
                 NSLog(@"infoItem: %@", infoItem);
             }];
        }
            break;
            
            ///评论列表
        case 16:
        {
            User *user = [[User alloc] init];
            user.sid = @1;
            
            [DataManager loadCommnetsWithUser:user type:CommentStory callback:^(NSArray *comments, BOOL success) {
                NSLog(@"comments :%@", comments);
            }];
        }
            break;
            
            ///获取楼层信息点
        case 17:
        {
            User *user = [[User alloc] init];
            user.sid = @1;
            
            [DataManager loadPointInfoWithUser:user floor:1 inView: nil callback:^(NSArray *infos, BOOL success) {
                //
                NSLog(@"infos: %@", infos);
            } ];
        }
            break;
            
            ///获取信息点详细信息， 通过InfoItem
        case 18:
        {
            InfoItem *infoItem = [[InfoItem alloc] init];
            infoItem.sid = @60;
            [DataManager loadExhibitDetailWithInfo:infoItem callback:^(ExhibitItem *exhibitItem, BOOL success) {
                NSLog(@"exhibit: %@", exhibitItem);
            }];
        }
            break;
            
            ///获取标本背后的故事， 通过InfoItem
        case 19:
        {
            InfoItem *infoItem = [[InfoItem alloc] init];
            infoItem.sid = @60;
            [DataManager loadSpecimenDetailWithInfo:infoItem callback:^(SpecimenItem *specimenItem, BOOL success) {
                NSLog(@"specimen: %@", specimenItem);
            }];
        }
            break;
            
            ///远程视频，详细
        case 20:
        {
            InfoItem *infoItem = [[InfoItem alloc] init];
            infoItem.sid = @60;
            [DataManager loadRemoteVideoWithInfo:infoItem callback:^(RemoteVideoItem *remoteVideoItem, BOOL success) {
                NSLog(@"remote video: %@", remoteVideoItem);
            }];
        }
            break;
            
            //信息点点赞
        case 21:
        {
            InfoItem *infoItem = [[InfoItem alloc] init];
            infoItem.sid = @60;
            [DataManager postPraiseWithInfoItem:infoItem callback:^(NSInteger praiseNum, BOOL success) {
                NSLog(@"praiseNumber: %i", praiseNum);
            }];
        }
            break;
            
            //展区信息
        case 22:
        {
            [DataManager loadAreas:^(NSArray *areas, BOOL success) {
                NSLog(@"areas: %@", areas);
            }];
        }
            break;
            
            //游戏主题
        case 23:
        {
            [DataManager loadGameThemesInView:self.view callback:^(NSArray *themes, BOOL success) {
                NSLog(@"themes: %@", themes);
            }];
        }
            break;
            //安排信息
            case 24:
        {
            FilmItem *filmItem = [[FilmItem alloc] init];
            filmItem.sid = @1;
            [DataManager loadSchedulesWithItem:filmItem user:nil callback:^(NSArray *schudules, BOOL success) {
                NSLog(@"schedules: %@", schudules);
            }];
        }
            break;
            
            //电影明细
        case 25:
        {
            FilmItem *filmItem = [[FilmItem alloc] init];
            filmItem.sid = @1;
            user.sid = @8;
            [DataManager loadSchedulesWithItem:filmItem user:nil callback:^(NSArray *schudules, BOOL success) {
                [DataManager loadFilmWithScheduleItem:schudules[0] user:user callback:^(FilmItem *filmItem, BOOL success) {
                    NSLog(@"filmItem: %@", filmItem);
                }];
            }];
            
        }
            break;
            //活动明细
        case 26:
        {
            ActivityItem *actItem = [[ActivityItem alloc] init];
            actItem.sid = @11;
            user.sid = @8;
            [DataManager loadSchedulesWithItem:actItem user:nil callback:^(NSArray *schudules, BOOL success) {
                [DataManager loadActivityWithScheduleItem:schudules[0] user:user callback:^(ActivityItem *activityItem, BOOL success) {
                    NSLog(@"actitvityItem: %@", activityItem);
                }];
            }];
            
        }
            break;
            
            //合集
        case 27:
        {
            [DataManager loadOrdersWithFloor:2 callback:^(NSArray *orders, BOOL success) {
                NSLog(@"Orders: %@", orders);
            }];
        }
            break;
            
            //删除预约
        case 28:
        {
            user.sid = @8;
            [DataManager loadAppointmentWithUser:user callback:^(NSArray *orders, BOOL success) {
                //
                [DataManager postCancelWithOrder:orders[0] user:user callback:^(BOOL success) {
                    NSLog(@"success: %@", success?@"YES":@"NO");
                }];
            }];
            
        }
            break;
            
            //游戏任务列表
        case 29:
        {
            /*
            [DataManager loadGameThemes:^(NSArray *themes, BOOL success) {
                if (success) {
                    [DataManager loadGameTasksWithTheme:themes[0] callback:^(NSArray *gameTasks, BOOL success) {
                        NSLog(@"gameTasks: %@", gameTasks);
                    }];
                }
            }];
             */
            
        }
            break;
            //游戏任务相关的展品的信息点
        case 30:
        {
             /*
            [DataManager loadGameThemes:^(NSArray *themes, BOOL success) {
                if (success) {
                    [DataManager loadExhibitsWithGameTheme:themes[0] callback:^(NSArray *infos, BOOL success) {
                        NSLog(@"infos: %@", infos);
                    }];
                }
            }];
             */

            
        }
            break;
            
            //游戏检查
        case 31:
        {
            user.sid = @8;
            /*
            [DataManager loadGameThemes:^(NSArray *themes, BOOL success) {
                if (success) {
                    [DataManager loadExhibitsWithGameTheme:themes[0] callback:^(NSArray *infos, BOOL success) {
                        [DataManager loadCheckWithGameTask:themes[0] user:user infoItem:infos[0] callback:^(BOOL success) {
                            NSLog(@"check success:%@", success?@"YES":@"NO");
                        }];
                    }];
                }
            }];
             */
            
        }
            break;
            
            //关键字获取展馆资源
        case 32:
        {
            [DataManager loadRouteWithKeyword:@"1" callback:^(NSArray *infos, BOOL success) {
                //
                NSLog(@"infos:%@", infos);
            }];
            
        }
            break;
            
            //公共设施列表
        case 33:
        {
            [DataManager loadFacilityWithFloor:Floor2 point:CGPointZero callback:^(NSArray *facilities, BOOL success) {
                NSLog(@"facilities: %@", facilities);
            }];
            
        }
            break;
            
            //获取推荐路线
        case 34:
        {
            [DataManager loadRecommendRoutes:^(NSArray *routes, BOOL success) {
                NSLog(@"recommend routes:%@", routes);
            }];
        }
            break;
            
            //推荐路线引导点
        case 35:
        {
            [DataManager loadRecommendRoutes:^(NSArray *routes, BOOL success) {
                if (success) {
                    RecommendRouteItem *routeItem = routes[0];
                    [DataManager loadInfoItemsWithRecommendRoute:routeItem callback:^(NSArray *infos, BOOL successs) {
                        NSLog(@"引导点：%@", infos);
                    }];
                }
            }];
        }
            break;
            
            //最热门参观路线
        case 36:
        {
            [DataManager loadPraiseRoute:^(NSArray *infos, BOOL success) {
                NSLog(@"praise routes:%@", infos);
            }];
        }
            break;
            
            //最热门参观引导路线
        case 37:
        {
            [DataManager loadPraiseRouteInfoItems:^(NSArray *infos, BOOL success) {
                NSLog(@"infos: %@", infos);
            }];
        }
            break;
            
            //用户自定义寻路
        case 38:
        {
            InfoItem *infoItem = [[InfoItem alloc] init];
            infoItem.sid = @142;
            infoItem.type = InfoItemSpecimen;
            [DataManager loadPathWithFloor:Floor1 point:CGPointZero targetInfoItem:infoItem callback:^(NSArray *infos, BOOL success) {
                NSLog(@"自定义寻路:%@", infos);
            }];
        }
            break;
            
        default:
            break;
    }
    
}



@end
