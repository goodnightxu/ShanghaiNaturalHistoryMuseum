//
//  OrderViewController.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-22.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderHeaderView.h"
#import "UITableView+DragLoad.h"
#import "OrderDetailViewController.h"
#import "DataManager.h"
#import "FilmItem.h"
#import "ActivityItem.h"
#import "OrderItem.h"
#import "PublicMethod.h"
#import "RightTableView.h"
#import "EventTableViewCell.h"
#import "MyOrderTableViewCell.h"
#import "EmptyDataView.h"


@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,OrderHeaderViewDelegate,UITableViewDragLoadDelegate,RightTableViewDelegate> {
    IBOutlet UILabel *noUserLabel;
    IBOutlet UILabel *rightLabel1;
    IBOutlet UILabel *rightLabel2;
    IBOutlet UILabel *rightLabel3;
    IBOutlet UILabel *rightLabel4;
    IBOutlet UIView *leftContainerView;
    IBOutlet UIView *rightContainerView;
    IBOutlet UITableView *orderTableView;
    NSMutableArray *orderDataArray;
    
    NSDictionary *clientDic;
    OrderHeaderView *headerView;
    RightTableView *rightTable;
    
    OrderDetailViewController *orderDetailVC1;
    
    EmptyDataView *orderEmptyView;
    
    OrderDetailViewController *currentDetailVC;
    
    NSMutableArray *myOrderTimeArray;

}

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}


-(void)dealloc {
    //这句必须要有，不然pop回去会报错
    [orderTableView setDragDelegate:nil refreshDatePermanentKey:@"EventList"];
}

#warning 登录成功回来后要更新我的预约UI
-(void)didLogin {
    [self reloadRight];
    [currentDetailVC reloadCurrentUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    orderEmptyView=[[EmptyDataView alloc] initWithFrame:CGRectMake(0, 100, leftContainerView.frame.size.width, 200) text:@"暂时未能获取数据，请稍后再试"];
    orderEmptyView.hidden=YES;
    [leftContainerView addSubview:orderEmptyView];
    
    
    rightLabel1.font=[UIFont fontWithName:LanTingHei size:24.0f];
    rightLabel2.font=[UIFont fontWithName:LanTingHei size:14.0f];
    rightLabel3.font=[UIFont fontWithName:LanTingHei size:18.0f];
    rightLabel4.font=[UIFont fontWithName:LanTingHei size:14.0f];
    noUserLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];

    
    orderTableView.hidden=YES;

    
    orderTableView.rowHeight=172;
    orderTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [orderTableView setDragDelegate:self refreshDatePermanentKey:@"EventList"];
    orderTableView.showLoadMoreView = NO;
    
   
    headerView=[[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, 751, 70)];
    headerView.delegate=self;
    headerView.eventCount=0;
    [DataManager loadPersonTypes:^(NSDictionary *personDic, BOOL success) {
        if (success) {
            clientDic=personDic;
            headerView.eventDataArray=[personDic allValues];
            orderDataArray=[[NSMutableArray alloc] init];
            [self reloadTableViewForTag:0];
        }
    }];
    
    [leftContainerView addSubview:headerView];
    
    rightTable=[[RightTableView alloc] initWithFrame:CGRectMake(0, 245, rightContainerView.frame.size.width, rightContainerView.frame.size.height-245)];
    rightTable.delegate1=self;
    [rightContainerView addSubview:rightTable];
    if (![DataManager getUser]) {
        return;
    }
    
    
    [self reloadRight];
}

#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = nil;
    nav.subBottomTitle = nil;
    
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}

