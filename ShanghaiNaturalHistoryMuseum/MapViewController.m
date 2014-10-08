//
//  MapViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MapViewController.h"
#import "CustomNavigationController.h"
#import "DataManager.h"
#import "User.h"
#import "MenuList.h"
#import "ScaleProgress.h"
#import "MapIconView.h"
#import "RoutePathView.h"
#import "DisplayRouteList.h"
#import "OrderItem.h"
#import "FilmItem.h"
#import "ActivityItem.h"
#import "MapOrderView.h"

#import "OrderViewController.h"
#import "VisualSearchViewController.h"
#import "GameViewController.h"
#import "SystemManagerViewController.h"
#import "VisitRouteViewController.h"
#import "LookStudyViewController.h"
#import "WebViewController.h"
#import "LearnBookViewController.h"

#warning 测试用
#import "MainViewController.h"
#import "InfoItem.h"

#import "LocateItem.h"
#import "UserPositionView.h"

//Map
#define kMapViewWidth 4096
#define kMapViewHeight 3726

//MenuView
#define kMenuViewWidth 220
//ToolBar
#define kToolItemWidth 80
#define kToolItemHeight 69
//RightBar
//右侧按钮大小
#define kRightItemWidth 50
#define kRightItemHeight 50
//楼层按钮
#define kFloorBtWidth 56
#define kFloorBtHeight 56
#define kFloorBtPadding 18

#pragma mark - 楼层地图切换按钮
@implementation FloorButton

- (id)initWithTitle:(NSString *)title selectedColor:(UIColor *)color floorType:(FloorType)floorType
{
    self = [super initWithFrame:CGRectMake(0, 0, kFloorBtWidth, kFloorBtHeight)];
    if (self) {
        self.title = title;
        self.selectedColor = color;
        self.floorType = floorType;
        [self initializeUI];
    }
    
    return self;
}


- (void)initializeUI
{
    //
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.bounds.size.width * 0.5f;
    self.layer.borderWidth = 2;
    self.layer.borderColor = Color(3, 7, 4, 0.14f).CGColor;
    self.clipsToBounds = YES;
    //添加一个titleLabel, titleLabel的背景色跟深
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [titleString setAttributes:[Help floorTitleAttribute1] range:NSMakeRange(0, 1)];
    [titleString setAttributes:[Help floorTitleAttribute2] range:NSMakeRange(1, titleString.length - 1)];
    self.customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,kFloorBtWidth-4, kFloorBtHeight-4)];
    self.customLabel.layer.cornerRadius = self.customLabel.bounds.size.width * 0.5f;
    self.customLabel.clipsToBounds = YES;
    self.customLabel.backgroundColor = Color(102, 102, 102, 0.7f);
    self.customLabel.center = viewCenter(self.frame);
    self.customLabel.attributedText = titleString;
    self.customLabel.textColor  = [UIColor whiteColor];
    self.customLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.customLabel];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = self.selectedColor.CGColor;
        self.customLabel.textColor = self.selectedColor;
    }else
    {
        self.layer.borderColor = Color(3, 7, 4, 0.14f).CGColor;
        self.customLabel.textColor = [UIColor whiteColor];
        
    }
}

@end


@interface MapViewController () <VisitRouteViewControllerDelegate,MapIconViewDelegate>
{
    NSArray *visitRouteDataArray;
    
    CGSize _viewSize;
    //当前NavBt style
    kFRDLivelyButtonStyle _currentNavBtStyle;
    
    //地图标示工具栏， 底部
    UIView *_tagToolBar;
    //右侧工具栏
    UIView *_rightToolBar;
    //地图缩放
    UIScrollView *_mapSV;
    //楼层地图
    UIImageView *_floorMap;
    
    //
    FloorButton *_floor1Bt;
    FloorButton *_floor2Bt;
    FloorButton *_floor3Bt;
    FloorButton *_floor4Bt;
    FloorButton *_floor5Bt;
    FloorType _currentFloor;
    UIView *_floorBar;
    
    //当前现实的Icon
    newType _currentIconType;

    //
    ScaleProgress *_scaleProgress;
    CGFloat _lastScale;
    
    DisplayRouteList *routeList;
    RoutePathView *routePath;
    UIButton *pathBt;
    
    UIButton *floorSwithBt;
    //
    UserPositionView *_user;
    
    
    NSArray *currectRouteDatas;
    InfoItem *orderInfoItem;
    
//#warning 测试用
    //UILabel *_testLabel;
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:VIDEO_PATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:VIDEO_PATH
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    // Do any additional setup after loading the view.
    //ios7 隐藏statusBar
    [self setNeedsStatusBarAppearanceUpdate];
    //
    _viewSize = CGSizeMake(1024, 768);
    //
    [self autoLogin];
    //
    [self initializeMapScrollView];
    //
    [self initializeBg];
    //
    [self switchMapWithFloorType:Floor2];
    //
    [self initiailzeMenu];
    //
    [self initializeToolBar];
    //
    [self initializeRightBar];
    
    [self reloadMyOrder];
    
