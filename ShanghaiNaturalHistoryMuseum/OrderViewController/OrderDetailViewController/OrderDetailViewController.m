//
//  OrderDetailViewController.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-28.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailView.h"
#import "FilmItem.h"
#import "ActivityItem.h"
#import "DataManager.h"
#import "PublicMethod.h"
#import "ScheduleItem.h"
#import "SystemManagerViewController.h"


@interface OrderDetailViewController () <UIScrollViewDelegate>{
    IBOutlet UIScrollView *detailScrollView;
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    NSArray *currentSchdules;
    OrderDetailView *currecntDetailView;
}



@end

@implementation OrderDetailViewController

@synthesize originalIndex,detailDataArray;

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
    
    detailScrollView.layer.cornerRadius=10;
    detailScrollView.layer.masksToBounds=YES;
    
    detailScrollView.delegate = self;
    detailScrollView.contentSize = CGSizeMake(detailScrollView.frame.size.width * detailDataArray.count,detailScrollView.frame.size.height);
    recycledPages=[[NSMutableSet alloc] init];
    visiblePages =[[NSMutableSet alloc] init];
    
    [detailScrollView scrollRectToVisible:CGRectMake(detailScrollView.frame.size.width*originalIndex,0,detailScrollView.frame.size.width,detailScrollView.frame.size.height) animated:NO];
    [self tilePages];



}

#pragma mark -scrollViewDelegate
//视图滑动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tilePages];
    if (scrollView.contentOffset.x>scrollView.frame.size.width*([detailDataArray count])+100) {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width*0,0,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];
    }
    
}


#pragma mark-scrollView重用机制-
- (void)tilePages
{
    // Calculate which pages are visible
    CGRect visibleBounds =detailScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [detailDataArray count] - 1);
    
    // Recycle no-longer-visible pages
    for (OrderDetailView *page in visiblePages) {
        if (page.tag < firstNeededPageIndex || page.tag > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            OrderDetailView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[OrderDetailView alloc] initWithFrame:detailScrollView.bounds];
            }
            [self configurePage:page forIndex:index];
            [detailScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
    
}