- (void)onMenuBt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)reloadTableViewForTag:(NSInteger)tag {//0表示电影，1标识教育活动，3表示我的预约
    switch (tag) {
        case 0: {
            [DataManager loadFilmsWithPersonType:nil
                                            user:[DataManager getUser]
                                        callback:^(NSArray *films, BOOL success) {
                                            if (success) {
                                                orderDataArray=[NSMutableArray arrayWithArray:films];
                                                [self finishRefresh];
                                                headerView.eventCount=orderDataArray.count;
                                            }
                                        }];
        }
        break;
        case 1: {
            
            [DataManager loadActivitesWithPersonType:[[clientDic allKeysForObject:headerView.eventBtn.selectedItem] objectAtIndex:0]
                                                user:[DataManager getUser]
                                            callback:^(NSArray *activities, BOOL success) {
                                                if (success) {
                                                    orderDataArray=[NSMutableArray arrayWithArray:activities];
                                                    [self finishRefresh];
                                                    headerView.eventCount=orderDataArray.count;
                                                }
                                            }];
        }
            break;
        case 2: {
            
            myOrderTimeArray=[[NSMutableArray alloc] init];
            [DataManager loadAppointmentWithUser:[DataManager getUser] callback:^(NSArray *orders, BOOL success) {
                if (success) {
                    
                    orderDataArray=[NSMutableArray arrayWithArray:orders];
                    
                    __block NSInteger sumOrders=orders.count;
                    __block NSInteger currentIndex=0;
                    for (OrderItem *item in orderDataArray) {
                         sumOrders--;
                        [DataManager loadSchedulesWithItem:(OrderItem *)item user:[DataManager getUser] callback:^(NSArray *schudules, BOOL success) {
 
                             sumOrders++;
                            
                            
                            if (success && schudules.count>0) {
                                ScheduleItem *sch=(ScheduleItem *)[schudules objectAtIndex:0];
                                if ([item preorderType]==PreorderFilm) {
                                    [DataManager loadFilmWithScheduleItem:sch user:[DataManager getUser] callback:^(FilmItem *filmItem, BOOL success) {
                                        if (success) {
                                            [myOrderTimeArray addObject:filmItem];
                                            currentIndex++;
                                            if (currentIndex==sumOrders) {
                                                [self finishRefresh];
                                                headerView.eventCount=orderDataArray.count;
                                            }
                                        }
                                    }];
                                } else {
                                    [DataManager loadActivityWithScheduleItem:sch user:[DataManager getUser] callback:^(ActivityItem *activityItem, BOOL success) {
                                        if (success) {
                                            [myOrderTimeArray addObject:activityItem];
                                            currentIndex++;
                                            if (currentIndex==sumOrders) {
                                                [self finishRefresh];
                                                headerView.eventCount=orderDataArray.count;
                                            }
                                        }
                                    }];
                                    
                                }
                            }
                        }];
                        
                    }
                }
            }];
            [self reloadRight];
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item;
    if (orderDataArray.count>0) {
        item=[orderDataArray objectAtIndex:indexPath.row];
    }
    
    if ([item isKindOfClass:[FilmItem class]] || [item isKindOfClass:[ActivityItem class]]) {
        static NSString *identifier = @"EventTableViewCell";
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if ([item isKindOfClass:[FilmItem class]]) {
            cell.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
            [DataManager loadPicWithPath:[(FilmItem *)item titlePic] inView:cell.iconImageView callback:^(UIImage *image, BOOL useCache, BOOL success) {
                if (success && image) {
                    cell.iconImageView.alpha=0;
                    [UIView animateWithDuration:0.25f
                                     animations:^{
                                         cell.iconImageView.image=image;
                                         cell.iconImageView.alpha=1.0f;
                                     } completion:nil];
                }
            }];
            cell.titleLabel.text=[(FilmItem *)item name];
            NSString *content;
            if ([(FilmItem *)item introduction].length==0) {
                content=@"主要内容：暂无";
            } else {
                if ([(FilmItem *)item introduction].length>24) {
                    content=[NSString stringWithFormat:@"主要内容：%@",[[(FilmItem *)item introduction] substringToIndex:24]];
                } else {
                    content=[NSString stringWithFormat:@"主要内容：%@",[(FilmItem *)item introduction]];
                }
            }
            [cell.contentLabel setText:content
                              WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                              AndColor:[UIColor grayColor]];
            [cell.contentLabel setKeyWordTextString:@"主要内容："
                                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                           AndColor:[UIColor darkGrayColor]];
            
            [cell.filmTimeLabel setText:[NSString stringWithFormat:@"片长：%@",[(FilmItem *)item playTime]]
                              WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                              AndColor:[UIColor grayColor]];
            
            [cell.filmTimeLabel setKeyWordTextString:@"片长："
                                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                           AndColor:[UIColor darkGrayColor]];
            cell.filmTimeLabel.hidden=NO;
            cell.tagScrollView.hidden=YES;
            
            cell.peopleLabel.text=[NSString stringWithFormat:@"浏览%@次",[(FilmItem *)item browseNum]];
            
        } else {
            cell.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
            [DataManager loadPicWithPath:[(ActivityItem *)item titlePic] inView:cell.iconImageView  callback:^(UIImage *image, BOOL useCache, BOOL success) {
                if (success && image) {
                    cell.iconImageView.alpha=0;
                    [UIView animateWithDuration:0.25f
                                     animations:^{
                                         cell.iconImageView.image=image;
                                         cell.iconImageView.alpha=1.0f;
                                     } completion:nil];
                }
            }];
            cell.titleLabel.text=[(ActivityItem *)item name];
            NSString *content;
            if ([(ActivityItem *)item contents].length==0) {
                content=@"主要内容：暂无";
            } else {
                if ([(ActivityItem *)item contents].length>24) {
                    content=[NSString stringWithFormat:@"主要内容：%@",[[(ActivityItem *)item contents] substringToIndex:24]];
                } else {
                    content=[NSString stringWithFormat:@"主要内容：%@",[(ActivityItem *)item contents]];
                }
            }
            [cell.contentLabel setText:content
                              WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                              AndColor:[UIColor grayColor]];
            [cell.contentLabel setKeyWordTextString:@"主要内容："
                                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                           AndColor:[UIColor darkGrayColor]];
            
            cell.filmTimeLabel.hidden=YES;
            cell.tagScrollView.hidden=NO;
            //教育活动的标签手动修改
            cell.tagsArray=[NSArray arrayWithObjects:@"教育工作者",@"亲子活动",@"学生", nil];
            
            cell.peopleLabel.text=[NSString stringWithFormat:@"浏览%@次",[(ActivityItem *)item browseNum]];

        }
        
        return cell;
    } else {
        static NSString *identifier = @"MyOrderTableViewCell";
        MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setClickMap:^{
            InfoItem *infoItem1=[[InfoItem alloc] init];
            if ([(OrderItem *)item preorderType]==PreorderFilm) {
                infoItem1.type=InfoItemCinema;
            } else {
                infoItem1.type=InfoItemCinema;
            }
            infoItem1.title=[(OrderItem *)item name];
            infoItem1.relationId=[(OrderItem *)item cid];
            
            [DataManager loadPointInfoWithInfoItem:infoItem1 callback:^(InfoItem *infoItem, BOOL success) {
                if (CGPointEqualToPoint(infoItem.pt, CGPointZero)) {
                    [PublicMethod HUDOnlyLabelForView:self.view
                                          withMessage:@"未能获取坐标"];
                } else {
                    infoItem.title=infoItem1.title;
                    infoItem.iconPath=infoItem1.iconPath;
                    self.showInMap(infoItem);
                }
            }];
        }];
        cell.titleLabel.text=[(OrderItem *)item name];
        [cell.orderCodeLabel setText:[NSString stringWithFormat:@"预约码：%@ 检票完成",[(OrderItem *)item bookCode]]
                          WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                          AndColor:[UIColor grayColor]];
        [cell.orderCodeLabel setKeyWordTextString:@"预约码："
                                       WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                       AndColor:[UIColor darkGrayColor]];
        [cell.orderCodeLabel setKeyWordTextString:@"检票完成"
                                         WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                         AndColor:ORDERVIEW_THEME_GREEN_COLOR];
        
        [cell.peopleLabel setText:[NSString stringWithFormat:@"人数：%@",[(OrderItem *)item bookNum]]
                       WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                       AndColor:[UIColor grayColor]];
        [cell.peopleLabel setKeyWordTextString:@"人数："
                                    WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                    AndColor:[UIColor darkGrayColor]];
        
        id timeItem=[myOrderTimeArray objectAtIndex:indexPath.row];
        if ([timeItem isKindOfClass:[FilmItem class]]) {
            [cell.timeLabel setText:[NSString stringWithFormat:@"时间：%@",[(FilmItem *)timeItem playBeginTime]]
                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                           AndColor:[UIColor grayColor]];
            [cell.timeLabel setKeyWordTextString:@"时间："
                                        WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                        AndColor:[UIColor darkGrayColor]];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
            NSString *day=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *beginString=[NSString stringWithFormat:@"%@ %@:00",day,[(FilmItem *)timeItem playBeginTime]];
            NSDate *startDate=[dateFormatter dateFromString:beginString];
            NSTimeInterval time=[startDate timeIntervalSinceNow];
            CGFloat movieTime=[[[[(FilmItem *)timeItem playTime] componentsSeparatedByString:@"分"] objectAtIndex:0] floatValue] * 60;
            if (time+movieTime<0) {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_end.png"];
            } else if (time+movieTime>=0 && time+movieTime<=movieTime) {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_running.png"];
            } else {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_notstart.png"];
            }

        } else {
            [cell.timeLabel setText:[NSString stringWithFormat:@"时间：%@",[(ActivityItem *)timeItem beginTime]]
                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                           AndColor:[UIColor grayColor]];
            [cell.timeLabel setKeyWordTextString:@"时间："
                                        WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                        AndColor:[UIColor darkGrayColor]];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
            NSString *day=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *beginString=[NSString stringWithFormat:@"%@ %@:00",day,[(ActivityItem *)timeItem beginTime]];
            NSString *endString=[NSString stringWithFormat:@"%@ %@:00",day,[(ActivityItem *)timeItem endTime]];
            NSDate *startDate=[dateFormatter dateFromString:beginString];
            NSDate *endDate=[dateFormatter dateFromString:endString];
            if ([endDate timeIntervalSinceNow]<0) {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_end.png"];
            } else if ([endDate timeIntervalSinceNow]>=0 && [startDate timeIntervalSinceNow]<=0) {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_running.png"];
            } else {
                cell.statusImageView.image=[UIImage imageNamed:@"order_status_notstart.png"];
            }

        }
        
      
        
        return cell;
    }
    

}

-(void)reloadRight {
    noUserLabel.hidden=YES;
    [DataManager loadAppointmentWithUser:[DataManager getUser]callback:^(NSArray *orders, BOOL success) {
        if (success) {
            __block NSMutableArray *newArray=[[NSMutableArray alloc] init];
            __block NSInteger sumOrders=orders.count;
            __block NSInteger currentIndex=0;
            for (int i=0; i<orders.count; i++) {
                OrderItem *item=(OrderItem *)[orders objectAtIndex:i];
                [DataManager loadSchedulesWithItem:(OrderItem *)item user:[DataManager getUser] callback:^(NSArray *schudules, BOOL success) {
                    sumOrders--;
                    if (success && schudules.count>0) {
                        sumOrders++;
                        ScheduleItem *sch=(ScheduleItem *)[schudules objectAtIndex:0];
                        if ([item preorderType]==PreorderFilm) {
                            [DataManager loadFilmWithScheduleItem:sch user:[DataManager getUser] callback:^(FilmItem *filmItem, BOOL success) {
                               
                                if (success) {
                                    item.beginTime=filmItem.playBeginTime;
                                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
                                    NSString *s=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
                                    NSString *startTimeString=[NSString stringWithFormat:@"%@ %@:00",s,item.beginTime];
                                    NSDate *startDate=[dateFormatter dateFromString:startTimeString];
                                    NSTimeInterval timeInterval=[startDate timeIntervalSinceNow];
                                    if (timeInterval>0) {
                                        [newArray addObject:item];
                                    }
                                    
                                    currentIndex++;
                                    NSLog(@"i1====%i,%i",currentIndex,sumOrders);
                                    if (currentIndex==sumOrders) {
                                        [self loadRightFinished:newArray];
                                    }
                                }
                            }];
                        } else {
                            [DataManager loadActivityWithScheduleItem:sch user:[DataManager getUser] callback:^(ActivityItem *activityItem, BOOL success) {
                                if (success) {
                                    item.beginTime=activityItem.beginTime;
                                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
                                    NSString *s=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
                                    NSString *startTimeString=[NSString stringWithFormat:@"%@ %@:00",s,item.beginTime];
                                    NSDate *startDate=[dateFormatter dateFromString:startTimeString];
                                    
                                    NSTimeInterval timeInterval=[startDate timeIntervalSinceNow];
                                    
                                    if (timeInterval>0) {
                                        [newArray addObject:item];
                                    }
                                    
                                    currentIndex++;
                                    NSLog(@"i2====%i,%i",currentIndex,sumOrders);
                                    if (currentIndex==sumOrders) {
                                        [self loadRightFinished:newArray];
                                    }
                                }
                            }];
                        }
                    }
                }];
            }
        }
    }];

}
-(void)loadRightFinished:(NSArray *)array {
    
    NSArray *sortedArray1 = [array sortedArrayUsingComparator:^NSComparisonResult(OrderItem *obj1, OrderItem *obj2){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *date1=[dateFormatter dateFromString:obj1.beginTime];
        NSDate *date2=[dateFormatter dateFromString:obj2.beginTime];
        if ([date1 timeIntervalSinceDate:date2]<0) {
            return NSOrderedAscending;
        }
        if ([date1 timeIntervalSinceDate:date2]>0){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    rightTable.rightDataArray=[NSMutableArray arrayWithArray:sortedArray1];
    [rightTable reloadData];
    rightTable.hidden=NO;
}
#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    OrderDetailViewController *orderDetailVC=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    orderDetailVC.originalIndex=indexPath.row;
    orderDetailVC.detailDataArray=[NSMutableArray arrayWithArray:orderDataArray];
    [orderDetailVC setDidOrderSuccess:^{
        [self reloadRight];
    }];
    [orderDetailVC setShowInMap:^(InfoItem *item) {
        
        [DataManager loadPointInfoWithInfoItem:item callback:^(InfoItem *infoItem, BOOL success) {
           
            if (CGPointEqualToPoint(infoItem.pt, CGPointZero)) {
                [PublicMethod HUDOnlyLabelForView:self.view
                                      withMessage:@"未能获取坐标"];
            } else {
                infoItem.title=item.title;
                infoItem.iconPath=item.iconPath;
                self.showInMap(infoItem);
            }
            
        }];
    }];
    orderDetailVC.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3f];
    orderDetailVC.view.frame=CGRectMake(0, 0, 751, 768);
    [self addChildViewController:orderDetailVC];
    [leftContainerView addSubview:orderDetailVC.view];
    [orderDetailVC didMoveToParentViewController:self];
    orderDetailVC.view.alpha=0;
    [UIView animateWithDuration:0.25f
                     animations:^{
                        orderDetailVC.view.alpha=1.0f;
                     } completion:nil];
    currentDetailVC=orderDetailVC;
    
}

#pragma mark - Control datasource

- (void)finishRefresh
{
    if (orderDataArray.count>0) {
        orderEmptyView.hidden=YES;
        orderTableView.hidden=NO;
        [orderTableView finishRefresh];
        [orderTableView reloadData];
    } else {
        orderEmptyView.hidden=NO;
        orderTableView.hidden=YES;
    }
    
}

- (void)finishLoadMore
{
  
    [orderTableView finishLoadMore];
    [orderTableView reloadData];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    [self clickedheaderView];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma OrderHeaderViewDelegate
-(void)didSelectHeaderViewForItem:(NSString *)item {
    [orderTableView triggerRefresh];
    [self clickedheaderView];
}

-(void) clickedheaderView{
    if (headerView.movieBtn.selected==NO) {
        [self reloadTableViewForTag:0];
    } else if (headerView.eventBtn.selected==NO) {
        [self reloadTableViewForTag:1];
    } else {
        [self reloadTableViewForTag:2];
    }
}


-(void)didSelectRightTable:(RightTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (orderDetailVC1) {
        [orderDetailVC1.view removeFromSuperview];
        [orderDetailVC1 willMoveToParentViewController:nil];
        [orderDetailVC1 removeFromParentViewController];
        orderDetailVC1=nil;
    }
    orderDetailVC1=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    __weak  OrderViewController *weakSelf=self;
    [orderDetailVC1 setShowInMap:^(InfoItem *item) {
        [DataManager loadPointInfoWithInfoItem:item callback:^(InfoItem *infoItem, BOOL success) {
            if (CGPointEqualToPoint(infoItem.pt, CGPointZero)) {
                [PublicMethod HUDOnlyLabelForView:weakSelf.view
                                      withMessage:@"未能获取坐标"];
            } else {
                infoItem.title=item.title;
                infoItem.iconPath=item.iconPath;
                weakSelf.showInMap(infoItem);
            }

        }];
    }];
    orderDetailVC1.originalIndex=indexPath.row;
    orderDetailVC1.detailDataArray=[NSMutableArray arrayWithArray:tableView.rightDataArray];
    
    orderDetailVC1.view.backgroundColor=[[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    orderDetailVC1.view.frame=CGRectMake(0, 0, 751, 768);
    [self addChildViewController:orderDetailVC1];
    [leftContainerView addSubview:orderDetailVC1.view];
    [orderDetailVC1 didMoveToParentViewController:self];
    orderDetailVC1.view.alpha=0;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         orderDetailVC1.view.alpha=1.0f;
                     }
                     completion:nil];
    currentDetailVC=orderDetailVC1;
    
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