    [self initializeUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化我的预约
#warning 没登录的话，在登录后回到地图要reload一下我的预约
-(void)reloadMyOrder {
    for (MapOrderView *order in _floorMap.subviews) {
        if ([order isKindOfClass:[MapOrderView class]]) {
            [order removeFromSuperview];
        }
    }
    if ([DataManager getUser]) {
        [DataManager loadAppointmentWithUser:[DataManager getUser] callback:^(NSArray *orders, BOOL success) {
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
    
    InfoItem *infoItem=[[InfoItem alloc] init];
    for (OrderItem *item in sortedArray1) {
        if ([(OrderItem *)item preorderType]==PreorderFilm) {
            infoItem.type=InfoItemCinema;
        } else {
            infoItem.type=InfoItemCinema;
        }
        infoItem.relationId=[(OrderItem *)item cid];
        
        [DataManager loadPointInfoWithInfoItem:infoItem callback:^(InfoItem *infoItem, BOOL success) {
            if (!CGPointEqualToPoint(infoItem.pt, CGPointZero)) {
                [self showMyOrder:item floor:infoItem.floorCode.integerValue position:infoItem.pt];
            }
        }];
    }
    

}

-(void)showMyOrder:(OrderItem *)item floor:(FloorType)floor position:(CGPoint)point {
    if (_currentFloor==floor) {
        MapOrderView *order=[[MapOrderView alloc] initWithFloor:floor
                                                       position:point
                                                      orderItem:item];
        [_floorMap addSubview:order];
        [_floorMap sendSubviewToBack:order];
    }
}

#pragma mark - 自动登录
- (void)autoLogin
{
    User *user = [DataManager getUser];
    //有用户并且设置为自动登录
    if (user != nil && user.isAutoLogin) {
        //登录
        //后台没有超时，登入成功与否是用sid来判断，所以直接使用本地保存的user
        //[DataManager loginWithUser:user callback:<#^(User *user, BOOL success)callback#>]
    }else{
        //注销用户
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser];
    }
}

#pragma mark - Button
#pragma mark 切换菜单显示
- (void)onMenuBt:(FRDLivelyButton *)menuBt
{
    if (routeList) {
        [self hideRouteList];
        [UIView animateWithDuration:0.25
                         animations:^{
                             routePath.alpha=0;
                             for (UIView *subView in _floorMap.subviews) {
                                 if ([subView isKindOfClass:[MapIconView class]]) {
                                     if (subView.tag==newTypeDisplayRoute) {
                                         subView.alpha=0;
                                     }
                                 }
                             }
                         } completion:^(BOOL finished) {
                             [self removeShowedRoute];
                         }];
    } else {
        if (CGAffineTransformEqualToTransform(CGAffineTransformIdentity, self.menuList.view.transform )) {
            _currentNavBtStyle = kFRDLivelyButtonStyleCircleClose;
            [self showMenu];
            
        }else{
            _currentNavBtStyle = kFRDLivelyButtonStyleHamburger;
            [self hideMenu];
        }
        
        [menuBt setStyle:_currentNavBtStyle animated:YES];
    }
   
}

#pragma mark 点击地图标示工具栏
- (void)onToolBt:(UIButton *)bt
{
    
    if (!bt.selected && _currentIconType != newTypeAll) {
        //显示所有
        [self changeAllToolBtWithState:NO];
        _currentIconType = newTypeAll;
        [self switchIconView];
        return;
    }
    

    [self changeAllToolBtWithState:YES];
    bt.selected = !bt.selected;
    _currentIconType= bt.tag;
    [self switchIconView];

    [UIView animateWithDuration:0.25 animations:^{
        bt.transform = CGAffineTransformMakeTranslation(0, -10);
    }];
}

- (void)changeAllToolBtWithState:(BOOL)state
{
    for (UIButton *toolBt in _tagToolBar.subviews) {
        if ([toolBt isKindOfClass:[UIButton class]]) {
            toolBt.selected = state;
            [UIView animateWithDuration:0.25 animations:^{
                toolBt.transform = CGAffineTransformIdentity;
            }];
        }
    }
}


#pragma mark Right Tool Bar
- (void)onNotifiyBt
{
}

- (void)onQuestionBt
{
    
}

- (void)onCameraBt
{
    [self startMediaBrowserFromViewController:self type:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - StartMediaBrowse
- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                                       type:(UIImagePickerControllerSourceType)sourceType{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          sourceType] == NO)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = sourceType;
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}

- (void)onLocateBt:(UIButton *)bt
{
    if (bt.selected) {
        bt.alpha = 0.5f;
        _user.alpha = 0;
    }else{
        bt.alpha = 1.0f;
        _user.alpha = 1;
    }
    
    bt.selected = !bt.selected;
}

- (void)onPathBt
{
    if (routePath.alpha==0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             routePath.alpha=1;
                             for (UIView *subView in _floorMap.subviews) {
                                 if ([subView isKindOfClass:[MapIconView class]]) {
                                     if (subView.tag==newTypeDisplayRoute) {
                                         subView.alpha=1;
                                     }
                                 }
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             routePath.alpha=0;
                             for (UIView *subView in _floorMap.subviews) {
                                 if ([subView isKindOfClass:[MapIconView class]]) {
                                     if (subView.tag==newTypeDisplayRoute) {
                                         subView.alpha=0;
                                     }
                                 }
                             }
                         }];
    }
}

#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = @"L1";
    nav.subBottomTitle = @"展馆一层";
    
    //按钮
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:_currentNavBtStyle animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}

#pragma mark - Menu
- (void)initiailzeMenu
{
    self.menuList = [[MenuList alloc] initWithStyle:UITableViewStylePlain];
    __weak MapViewController *weakSelf = self;
    [self.menuList setSelectedMenu:^(MenuItem *menuItem) {
        
        if ([menuItem.title isEqualToString:@"预约查询"]) {
            OrderViewController *orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            [orderVC setShowInMap:^(InfoItem *item) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [weakSelf showOneItemInMap:item];
            }];
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        }else
        
        if ([menuItem.title isEqualToString:@"可视化搜索"]) {
            VisualSearchViewController *visualSearchVC = [[VisualSearchViewController alloc] initWithNibName:@"VisualSearchViewController" bundle:nil];
            [visualSearchVC setOnLocate:^(InfoItem *infoItem) {
                [weakSelf showItemInMap:infoItem];
            }];
            [weakSelf.navigationController pushViewController:visualSearchVC animated:YES];
        }else
        
        if ([menuItem.title isEqualToString:@"寻宝游戏"]) {
            GameViewController *gameVC = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
            [gameVC setOnStartTask:^(NSArray *infos) {
                if (infos.count >0) {
                    InfoItem *infoItem = infos[0];
                    
                    [weakSelf switchMapWithFloorType:infoItem.floorCode.intValue];
                    [weakSelf showGameIcon:infos];
                }
                
            }];
            [weakSelf.navigationController pushViewController:gameVC animated:YES];
        }else
        
        if ([menuItem.title isEqualToString:@"系统管理"]) {
            SystemManagerViewController *managerVC = [[SystemManagerViewController alloc] initWithNibName:@"SystemManagerViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:managerVC animated:YES];
        }
        else if ([menuItem.title isEqualToString:@"参观路线"]) {
                VisitRouteViewController *visitRouteVC = [[VisitRouteViewController alloc] initWithNibName:@"VisitRouteViewController" bundle:nil];
                visitRouteVC.delegate = self;
            visitRouteVC.floor=_currentFloor;
                [weakSelf.navigationController pushViewController:visitRouteVC animated:YES];
        }
        else if ([menuItem.title isEqualToString:@"学习单"]) {
            LearnBookViewController *learnBookVC = [[LearnBookViewController alloc] initWithNibName:@"LearnBookViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:learnBookVC animated:YES];
        }
        else {
            MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:mainVC animated:YES];
        }
        
        
        
    }];
    
    //移动到最右侧
    CGRect menuFrame = CGRectMake(_viewSize.width, kNavBarHeight, kMenuViewWidth, _viewSize.height-kNavBarHeight);
    self.menuList.view.frame = menuFrame;
    self.menuList.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:self.menuList];
    [self.view addSubview:self.menuList.view];
    [self.menuList didMoveToParentViewController:self];
    
    //
    _currentNavBtStyle = kFRDLivelyButtonStyleHamburger;
    
}

- (void)showMenu
{    
    self.menuList.view.userInteractionEnabled = NO;
    CGSize menuSize = self.menuList.view.bounds.size;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //
        self.menuList.view.transform = CGAffineTransformMakeTranslation(-menuSize.width, 0);
        _rightToolBar.transform = CGAffineTransformMakeTranslation(-menuSize.width, 0);
        _floorBar.transform = CGAffineTransformMakeTranslation(-menuSize.width, 0);
    } completion:^(BOOL finished) {
        self.menuList.view.userInteractionEnabled = YES;
    }];
}