- (OrderDetailView *)dequeueRecycledPage
{
    OrderDetailView *page = [recycledPages anyObject];
    if (page) {
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (OrderDetailView *page in visiblePages) {
        if (page.tag == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(OrderDetailView *)page forIndex:(NSUInteger)index
{
    [DataManager postPreorderBrowseCountWithItem:[detailDataArray objectAtIndex:index] callback:nil];
    page.hidden=YES;
    originalIndex=index;
    page.tag = index;
    id item=[detailDataArray objectAtIndex:index];
    if ([item isKindOfClass:[FilmItem class]]) {
        [DataManager loadSchedulesWithItem:(FilmItem *)item user:[DataManager getUser] callback:^(NSArray *schudules, BOOL success) {
            if (success && schudules.count>0) {
                currentSchdules=[NSArray arrayWithArray:schudules];
                NSMutableDictionary *timePlaceDic=[[NSMutableDictionary alloc] init];
                NSString *firstAddress;
                for (int i=0;i<schudules.count;i++) {
                    
                    ScheduleItem *sch=(ScheduleItem *)[schudules objectAtIndex:i];
                    
                    NSString *key=[NSString stringWithFormat:@"%i",i];
                    NSString *value=[NSString stringWithFormat:@"%@,%@,%@,%@",sch.beginTime,sch.address,sch.bookNum,sch.bookCode];
                    if (i==0) {
                        firstAddress=sch.address;
                    }
                    [timePlaceDic setObject:value forKey:key];
                }
                
                page.titleLabel.text=[(FilmItem *)item name];
                NSString *content;
                if ([(FilmItem *)item introduction].length==0) {
                    content=@"主要内容：暂无";
                } else {
                    content=[NSString stringWithFormat:@"主要内容：%@",[(FilmItem *)item introduction]];
                }
                [page.contentLabel setText:content
                                  WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                  AndColor:[UIColor grayColor]];
                [page.contentLabel setKeyWordTextString:@"主要内容："
                                               WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                               AndColor:[UIColor darkGrayColor]];
                page.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
                [DataManager loadPicWithPath:[(FilmItem *)item titlePic] inView:page.iconImageView callback:^(UIImage *image, BOOL userCache, BOOL success) {
                    if (success && image) {
                        page.iconImageView.alpha=0;
                        [UIView animateWithDuration:0.25f
                                         animations:^{
                                             page.iconImageView.image=image;
                                             page.iconImageView.alpha=1.0f;
                                         } completion:nil];
                    }
                }];
                page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",[(FilmItem *)item bookNum],[(FilmItem *)item browseNum]];
                if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                    page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                }
                [page.orderButton addTarget:self
                                     action:@selector(clickedOrderBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
                [page.loginButton addTarget:self
                                     action:@selector(clickedLoginBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
                [page.mapButton addTarget:self
                                   action:@selector(clickedBtn:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                page.successfulView.hidden=YES;
                page.unsuccessfulView.hidden=NO;
                page.statusImageView.hidden=YES;
                page.timeAndPalceDic=[NSDictionary dictionaryWithDictionary:timePlaceDic];
                [page.unsuccessfulPlaceLabel setText:[NSString stringWithFormat:@"地点             %@",firstAddress]
                                            WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                            AndColor:[UIColor grayColor]];
                [page.unsuccessfulPlaceLabel setKeyWordTextString:@"地点"
                                                         WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                         AndColor:ORDERVIEW_THEME_GREEN_COLOR];
                page.orderNumView.currentNumber=1;
                page.hidden=NO;

                if (![DataManager getUser]) {
                    page.orderButton.hidden=YES;
                    page.loginButton.hidden=NO;
                    
                    return;
                }
                [DataManager loadFilmWithScheduleItem:schudules[0] user:[DataManager getUser] callback:^(FilmItem *filmItem, BOOL success) {
                    if (success) {
                        
                        page.orderButton.hidden=NO;
                        page.loginButton.hidden=YES;
                        page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",[(FilmItem *)filmItem bookNum],[(FilmItem *)filmItem browseNum]];
                        if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                            page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                        }

                    }
                }];
            }
        }];
        

    } else if ([item isKindOfClass:[ActivityItem class]]) {
        [DataManager loadSchedulesWithItem:(ActivityItem *)item user:[DataManager getUser] callback:^(NSArray *schudules, BOOL success) {
            if (success && schudules.count>0) {
                NSString *firstAddress;
                currentSchdules=[NSArray arrayWithArray:schudules];
                NSMutableDictionary *timePlaceDic=[[NSMutableDictionary alloc] init];
                for (int i=0;i<schudules.count;i++) {
                    ScheduleItem *sch=(ScheduleItem *)[schudules objectAtIndex:i];
                    NSString *key=[NSString stringWithFormat:@"%i",i];
                    NSString *value=[NSString stringWithFormat:@"%@,%@,%@,%@",sch.beginTime,sch.address,sch.bookNum,sch.bookCode];
                    if (i==0) {
                        firstAddress=sch.address;
                    }
                    [timePlaceDic setObject:value forKey:key];
                }
                
                page.titleLabel.text=[(ActivityItem *)item name];
                NSString *content;
                if ([(ActivityItem *)item contents].length==0) {
                    content=@"主要内容：暂无";
                } else {
                    content=[NSString stringWithFormat:@"主要内容：%@",[(ActivityItem *)item contents]];
                }
                [page.contentLabel setText:content
                                  WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                  AndColor:[UIColor grayColor]];
                [page.contentLabel setKeyWordTextString:@"主要内容："
                                               WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                               AndColor:[UIColor darkGrayColor]];
                page.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
                [DataManager loadPicWithPath:[(ActivityItem *)item titlePic] inView:page.iconImageView callback:^(UIImage *image, BOOL userCache, BOOL success) {
                    if (success && image) {
                        page.iconImageView.alpha=0;
                        [UIView animateWithDuration:0.25f
                                         animations:^{
                                             page.iconImageView.image=image;
                                             page.iconImageView.alpha=1.0f;
                                         } completion:nil];
                    }
                }];
                page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",[(ActivityItem *)item bookNum],[(ActivityItem *)item browseNum]];
                if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                    page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                }
                [page.orderButton addTarget:self
                                     action:@selector(clickedOrderBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
                [page.loginButton addTarget:self
                                     action:@selector(clickedLoginBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
                [page.mapButton addTarget:self
                                   action:@selector(clickedBtn:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                page.successfulView.hidden=YES;
                page.unsuccessfulView.hidden=NO;
                 page.statusImageView.hidden=YES;
                page.timeAndPalceDic=[NSDictionary dictionaryWithDictionary:timePlaceDic];
                [page.unsuccessfulPlaceLabel setText:[NSString stringWithFormat:@"地点             %@",firstAddress]
                                            WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                            AndColor:[UIColor grayColor]];
                [page.unsuccessfulPlaceLabel setKeyWordTextString:@"地点"
                                                         WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                         AndColor:ORDERVIEW_THEME_GREEN_COLOR];
                page.orderNumView.currentNumber=1;
                page.hidden=NO;
                if (![DataManager getUser]) {
                    page.orderButton.hidden=YES;
                    page.loginButton.hidden=NO;
                    
                    return;
                }
                
                [DataManager loadActivityWithScheduleItem:schudules[0] user:[DataManager getUser] callback:^(ActivityItem *activityItem, BOOL success) {
                    if (success) {
                        page.orderButton.hidden=NO;
                        page.loginButton.hidden=YES;
                        page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",[(ActivityItem *)activityItem bookNum],[(ActivityItem *)activityItem browseNum]];
                        if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                            page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                        }
                    }
                }];
            }
        }];
    } else {
        [DataManager loadSchedulesWithItem:(OrderItem *)item user:[DataManager getUser] callback:^(NSArray *schudules, BOOL success) {
             page.statusImageView.hidden=NO;
            if (success && schudules.count>0) {
                 ScheduleItem *sch=(ScheduleItem *)[schudules objectAtIndex:0];
            
                if ([item preorderType]==PreorderFilm) {
                    [DataManager loadFilmWithScheduleItem:sch user:[DataManager getUser] callback:^(FilmItem *filmItem, BOOL success) {
                        if (success) {
                            page.titleLabel.text=filmItem.name;
                            NSString *content;
                            if (filmItem.introduction.length==0) {
                                content=@"主要内容：暂无";
                            } else {
                                content=[NSString stringWithFormat:@"主要内容：%@",filmItem.introduction];
                            }
                            [page.contentLabel setText:content
                                              WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                              AndColor:[UIColor grayColor]];
                            [page.contentLabel setKeyWordTextString:@"主要内容："
                                                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                           AndColor:[UIColor darkGrayColor]];
                            page.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
                            [DataManager loadPicWithPath:[filmItem titlePic] inView:page.iconImageView callback:^(UIImage *image, BOOL userCache, BOOL success) {
                                if (success && image) {
                                    page.iconImageView.alpha=0;
                                    [UIView animateWithDuration:0.25f
                                                     animations:^{
                                                         page.iconImageView.image=image;
                                                         page.iconImageView.alpha=1.0f;
                                                     } completion:nil];
                                }
                            }];
                            page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",filmItem.bookNum,filmItem.browseNum];
                            if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                                page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                            }
                            
                                        
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
                            NSString *day=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
                            NSString *beginString=[NSString stringWithFormat:@"%@ %@:00",day,filmItem.playBeginTime];
                            NSDate *startDate=[dateFormatter dateFromString:beginString];
                            NSTimeInterval time=[startDate timeIntervalSinceNow];
                            CGFloat movieTime=[[[filmItem.playTime componentsSeparatedByString:@"分"] objectAtIndex:0] floatValue] * 60;
                            if (time+movieTime<0) {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_end.png"];
                            } else if (time+movieTime>=0 && time+movieTime<=movieTime) {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_running.png"];
                            } else {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_notstart.png"];
                            }

                        }
                    }];
                }
                else {
                    [DataManager loadActivityWithScheduleItem:sch user:[DataManager getUser] callback:^(ActivityItem *activityItem, BOOL success) {
                        if (success) {
                            page.titleLabel.text=activityItem.name;
                            NSString *content;
                            if (activityItem.contents.length==0) {
                                content=@"主要内容：暂无";
                            } else {
                                content=[NSString stringWithFormat:@"主要内容：%@",activityItem.contents];
                            }
                            [page.contentLabel setText:content
                                              WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                              AndColor:[UIColor grayColor]];
                            [page.contentLabel setKeyWordTextString:@"主要内容："
                                                           WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                           AndColor:[UIColor darkGrayColor]];
                            page.iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
                            [DataManager loadPicWithPath:[activityItem titlePic] inView:page.iconImageView callback:^(UIImage *image, BOOL userCache, BOOL success) {
                                if (success && image) {
                                    page.iconImageView.alpha=0;
                                    [UIView animateWithDuration:0.25f
                                                     animations:^{
                                                         page.iconImageView.image=image;
                                                         page.iconImageView.alpha=1.0f;
                                                     } completion:nil];
                                }
                            }];
                            page.peopleLabel.text=[NSString stringWithFormat:@"已有%@人预约    浏览%@次",activityItem.bookNum,activityItem.browseNum];
                            if ([page.peopleLabel.text rangeOfString:@"(null)"].length>0) {
                                page.peopleLabel.text=[page.peopleLabel.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                            }
                            
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//大小写严格区分
                            NSString *day=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0];
                            NSString *beginString=[NSString stringWithFormat:@"%@ %@:00",day,activityItem.beginTime];
                            NSString *endString=[NSString stringWithFormat:@"%@ %@:00",day,activityItem.endTime];
                            NSDate *startDate=[dateFormatter dateFromString:beginString];
                            NSDate *endDate=[dateFormatter dateFromString:endString];
                            if ([endDate timeIntervalSinceNow]<0) {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_end.png"];
                            } else if ([endDate timeIntervalSinceNow]>=0 && [startDate timeIntervalSinceNow]<=0) {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_running.png"];
                            } else {
                                page.statusImageView.image=[UIImage imageNamed:@"order_status_notstart.png"];
                            }

                        }
                    }];
                }
                [page.successfulTimeLabel setText:[NSString stringWithFormat:@"时间： %@",sch.beginTime]
                                         WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                         AndColor:[UIColor grayColor]];
                [page.successfulTimeLabel setKeyWordTextString:@"时间："
                                                      WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                      AndColor:[UIColor darkGrayColor]];
                [page.successfulPlaceLabel setText:[NSString stringWithFormat:@"地点： %@",sch.address]
                                          WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                          AndColor:[UIColor grayColor]];
                [page.successfulPlaceLabel setKeyWordTextString:@"地点："
                                                       WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                       AndColor:[UIColor darkGrayColor]];
                
                NSLog(@"codeeee====%@",sch.bookCode);
                
                page.codeLabel.text=[page.codeLabel.text stringByReplacingOccurrencesOfString:@"#####" withString:[NSString stringWithFormat:@"%@",[item bookCode]]];
                [page.mapButton addTarget:self
                                   action:@selector(clickedBtn:)
                         forControlEvents:UIControlEventTouchUpInside];
                page.orderButton.hidden=YES;
                page.successfulView.hidden=NO;
                page.unsuccessfulView.hidden=YES;
                page.hidden=NO;
            }
        }];
    }
   
    
  
    page.frame =CGRectMake(detailScrollView.frame.size.width*index, 0, detailScrollView.frame.size.width,detailScrollView.frame.size.height);
    currecntDetailView=page;

}


-(IBAction)clickedLoginBtn:(UIButton *)sender {
#warning  进入登录界面，但返回到地图会报错，需修改
    SystemManagerViewController *managerVC = [[SystemManagerViewController alloc] initWithNibName:@"SystemManagerViewController" bundle:nil];
    [self.parentViewController.navigationController pushViewController:managerVC animated:YES];
}
-(IBAction)clickedOrderBtn:(UIButton *)sender {
    [DataManager loadPreorderWithScheduleItem:[currentSchdules objectAtIndex:sender.tag]
                                         user:[DataManager getUser]
                                          num:[NSNumber numberWithInteger:currecntDetailView.orderNumView.currentNumber]
                                     callback:^(NSString *code, BOOL success) {
                                         if (success) {
                                             self.didOrderSuccess();
                                             [PublicMethod HUDOnlyLabelForView:self.view.window withMessage:@"预约成功"];
                                             [UIView animateWithDuration:0.25f
                                                              animations:^{
                                                                  self.view.alpha=0;
                                                              }
                                                              completion:^(BOOL finished) {
                                                                  [self.view removeFromSuperview];
                                                                  [self willMoveToParentViewController:nil];
                                                                  [self removeFromParentViewController];
                                                              }];
                                             
                                         } else {
                                             [PublicMethod HUDOnlyLabelForView:self.view.window withMessage:@"预约失败，请检查网络链接重试"];
                                         }
                                     }];

}
-(IBAction)clickedBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            [UIView animateWithDuration:0.25f
                             animations:^{
                                 self.view.alpha=0;
                             }
                             completion:^(BOOL finished) {
                                 [self.view removeFromSuperview];
                                 [self willMoveToParentViewController:nil];
                                 [self removeFromParentViewController];
                             }];
        }
            break;
        case 2:
             [detailScrollView scrollRectToVisible:CGRectMake(detailScrollView.frame.size.width*(originalIndex-1),0,detailScrollView.frame.size.width,detailScrollView.frame.size.height) animated:YES];
            break;
        case 3:
           [detailScrollView scrollRectToVisible:CGRectMake(detailScrollView.frame.size.width*(originalIndex+1),0,detailScrollView.frame.size.width,detailScrollView.frame.size.height) animated:YES];
            break;
        case 5:{
            NSLog(@"---------查看地图");
#warning 活动不知道用哪个type
            InfoItem *infoItem=[[InfoItem alloc] init];
            id item=[detailDataArray objectAtIndex:currecntDetailView.tag];
            if ([item isKindOfClass:[FilmItem class]]) {
                infoItem.title=[(FilmItem *)item name];
                infoItem.iconPath=[(FilmItem *)item titlePic];
                infoItem.type=InfoItemCinema;
                infoItem.relationId=[(FilmItem *)item sid];
            } else if ([item isKindOfClass:[ActivityItem class]]) {
                infoItem.title=[(ActivityItem *)item name];
                infoItem.iconPath=[(ActivityItem *)item titlePic];
                infoItem.type=InfoItemCinema;
                infoItem.relationId=[(ActivityItem *)item sid];
            } else {
                if ([(OrderItem *)item preorderType]==PreorderFilm) {
                     infoItem.type=InfoItemCinema;
                } else {
                     infoItem.type=InfoItemCinema;
                }
               
                infoItem.relationId=[(OrderItem *)item cid];
            }
            
            self.showInMap(infoItem);
            
        }
            break;
        default:
            break;
    }
}

-(void)reloadCurrentUI {
    [self configurePage:currecntDetailView forIndex:currecntDetailView.tag];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