- (void)hideMenu
{
    self.menuList.view.userInteractionEnabled = NO;
    CGSize menuSize = self.menuList.view.bounds.size;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.menuList.view.transform = CGAffineTransformIdentity;
        _rightToolBar.transform = CGAffineTransformIdentity;
        _floorBar.transform= CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.menuList.view.userInteractionEnabled = YES;
    }];
}
- (void)showRouteList
{
    routeList.view.userInteractionEnabled = NO;
    CGSize routeSize = routeList.view.bounds.size;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        routeList.view.transform = CGAffineTransformMakeTranslation(-routeSize.width, 0);
    } completion:^(BOOL finished) {
        routeList.view.userInteractionEnabled = YES;
    }];
}
- (void)hideRouteList
{
    routeList.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        pathBt.enabled=NO;
        routeList.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        routeList.view.userInteractionEnabled = YES;
        routeList=nil;
    }];
}


#pragma mark - ToolBar 底部工具栏
- (void)initializeToolBar
{
    if (_tagToolBar.superview != nil) {
        return;
    }

    _tagToolBar = [[UIView alloc] initWithFrame:CGRectMake(20, _viewSize.height, kToolItemWidth * 4, kToolItemHeight)];
    [self.view addSubview:_tagToolBar];

    UIButton *toolBt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBt1.tag = newTypeCraft;
    [toolBt1 setImage:[UIImage imageNamed:@"gameToolItem.png"] forState:UIControlStateNormal];
    [toolBt1 setImage:[UIImage imageNamed:@"gameToolItem1.png"] forState:UIControlStateSelected];
    toolBt1.frame = CGRectMake(0 * kToolItemWidth, 0, kToolItemWidth, kToolItemHeight);
    [toolBt1 addTarget:self action:@selector(onToolBt:) forControlEvents:UIControlEventTouchUpInside];
    [_tagToolBar addSubview:toolBt1];
    
    UIButton *toolBt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBt2.tag = newTypeSpecimen;
    [toolBt2 setImage:[UIImage imageNamed:@"storyToolItem.png"] forState:UIControlStateNormal];
    [toolBt2 setImage:[UIImage imageNamed:@"storyToolItem1.png"] forState:UIControlStateSelected];
    toolBt2.frame = CGRectMake(1 * kToolItemWidth, 0, kToolItemWidth, kToolItemHeight);
    [toolBt2 addTarget:self action:@selector(onToolBt:) forControlEvents:UIControlEventTouchUpInside];
    [_tagToolBar addSubview:toolBt2];
    
    
    UIButton *toolBt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBt3.tag = newTypeExhibit;
    [toolBt3 setImage:[UIImage imageNamed:@"craftToolItem.png"] forState:UIControlStateNormal];
    [toolBt3 setImage:[UIImage imageNamed:@"craftToolItem1.png"] forState:UIControlStateSelected];
    toolBt3.frame = CGRectMake(2 * kToolItemWidth, 0, kToolItemWidth, kToolItemHeight);
    [toolBt3 addTarget:self action:@selector(onToolBt:) forControlEvents:UIControlEventTouchUpInside];
    [_tagToolBar addSubview:toolBt3];
    
    UIButton *toolBt4 = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBt4.tag= newTypeRemoteVideo;
    [toolBt4 setImage:[UIImage imageNamed:@"videoToolItem.png"] forState:UIControlStateNormal];
    [toolBt4 setImage:[UIImage imageNamed:@"videoToolItem1.png"] forState:UIControlStateSelected];
    toolBt4.frame = CGRectMake(3 * kToolItemWidth, 0, kToolItemWidth, kToolItemHeight);
    [toolBt4 addTarget:self action:@selector(onToolBt:) forControlEvents:UIControlEventTouchUpInside];
    [_tagToolBar addSubview:toolBt4];
    
    _currentIconType = newTypeAll;
    [self changeAllToolBtWithState:NO];
    [self showToolBar];
    
}

- (void)showToolBar
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _tagToolBar.transform = CGAffineTransformMakeTranslation(0, -kToolItemHeight - 20);
    } completion:nil];
}

- (void)hideToolBar
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tagToolBar.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

#pragma mark - Right Bar 右侧工具栏
- (void)initializeRightBar
{
    if (_rightToolBar.superview != nil) {
        return;
    }
    
    //RightTool Bar
    _rightToolBar = [[UIView alloc] initWithFrame:CGRectMake(_viewSize.width - kRightItemWidth -30, kNavBarHeight + 8, 100, 768 - kNavBarHeight)];
    [self.view addSubview:_rightToolBar];
    
    //NotifiyBt
    UIButton *notifiyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    notifiyBt.frame = CGRectMake(0, 0, kRightItemWidth, kRightItemHeight);
    [notifiyBt setImage:[UIImage imageNamed:@"notifiyToolItem.png"] forState:UIControlStateNormal];
    [notifiyBt addTarget:self action:@selector(onNotifiyBt) forControlEvents:UIControlEventTouchUpInside];
    [_rightToolBar addSubview:notifiyBt];
    
    //你问我答
//    CGFloat last = CGRectGetMaxY(notifiyBt.frame) + 8;
//    UIButton *questionBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    questionBt.frame = CGRectMake(0, last, kRightItemWidth, kRightItemHeight);
//    [questionBt setImage:[UIImage imageNamed:@"questionToolItem.png"] forState:UIControlStateNormal];
//    [questionBt addTarget:self action:@selector(onQuestionBt) forControlEvents:UIControlEventTouchUpInside];
//    [_rightToolBar addSubview:questionBt];
    
    //随手拍
    CGFloat last = CGRectGetMaxY(notifiyBt.frame) + 8;
    UIButton *cameraBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBt.frame = CGRectMake(0, last, kRightItemWidth, kRightItemHeight);
    [cameraBt setImage:[UIImage imageNamed:@"cameraToolItem.png"] forState:UIControlStateNormal];
    [cameraBt addTarget:self action:@selector(onCameraBt) forControlEvents:UIControlEventTouchUpInside];
    [_rightToolBar addSubview:cameraBt];
    
    //放大缩小
    last = CGRectGetMaxY(cameraBt.frame) + 20;
    CGRect scaleViewFrame = CGRectMake(0, last, kRightItemHeight, 206);
    [self initializeScalePorgressWithFrame:scaleViewFrame];
    
    
    //定位
    last = CGRectGetMaxY(_scaleProgress.frame) + 8;
    UIButton *locateBt = [UIButton buttonWithType:UIButtonTypeCustom];
    locateBt.selected = NO;
    locateBt.alpha = 0.3f;
    locateBt.frame = CGRectMake(0, last, kRightItemWidth, kRightItemHeight);
    [locateBt setImage:[UIImage imageNamed:@"locateToolItem.png"] forState:UIControlStateNormal];
    [locateBt addTarget:self action:@selector(onLocateBt:) forControlEvents:UIControlEventTouchUpInside];
    [_rightToolBar addSubview:locateBt];
    
    //显示路线
    last = CGRectGetMaxY(locateBt.frame) + 8;
    pathBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pathBt.frame = CGRectMake(0, last, kRightItemWidth, kRightItemHeight);
    [pathBt setBackgroundImage:[UIImage imageNamed:@"pathToolItem.png"] forState:UIControlStateNormal];
    [pathBt addTarget:self action:@selector(onPathBt) forControlEvents:UIControlEventTouchUpInside];
    pathBt.enabled=NO;
    [_rightToolBar addSubview:pathBt];
    
    //楼层切换
    floorSwithBt = [UIButton buttonWithType:UIButtonTypeCustom];
    floorSwithBt.frame = CGRectMake(-kRightItemWidth * 0.5+16, 768 - kNavBarHeight - kToolItemHeight - 50, 67, 91);
    [floorSwithBt setImage:[UIImage imageNamed:@"floorToolItem.png"] forState:UIControlStateNormal];
    [floorSwithBt addTarget:self action:@selector(onFloorSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_rightToolBar addSubview:floorSwithBt];
    
    
    [self initializeFloorBar:floorSwithBt];
}

- (void)initializeFloorBar:(UIButton *)floorSwitchBt
{
    CGRect swithBtFrame = [self.view convertRect:floorSwitchBt.frame fromView:_rightToolBar];
    
    if (_floorBar.superview == nil) {
        CGRect frame = CGRectMake(swithBtFrame.origin.x, swithBtFrame.origin.y, (kFloorBtPadding+ kFloorBtWidth)*5, kFloorBtHeight);
        _floorBar = [[UIView alloc] initWithFrame:CGRectMake(swithBtFrame.origin.x - frame.size.width, swithBtFrame.origin.y+4, frame.size.width, frame.size.height)];
        
        if (!CGAffineTransformEqualToTransform(_rightToolBar.transform, CGAffineTransformIdentity)) {
            _floorBar = [[UIView alloc] initWithFrame:CGRectMake(swithBtFrame.origin.x - frame.size.width +kMenuViewWidth, swithBtFrame.origin.y+4, frame.size.width, frame.size.height)];
            _floorBar.transform = CGAffineTransformMakeTranslation(-kMenuViewWidth, 0);
        }else{
            _floorBar = [[UIView alloc] initWithFrame:CGRectMake(swithBtFrame.origin.x - frame.size.width, swithBtFrame.origin.y+4, frame.size.width, frame.size.height)];
        }
        
        [self.view addSubview:_floorBar];
    }
    
    
    CGPoint center = CGPointMake(_floorBar.frame.size.width + 28, _floorBar.frame.size.height * 0.5);
    _floor1Bt = [[FloorButton alloc] initWithTitle:@"L2" selectedColor:kColorL2 floorType:Floor2];
    _floor1Bt.center = center;
    _floor1Bt.alpha = 0.0f;
    if (_floor1Bt.floorType == _currentFloor) {
        _floor1Bt.selected = YES;
    }
    [_floor1Bt addTarget:self action:@selector(clickFloorBt:) forControlEvents:UIControlEventTouchUpInside];
    [_floorBar addSubview:_floor1Bt];
    
    _floor2Bt = [[FloorButton alloc] initWithTitle:@"L1" selectedColor:kColorL1 floorType:Floor1];
    _floor2Bt.center = center;
    _floor2Bt.alpha = 0.0f;
    if (_floor2Bt.floorType == _currentFloor) {
        _floor2Bt.selected = YES;
    }
    [_floor2Bt addTarget:self action:@selector(clickFloorBt:) forControlEvents:UIControlEventTouchUpInside];
    [_floorBar addSubview:_floor2Bt];
    
    _floor3Bt = [[FloorButton alloc] initWithTitle:@"B1" selectedColor:kColorB1 floorType:FloorUnderGround1];
    _floor3Bt.center = center;
    _floor3Bt.alpha = 0.0f;
    if (_floor3Bt.floorType == _currentFloor) {
        _floor3Bt.selected = YES;
    }
    [_floor3Bt addTarget:self action:@selector(clickFloorBt:) forControlEvents:UIControlEventTouchUpInside];
    [_floorBar addSubview:_floor3Bt];
    
    _floor4Bt = [[FloorButton alloc] initWithTitle:@"B2M" selectedColor:kColorB2M floorType:FloorUnderGroundInter];
    _floor4Bt.center = center;
    _floor4Bt.alpha = 0.0f;
    if (_floor4Bt.floorType == _currentFloor) {
        _floor4Bt.selected = YES;
    }
    [_floor4Bt addTarget:self action:@selector(clickFloorBt:) forControlEvents:UIControlEventTouchUpInside];
    [_floorBar addSubview:_floor4Bt];
    
    _floor5Bt = [[FloorButton alloc] initWithTitle:@"B2" selectedColor:kColorB2 floorType:FloorUnderGround2];
    _floor5Bt.center = center;
    _floor5Bt.alpha = 0.0f;
    [_floor5Bt addTarget:self action:@selector(clickFloorBt:) forControlEvents:UIControlEventTouchUpInside];
    if (_floor5Bt.floorType == _currentFloor) {
        _floor5Bt.selected = YES;
    }
    [_floorBar addSubview:_floor5Bt];
}

#pragma mark 放大缩小视图
- (void)initializeScalePorgressWithFrame:(CGRect)scaleViewFrame
{
    _scaleProgress = [[ScaleProgress alloc] initWithFrame:scaleViewFrame];
    _scaleProgress.progress = _mapSV.maximumZoomScale;
    __weak MapViewController *weakSelf = self;
    [_scaleProgress setOnZoomIn:^{
        [weakSelf mapZoomIn];
    }];
    [_scaleProgress setOnZoomOut:^{
        [weakSelf mapZoomOut];
    }];
    [_rightToolBar addSubview:_scaleProgress];
}



#pragma mark - BgView
- (void)initializeBg
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    bg.image = [UIImage imageNamed:@"mapBg.png"];
    [self.view insertSubview:bg atIndex:0];
}

- (void)switchMapWithFloorType:(FloorType)floorType
{
    //如果正在显示线路，那么切换地图也要切换线路
    if (routeList) {
        NSMutableArray *newDatas=[[NSMutableArray alloc] init];
        for (InfoItem *item1 in currectRouteDatas) {
            if (item1.floorCode.integerValue==floorType) {
                [newDatas addObject:item1];
            }
        }
        if (newDatas.count>0) {
            BOOL startFlag = currectRouteDatas.firstObject == newDatas.firstObject ? YES : NO;
            BOOL endFlag = currectRouteDatas.lastObject == newDatas.lastObject ? YES : NO;
            [self willShowRouteOnOneFloor:newDatas
                                hasOrigin:startFlag
                                   hasEnd:endFlag];
        }else {
            [self removeShowedRoute];
        }
    }
    
    
    if (floorType == _currentFloor) {
        NSLog(@"当前楼层， 没有切换");
        return;
    }
    _currentFloor = floorType;
    
    NSString *mapString = nil;
    switch (floorType) {
        case Floor1:
            mapString = @"L1-01-01-b.png";
            break;
        case Floor2:
            mapString = @"L2-01.png";
            break;
        case FloorUnderGround1:
            mapString = @"B1-01.png";
            break;
        case FloorUnderGround2:
            mapString = @"B2-01.png";
            break;
        case FloorUnderGroundInter:
            mapString = @"B2M-01.png";
            break;
        default:
            
            break;
    }
    
    NSAssert(mapString != nil, @"MapString == nil!!!");
    if (_floorMap == nil) {
        _floorMap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMapViewWidth*_mapSV.zoomScale, kMapViewHeight*_mapSV.zoomScale)];

        
        _floorMap.userInteractionEnabled = YES;
        _floorMap.layer.contents = (__bridge id)[UIImage imageNamed:mapString].CGImage;

        [_mapSV addSubview:_floorMap];
    
        
    }else{
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"contents"];
    
        ani.toValue = [NSValue valueWithNonretainedObject: (__bridge id)[UIImage imageNamed:mapString].CGImage];
        ani.duration = 0.5f;
       
        _floorMap.layer.contents = (__bridge id)[UIImage imageNamed:mapString].CGImage;

        
        [_floorMap.layer addAnimation:ani forKey:nil];

        
    }
    
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(closeIconView)];
    tapG.numberOfTapsRequired=1;
    tapG.numberOfTouchesRequired=1;
    [_floorMap addGestureRecognizer:tapG];
    
    
    [self initializeMapButtonWithFloorTyep:floorType];
    
}


#pragma mark - Map ScrollView
//- (void)initializeMapScrollView
//{
//    _mapSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
//    [_mapSV setContentSize:CGSizeMake(kMapViewWidth , kMapViewHeight
//                                      )];
//    _mapSV.showsHorizontalScrollIndicator = NO;
//    _mapSV.showsVerticalScrollIndicator = NO;
//    _mapSV.maximumZoomScale = 1.0;
//    _mapSV.minimumZoomScale = 0.25;
//    _mapSV.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
//    _mapSV.delegate = self;
//    
//    _lastScale = _mapSV.maximumZoomScale;
//    [self.view addSubview:_mapSV];
//}

-(void)closeIconView {
    for (MapIconView *iconView in _floorMap.subviews) {
        if ([iconView isKindOfClass:[MapIconView class]]) {
            if (iconView.isEnlarged) {
                [iconView onCloseBt];
            }
        }
    }
}

#pragma mark - Map ScrollView
- (void)initializeMapScrollView
{
    _mapSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    [_mapSV setContentSize:CGSizeMake(kMapViewWidth , kMapViewHeight
                                      )];
    _mapSV.showsHorizontalScrollIndicator = NO;
    _mapSV.showsVerticalScrollIndicator = NO;
    _mapSV.maximumZoomScale = 1.0;
    _mapSV.minimumZoomScale = 0.25;
    _mapSV.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
    _mapSV.delegate = self;

    _lastScale = _mapSV.maximumZoomScale;
    [self.view addSubview:_mapSV];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _floorMap;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

    //缩放比例
    _scaleProgress.progress = (scrollView.zoomScale - scrollView.minimumZoomScale)/ (scrollView.maximumZoomScale - scrollView.minimumZoomScale);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

    [self switchIconView];
    
    if (_lastScale < scale) {
        [self mapZoomInWithScale:scale];
        return;
    }
    
    if (_lastScale > scale) {
        [self mapZoomOutWithScale:scale];
        return;
    }
}

#pragma mark Map放大一个等级
- (void)mapZoomIn
{
    _lastScale += 0.25;
 
    if (_lastScale > _mapSV.maximumZoomScale) {
        _lastScale = _mapSV.maximumZoomScale;
    }
    
    [self mapZoomInWithScale:_lastScale];
}

- (void)mapZoomInWithScale:(CGFloat)scale
{
    _lastScale = ceil(scale/ 0.25f) * 0.25;
    [_mapSV setZoomScale:_lastScale animated:YES];
}

#pragma mark Map缩小一个等级
- (void)mapZoomOut
{
    _lastScale -= 0.25;
    
    if (_lastScale < _mapSV.minimumZoomScale) {
        _lastScale = _mapSV.minimumZoomScale;
    }
    
    [self mapZoomOutWithScale:_lastScale];

}

- (void)mapZoomOutWithScale:(CGFloat)scale
{
    _lastScale = floor(scale/ 0.25f) * 0.25;
    [_mapSV setZoomScale:_lastScale animated:YES];
}

#pragma mark - 地图标记
- (void)initializeMapButtonWithFloorTyep:(FloorType)floorType
{
    User *user = [[User alloc] init];
    [DataManager loadPointInfoWithUser:user floor:floorType inView:_mapSV callback:^(NSArray *infos, BOOL success) {
        if (success) {
            
            //Clean
            [self cleanAllMapIconViewWithout:newTypeDisplayRoute];
            
            //Add
            for (int n = 0; n< infos.count;n++) {
                InfoItem *infoItem = infos[n];
                MapIconView *iconView = [[MapIconView alloc] initWithInfoItem:infoItem canEnglarge:YES];
                iconView.tag=infoItem.type;
                iconView.delegate=self;
                iconView.alpha =0.0f;
                iconView.transform = CGAffineTransformMakeTranslation(0, -20);
                [_floorMap addSubview:iconView];

            }
            //动效
            [self switchIconView];
            
            if (orderInfoItem) {
                [self cleanAllMapIconViewWithout:newTypeDisplayRoute];
                MapIconView *iconView = [[MapIconView alloc] initWithInfoItem:orderInfoItem canEnglarge:YES];
                iconView.tag=newTypeCinema;
                [_floorMap addSubview:iconView];
                [iconView  enlarge];
                orderInfoItem=nil;
            } else {
                [self cleanMapIconView:newTypeCinema];
            }
            
            [self reloadMyOrder];
            
        }
    }];
}

- (void)switchIconView
{
    if (_mapSV.zoomScale >= 0.5) {
        
        [self showMapIcon:_currentIconType];
        
    }else{
        [self hideMapIcon:newTypeAll];
    }
}


- (void)showMapIcon:(newType)type
{
    
    NSInteger count = 1;
    CGFloat delay = 0;
    for (MapIconView *iconView in _floorMap.subviews){
        if ([iconView isKindOfClass:[MapIconView class]]) {
            
            //NSLog(@"delay: %f", delay);
            if (type == iconView.tag || type == newTypeAll ) {
                delay += 0.1f/count;
                count ++;
                [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
                    iconView.transform = CGAffineTransformIdentity;
                    iconView.alpha = 1.0;
                }completion:nil];
            }else{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    iconView.transform = CGAffineTransformMakeTranslation(0, 20);
                    iconView.alpha = 0.0;
                }completion:nil];
            }
            
        }
    }
}

- (void)hideMapIcon:(newType)type
{
 
    NSInteger count = 0;
    CGFloat delay = 0;
    for (MapIconView *iconView in _floorMap.subviews){
        if ([iconView isKindOfClass:[MapIconView class]]) {
            
            CGFloat alpha = 1.0f;
            if (type == iconView.tag || type == newTypeAll) {
                count ++;
                alpha = 0.0f;
            }
            
            delay += 0.2f/count;
            [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
                iconView.alpha = alpha;
            }completion:^(BOOL finished) {
                iconView.transform = CGAffineTransformMakeTranslation(0, -20);
            }];
        }
    }
}

-(void)cleanAllMapIconViewWithout:(newType)type {
    for (MapIconView *iconView in _floorMap.subviews){
        if ([iconView isKindOfClass:[MapIconView class]]) {
            if (type>=1) {
                if (iconView.tag != type && iconView.tag != newTypeCinema) {
                    [iconView removeFromSuperview];
                }
            } else {
                [iconView removeFromSuperview];
            }
        }
    }
}
-(void)cleanMapIconView:(newType)type {
    for (MapIconView *iconView in _floorMap.subviews){
        if ([iconView isKindOfClass:[MapIconView class]]) {
            if (iconView.tag==type) {
                [iconView removeFromSuperview];
            }
        }
    }

}

- (void)showItemInMap:(InfoItem *)item
{
    
    for (FloorButton *btn in _floorBar.subviews) {
        if ([btn isKindOfClass:[FloorButton class]] &&btn.floorType==item.floorCode.integerValue) {
            [self clickFloorBt:btn];
        }
    }
    
    
    [self mapZoomOutWithScale:1];
    
    [_mapSV scrollRectToVisible:CGRectMake(item.pt.x-_mapSV.frame.size.width/2,item.pt.y- _mapSV.frame.size.height/2, _mapSV.frame.size.width, _mapSV.frame.size.height) animated:NO];
    
    
    _currentIconType = newTypeAll;
    [self switchIconView];
    
    for (MapIconView *iconView in _floorMap.subviews) {
        if ([iconView isKindOfClass:[MapIconView class]] && iconView.infoItem.sid == item.sid) {
            NSLog(@"found !!!!");
            [iconView enlarge];
        }
    }
}

-(void)showOneItemInMap:(InfoItem *)item{
    
    NSLog(@"item info=====%@,%@,%@,%@",item.title,item.iconPath,item.floorCode,NSStringFromCGPoint(item.pt));
    if (!floorSwithBt.selected) {
        [self onFloorSwitch:floorSwithBt];
    }
    
    for (FloorButton *btn in _floorBar.subviews) {
        if ([btn isKindOfClass:[FloorButton class]]) {
            if (btn.floorType==item.floorCode.integerValue) {
                
                [self clickFloorBt:btn];
            }
        }
    }
    
    
    [self mapZoomOutWithScale:1];

    [_mapSV scrollRectToVisible:CGRectMake(item.pt.x-_mapSV.frame.size.width/2,item.pt.y- _mapSV.frame.size.height/2, _mapSV.frame.size.width, _mapSV.frame.size.height) animated:NO];
    
    
}

#pragma mark - 添加GameIcon 
- (void)showGameIcon:(NSArray *)infos
{
    //移除失效的
    for (MapIconView *mapIcon in _floorMap.subviews) {
        if ([mapIcon isKindOfClass:[MapIconView class]] && mapIcon.tag == newTypeCraft) {
            [mapIcon removeFromSuperview];
        }
    }
    
    //新增
    for (InfoItem *infoItem in infos) {
        infoItem.type = InfoItemGame;
        MapIconView *iconView = [[MapIconView alloc] initWithInfoItem:infoItem canEnglarge:YES];
        iconView.delegate=self;
        iconView.tag = newTypeCraft;
        iconView.alpha=0;
        CGRect rect1=iconView.frame;
        iconView.frame=CGRectMake(rect1.origin.x, rect1.origin.y-50, rect1.size.width, rect1.size.height);
        [_floorMap addSubview:iconView];
    }
    
    _currentIconType = newTypeCraft;
    [self switchIconView];
}
#pragma mark - VisitRouteViewControllerDelegate
-(void)needShowRoute:(NSArray *)infoItemsData title:(NSString *)title originalData:(NSArray *)datas {
    CustomNavigationController *nav=(CustomNavigationController *)self.navigationController;
    FRDLivelyButton *menuBt=(FRDLivelyButton *)nav.barButton;
    _currentNavBtStyle = kFRDLivelyButtonStyleCircleClose;
    [menuBt setStyle:_currentNavBtStyle animated:YES];

    
    routeList= [[DisplayRouteList alloc] init];
    routeList.datas=[NSArray arrayWithArray:datas];
    currectRouteDatas=[NSArray arrayWithArray:infoItemsData];
    [routeList setSelectedRoute:^(InfoItem *item) {
        //_currentFloor不能改成__weak
        if (_currentFloor != item.floorCode.integerValue) {
            NSMutableArray *newDatas=[[NSMutableArray alloc] init];
            for (InfoItem *item1 in infoItemsData) {
                if (item1.floorCode==item.floorCode) {
                    [newDatas addObject:item1];
                }
            }
            
            if (!floorSwithBt.selected) {
                [self onFloorSwitch:floorSwithBt];
            }
            for (FloorButton *btn in self.view.subviews) {
                if ([btn isKindOfClass:[FloorButton class]]) {
                    if (btn.floorType==item.floorCode.integerValue) {
                         [self clickFloorBt:btn];
                    }
                }
            }
        }
        
        for (MapIconView *iconView in _floorMap.subviews) {
            if ([iconView isKindOfClass:[MapIconView class]]) {
                if (iconView.infoItem==item) {
                    [iconView enlarge];
                }
            }
        }
        
    }];
    
    //移动到最右侧
    CGRect menuFrame = CGRectMake(_viewSize.width, kNavBarHeight, kMenuViewWidth, _viewSize.height-kNavBarHeight);
    routeList.view.frame = menuFrame;
    routeList.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:routeList];
    [self.view addSubview:routeList.view];
    [routeList didMoveToParentViewController:self];
    
    [self showRouteList];
    
    if (!floorSwithBt.selected) {
        [self onFloorSwitch:floorSwithBt];
    }
    InfoItem *firstItem=(InfoItem *)[infoItemsData objectAtIndex:0];
    for (FloorButton *btn in self.view.subviews) {
        if ([btn isKindOfClass:[FloorButton class]]) {
            if (btn.floorType==firstItem.floorCode.integerValue) {
                [self clickFloorBt:btn];
            }
        }
    }
    
}

-(void)willShowRouteOnOneFloor:(NSArray *)dataArray hasOrigin:(BOOL)originFlag hasEnd:(BOOL)endFlag {
    [self removeShowedRoute];
    
  
    [self closeIconView];
    
    routePath=[[RoutePathView alloc] initWithDataArray:dataArray animated:YES];
    [_floorMap addSubview:routePath];
    
    CGFloat scale=0.25f;
//    if (routePath.frame.size.width*1<=1024-220) {
//        scale=1;
//    } else if (routePath.frame.size.width*0.75<=1024-220) {
//        scale=0.75;
//    } else if (routePath.frame.size.width*0.5<=1024-220) {
//        scale=0.5;
//    } else {
//        scale=0.25;
//    }
    [self mapZoomOutWithScale:scale];
    
    for (MapIconView *iconView in _floorMap.subviews) {
        if ([iconView isKindOfClass:[MapIconView class]]) {
            [_floorMap bringSubviewToFront:iconView];
        }
    }
    
    [_mapSV scrollRectToVisible:CGRectMake(routePath.frame.origin.x*scale-400+routePath.frame.size.width*scale/2, routePath.frame.origin.y*scale-routePath.frame.size.height*scale/2-450+routePath.frame.size.height*scale, _mapSV.frame.size.width, _mapSV.frame.size.height) animated:NO];
    
   
    
    for (int i=0; i<dataArray.count; i++) {
        InfoItem *item=(InfoItem *)[dataArray objectAtIndex:i];
        NSString *imageName=@"mapicon_middle.png";
        if (originFlag) {
            if (i==0) {
                imageName=@"mapicon_start.png";
            }
        }
        if (endFlag) {
            if (i==dataArray.count-1) {
                imageName=@"mapicon_end.png";
            }
        }
        MapIconView *iconView = [[MapIconView alloc] initWithInfoItem:item iconImageName:imageName canEnglarge:NO];
        iconView.delegate=self;
        iconView.tag=newTypeDisplayRoute;//用以区分这是线路巡查的mapIconView
        iconView.alpha=0;
        CGRect rect1=iconView.frame;
        iconView.frame=CGRectMake(rect1.origin.x, rect1.origin.y-50, rect1.size.width, rect1.size.height);
        [_floorMap addSubview:iconView];
//        [self performSelector:@selector(showMapIconAnimation:)
//                   withObject:iconView
//                   afterDelay:0.2*i+0.5];
        
    }
    
    pathBt.enabled=YES;
//    [self performSelector:@selector(pathBtAnimated)
//               withObject:nil
//               afterDelay:0.2*dataArray.count+0.8];
   
}
//-(void)pathBtAnimated {
//    pathBt.alpha=1;
//    CGRect rect2=CGRectMake(0, 458, 50, 50);
//    CGPoint center=CGPointMake(25, 483);
//    
//    [UIView animateWithDuration:0.5f
//                     animations:^{
//                         pathBt.frame=CGRectMake(center.x-rect2.size.width, center.y-rect2.size.height, rect2.size.width*2, rect2.size.height*2);
//                     } completion:^(BOOL finished) {
//                         [UIView animateWithDuration:0.5 animations:^{
//                             pathBt.frame=rect2;
//                         }];
//                     }];
//}

-(void)removeShowedRoute {
    [routePath removeFromSuperview];
    for (UIView *subView in _floorMap.subviews) {
        if ([subView isKindOfClass:[MapIconView class]]) {
            if (subView.tag==newTypeDisplayRoute) {
                [subView removeFromSuperview];
            }
        }
    }

}


-(void)showMapIconAnimation:(MapIconView *)iconView {
    CGRect rect1=iconView.frame;
    [UIView animateWithDuration:0.5
                     animations:^{
                         iconView.alpha=1;
                         iconView.frame=CGRectMake(rect1.origin.x, rect1.origin.y+50, rect1.size.width, rect1.size.height);
                     }
                     completion:nil];
}


#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - MapIconViewDelegate
-(void)willEnglargeMapIconView:(MapIconView *)mapIconView infoItem:(InfoItem *)item {
    //线路巡查的点变大后右侧要高亮
    
    if (mapIconView.tag>=1) {
        if ([currectRouteDatas containsObject:item]) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[currectRouteDatas indexOfObject:item] inSection:0];
            
            [routeList.tableView selectRowAtIndexPath:indexPath
                                             animated:YES
                                       scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}
-(void)didTappedMapIconView:(MapIconView *)mapIconView infoItem:(InfoItem *)item {
    if (!item.relationId) {
        return;
    }
    
    [DataManager loadSpecimenWithSpecimenId:item.relationId callback:^(SpecimenItem *specimenItem, BOOL success) {
        if (success) {
            if (item.type==InfoItemSpecimen || item.type==InfoItemExhibit || item.type==InfoItemRemoteVideo) {
                if (specimenItem.lookPics.count==0 && (!specimenItem.lookVideoPath && specimenItem.lookVideoPath.length==0)) {
                    return ;
                }
                
                LookStudyViewController *lookStudyVC=[[LookStudyViewController alloc] initWithNibName:@"LookStudyViewController" bundle:nil];
                lookStudyVC.item=specimenItem;
                [self.navigationController pushViewController:lookStudyVC animated:YES];
                
                //http://211.144.107.201:9090/museum/uploadFiles/lookVideo/9c920bdc-12ef-49a3-9fcb-4328f73c18fc.flv
            }
        }
    }];
}

#pragma mark － 楼层切换按钮
- (void)showFloorSwitch:(UIButton *)floorSwitchBt
{
    self.view.userInteractionEnabled = NO;
    [UIView  animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor1Bt.transform = CGAffineTransformMakeTranslation(-350, 0);
        _floor1Bt.alpha = 1.0;
    } completion:nil];
    
    [UIView  animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor2Bt.transform = CGAffineTransformMakeTranslation(-280, 0);
        _floor2Bt.alpha = 1.0;
    } completion:nil];
    
    [UIView  animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor3Bt.transform = CGAffineTransformMakeTranslation(-210, 0);
        _floor3Bt.alpha = 1.0;
    } completion:nil];
    
    [UIView  animateWithDuration:0.25 delay:0.175 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor4Bt.transform = CGAffineTransformMakeTranslation(-140, 0);
        _floor4Bt.alpha = 1.0;
    } completion:nil];
    
    
    [UIView  animateWithDuration:0.3 delay:0.1875 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor5Bt.transform = CGAffineTransformMakeTranslation(-70, 0);
        _floor5Bt.alpha = 1.0;
    } completion:^(BOOL finish){
        self.view.userInteractionEnabled = YES;
    }];
    
}

- (void)clickFloorBt:(FloorButton *)floorBt
{
    for (FloorButton *floorBt in _floorBar.subviews) {
        if ([floorBt isKindOfClass:[FloorButton class]]) {
            floorBt.selected = NO;
        }
    }
    
    floorBt.selected = YES;
    
    [self switchMapWithFloorType:floorBt.floorType];
}

- (void)hideFloorBt
{
    self.view.userInteractionEnabled = NO;
    [UIView  animateWithDuration:0.3 delay:0.1875 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor1Bt.transform = CGAffineTransformIdentity;
        _floor1Bt.alpha = 0.0;
    }completion:^(BOOL finish){
        self.view.userInteractionEnabled = YES;
    }];
    
    [UIView  animateWithDuration:0.25 delay:0.175 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor2Bt.transform = CGAffineTransformIdentity;
        _floor2Bt.alpha = 0.0;
    } completion:^(BOOL finish){
        //[_floor2Bt removeFromSuperview];
    }];
    
    [UIView  animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor3Bt.transform = CGAffineTransformIdentity;
        _floor3Bt.alpha = 0.0;
    } completion:^(BOOL finish){
        //[_floor3Bt removeFromSuperview];
    }];
    
    [UIView  animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor4Bt.transform = CGAffineTransformIdentity;
        _floor4Bt.alpha = 0.0;
    } completion:^(BOOL finish){
        //[_floor4Bt removeFromSuperview];
    }];
    
    [UIView  animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _floor5Bt.transform = CGAffineTransformIdentity;
        _floor5Bt.alpha = 0.0;
    } completion:^(BOOL finish){
        //[_floor5Bt removeFromSuperview];
    }];
}

- (void)onFloorSwitch:(UIButton *)switchBt
{
    switchBt.selected = !switchBt.selected;
    if (switchBt.selected) {
        [self showFloorSwitch:switchBt];
    }else{
        [self hideFloorBt];
    }
    
    
}

#pragma mark - 用户定位
- (void)initializeUser
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locateUser:) name:@"DataManagerLocate" object:nil];
    _user = [[UserPositionView alloc] init];
    _user.center = CGPointMake(-1000, -1000);
    _user.alpha = 0.0f;
    [_floorMap addSubview:_user];
    
//    _testLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 300, 100)];
//    _testLabel.textColor = [UIColor blackColor];
//    _testLabel.numberOfLines = 0;
//    _testLabel.text = @"定位信息:\r\n";
//    [self.view addSubview:_testLabel];
    
}

- (void)locateUser:(NSNotification *)notification
{
    LocateItem *locateItem = notification.userInfo[@"locateItem"];
    [_floorMap bringSubviewToFront:_user];
    [self switchMapWithFloorType:locateItem.floorType];
    _user.center = locateItem.pt;

    
//    NSString *message =  [_testLabel.text stringByAppendingString:locateItem];
//    message = [message stringByAppendingString:@"\r\n"];
//    _testLabel.text = message;
    
}


@end
