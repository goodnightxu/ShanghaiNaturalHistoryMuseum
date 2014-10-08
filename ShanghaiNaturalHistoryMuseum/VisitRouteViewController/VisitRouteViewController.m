//
//  VisitRouteViewController.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-3.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "VisitRouteViewController.h"
#import "CreateRouteTableView.h"
#import "PublicMethod.h"
#import "SearchRouteTableView.h"
#import "MyVisitRouteView.h"
#import "DataManager.h"
#import "RecommendRouteItem.h"
#import "InfoItem.h"
#import "ShakeAndDeleteView.h"

@interface VisitRouteViewController ()<CreateRouteTableViewDelegate,SearchRouteTableViewDelegate,ShakeAndDeleteViewDelegate,MyVisitRouteViewDelegate> {
    IBOutlet UIButton *createRouteBtn;
    IBOutlet UIView *rightView;
    IBOutlet UIView *leftView;
    IBOutlet UIScrollView *myRouteScrollView;
    IBOutlet UILabel *rightLabel1;
    IBOutlet UILabel *rightLabel2;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIButton *doneButton;
    CreateRouteTableView *facilityTableView;
    CreateRouteTableView *crTableView;
    SearchRouteTableView *srTableView;
    
    NSMutableArray *myRouteDataArray;
    NSMutableArray *twoRecommendRouteItems;
    NSInteger allowedRouteCount;
    
}

@end

@implementation VisitRouteViewController

@synthesize delegate;
@synthesize floor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)dealloc {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DataManager loadPraiseRoute:^(NSArray *infos, BOOL success) {
        if (success) {
            MyVisitRouteView *hotView=[[MyVisitRouteView alloc] initWithFrame:CGRectMake(21, 0, 221+8+18,leftView.frame.size.height-10) withHeaderName:@"最热门\n参观路线" data:infos];
            hotView.delegate1=self;
            hotView.tag=111;
            hotView.canShake=NO;
            [leftView addSubview:hotView];
        }
    }];
    
    
    myRouteDataArray=[[NSMutableArray alloc] init];
    
    twoRecommendRouteItems=[[NSMutableArray alloc] init];
    [DataManager loadRecommendRoutes:^(NSArray *routes, BOOL success) {
        if (success) {
            allowedRouteCount=routes.count+3;
            
            NSMutableArray *titles=[[NSMutableArray alloc] init];
            for (int i=0; i<routes.count; i++) {
                RecommendRouteItem *recommendItem=[routes objectAtIndex:i];
                
                [myRouteDataArray insertObject:recommendItem.routesRooms atIndex:i];
                [titles addObject:recommendItem.title];
                [twoRecommendRouteItems addObject:recommendItem];
            }
            
            for (int i=0; i<myRouteDataArray.count; i++) {
                //18是tableview距离右边间距，8是因为要加上borderWidth,borderWidth向view里面延生
                MyVisitRouteView *myRouteView=[[MyVisitRouteView alloc] initWithFrame:CGRectMake(6+241*i, 0, 221+18+8,myRouteScrollView.frame.size.height-10) withHeaderName:[titles objectAtIndex:i] data:[myRouteDataArray objectAtIndex:i]];
                myRouteView.delegate1=self;
                myRouteView.tag=i;
                myRouteView.canShake=NO;
                [myRouteScrollView addSubview:myRouteView];
                if (i==myRouteDataArray.count-1) {
                    myRouteScrollView.contentSize=CGSizeMake(myRouteView.frame.origin.x+myRouteView.frame.size.width-11, myRouteScrollView.frame.size.height);
                }
            }
        }
    }];
    
    
    //    srTableView=[[SearchRouteTableView alloc] initWithFrame:CGRectMake(1024-253, 3, 253, self.view.frame.size.height-416-3+self.navigationController.navigationBar.frame.size.height*2)];
    srTableView=[[SearchRouteTableView alloc] initWithFrame:CGRectMake(1024-253, kNavBarHeight, 253, 261+44)];
    srTableView.hidden=YES;
    srTableView.delegate1=self;
    [self.view addSubview:srTableView];
    
    
    rightLabel1.font=[UIFont fontWithName:LanTingHei size:24.0f];
    rightLabel2.font=[UIFont fontWithName:LanTingHei size:14.0f];
    doneButton.titleLabel.font=[UIFont fontWithName:LanTingHei size:14.0f];
    createRouteBtn.titleLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
    
    
    crTableView=[[CreateRouteTableView alloc] initWithFrame:CGRectMake(0, 202, rightView.frame.size.width, 333)];
    crTableView.backgroundColor=[UIColor clearColor];
    crTableView.delegate1=self;
    InfoItem *item0=[[InfoItem alloc] init];
    item0.title=@"0";
    InfoItem *itemLast=[[InfoItem alloc] init];
    itemLast.title=@"last";
    crTableView.dataArray=[NSMutableArray arrayWithObjects:item0,itemLast, nil];
    [rightView addSubview:crTableView];
    
    
    facilityTableView=[[CreateRouteTableView alloc] initWithFrame:CGRectMake(0, 202, rightView.frame.size.width, 333)];
    InfoItem *item1=[[InfoItem alloc] init];
    item1.title=@"0";
    facilityTableView.dataArray=[NSMutableArray arrayWithObjects:item1, nil];
    facilityTableView.delegate1=self;
    facilityTableView.tag=1;
    facilityTableView.hidden=YES;
    [rightView addSubview:facilityTableView];
    
    [self.view sendSubviewToBack:srTableView];
    
    [self configNavigationBar];
    
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

-(IBAction)didClickBtn:(UIButton *)sender {
    if (sender.tag==1) {//结束抖动的完成按钮
        doneButton.hidden=YES;
        crTableView.userInteractionEnabled=YES;
        facilityTableView.userInteractionEnabled=YES;
        for (MyVisitRouteView *routeView in myRouteScrollView.subviews) {
            if ([routeView isKindOfClass:[MyVisitRouteView class]]) {
                [routeView stopShake];
            }
        }
    } else if (sender.tag==2) {//右侧生成路线按钮
        NSMutableArray *dataArray;
        if (segment.selectedSegmentIndex==0) {
            dataArray=[NSMutableArray arrayWithArray:crTableView.dataArray];
        } else {
            dataArray=[NSMutableArray arrayWithArray:facilityTableView.dataArray];
        }
        [dataArray removeObjectAtIndex:0];
        InfoItem *item=[dataArray lastObject];
        if ([item.title isEqualToString:@"last"]) {
            [dataArray removeLastObject];
        }
        
        if (dataArray.count==0) {
            [self BackgroundTaped];
            [PublicMethod HUDOnlyLabelForView:self.view
                                  withMessage:@"请至少添加一个目标"];
        } else {
            segment.selectedSegmentIndex=0;
            [self didClickSegment:segment];
            
            if (myRouteDataArray.count==allowedRouteCount) {
                [self BackgroundTaped];
                //                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"您已保存3条自定义路线，请删除至少一条来保存新的路线。"
                //                                                              message:nil
                //                                                             delegate:self
                //                                                    cancelButtonTitle:@"知道了"
                //                                                    otherButtonTitles:nil, nil];
                //                [alert show];
                [PublicMethod HUDOnlyLabelForView:self.view
                                      withMessage:@"您已保存3条自定义路线，请删除至少一条来保存新的路线。"];
                CGRect rect=myRouteScrollView.frame;
                [myRouteScrollView scrollRectToVisible:CGRectMake(rect.size.width*1, 0, rect.size.width, rect.size.height)
                                              animated:YES];
                for (MyVisitRouteView *routeView in myRouteScrollView.subviews) {
                    if ([routeView isKindOfClass:[MyVisitRouteView class]]) {
                        [routeView startShake];
                    }
                }
                doneButton.hidden=NO;
                crTableView.userInteractionEnabled=NO;
                facilityTableView.userInteractionEnabled=NO;
            } else {
                
                [myRouteDataArray addObject:dataArray];
                NSInteger index=myRouteDataArray.count-1;
                
                NSMutableArray *titleArray=[[NSMutableArray alloc] init];
                for (MyVisitRouteView *route in myRouteScrollView.subviews) {
                    if ([route isKindOfClass:[MyVisitRouteView class]]) {
                        [titleArray addObject:route.title];
                    }
                }
                NSString *title;
                if (![titleArray containsObject:@"我的路线1"]) {
                    title = @"我的路线1";
                } else if (![titleArray containsObject:@"我的路线2"]) {
                    title = @"我的路线2";
                } else if (![titleArray containsObject:@"我的路线3"]) {
                    title = @"我的路线3";
                }
                
                CGRect rect=myRouteScrollView.frame;
                
                MyVisitRouteView *myRouteView=[[MyVisitRouteView alloc] initWithFrame:CGRectMake(6+241*index, 0, 221+18+8,myRouteScrollView.frame.size.height-10) withHeaderName:title data:[myRouteDataArray objectAtIndex:index]];
                myRouteView.delegate=self;
                myRouteView.delegate1=self;
                myRouteView.tag=index;
                [myRouteScrollView addSubview:myRouteView];
                
                myRouteScrollView.contentSize=CGSizeMake(myRouteView.frame.origin.x+myRouteView.frame.size.width-11, myRouteScrollView.frame.size.height);
                [myRouteScrollView scrollRectToVisible:CGRectMake(rect.size.width*(index-1)/2, 0, rect.size.width, rect.size.height)
                                              animated:YES];
#warning 上传我的路线没做

            }
            
        }
    }
}

-(IBAction)didClickSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        CGRect rect=srTableView.frame;
        rect.size.height=261+44;
        srTableView.frame=rect;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             srTableView.frame=CGRectMake(1024-3-rightView.frame.size.width, kNavBarHeight, srTableView.frame.size.width, 261+44);
                         } completion:^(BOOL finished) {
                             if (segment.selectedSegmentIndex==0) {
                                 srTableView.hidden=YES;
                             }
                             
                         }];
        crTableView.hidden=NO;
        facilityTableView.hidden=YES;
    } else {
        [self BackgroundTaped];
        [DataManager loadFacilityWithFloor:floor
                                     point:CGPointMake(200, 200)
                                  callback:^(NSArray *facilities, BOOL success) {
                                      if (success && facilities.count>0) {
                                          srTableView.dataArray=[NSArray arrayWithArray:facilities];
                                          [srTableView reloadData];
                                          srTableView.hidden=NO;
                                          [self.view bringSubviewToFront:srTableView];
                                          [self.view bringSubviewToFront:rightView];
                                          CGRect rect=srTableView.frame;
                                          rect.size.height=261+397;
                                          srTableView.frame=rect;
                                          [UIView animateWithDuration:DURATION
                                                           animations:^(void) {
                                                               srTableView.frame=CGRectMake(1024-3-rightView.frame.size.width-srTableView.frame.size.width, kNavBarHeight, srTableView.frame.size.width, 261+397);
                                                           } completion:^(BOOL finished) {
                                                               
                                                           }];
                                          crTableView.hidden=YES;
                                          facilityTableView.hidden=NO;
                                      } else {
                                          [PublicMethod HUDOnlyLabelForView:self.view
                                                                withMessage:@"无公共设施"];
                                      }
                                  }];
        
    }
    
}

-(IBAction)BackgroundTaped {
    [PublicMethod resignKeyBoardInView:self.view];
    [self moveInputBarWithKeyboardHeight:3];
}

-(void)moveInputBarWithKeyboardHeight:(int)height
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:DURATION];
    rightView.frame = CGRectMake(rightView.frame.origin.x, kNavBarHeight-3+height, rightView.frame.size.width, rightView.frame.size.height);
    [UIView commitAnimations];
}

#pragma CreateRouteTableViewDelegate
-(void)nameTextFieldDidBeginEditing:(UITextField *)textField {
    [self moveInputBarWithKeyboardHeight:-140-textField.tag*35];
}
-(void)nameTextFieldDidEndEditing:(UITextField *)textField {
    [self moveInputBarWithKeyboardHeight:3];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         srTableView.frame=CGRectMake(1024-3-rightView.frame.size.width, kNavBarHeight, srTableView.frame.size.width,261+44);
                     } completion:^(BOOL finished) {
                         if (segment.selectedSegmentIndex==0) {
                             srTableView.hidden=YES;
                         }
                     }];
}

-(void)nameTextFieldDidInput:(UITextField *)textField {
    if (textField.text.length>0) {
        [DataManager loadRouteWithKeyword:textField.text
                                 callback:^(NSArray *infos, BOOL success) {
                                     if (success) {
                                         srTableView.dataArray=[NSArray arrayWithArray:infos];
                                         [srTableView reloadData];
                                         srTableView.hidden=NO;
                                         [self.view bringSubviewToFront:srTableView];
                                         [self.view bringSubviewToFront:rightView];
                                         CGRect rect=srTableView.frame;
                                         rect.size.height=261+44;
                                         srTableView.frame=rect;
                                         [UIView animateWithDuration:DURATION
                                                          animations:^(void) {
                                                              srTableView.frame=CGRectMake(1024-3-rightView.frame.size.width-srTableView.frame.size.width, kNavBarHeight, srTableView.frame.size.width, 261+44);
                                                          } completion:^(BOOL finished) {
                                                              
                                                          }];
                                     }
                                 }];
    } else {
        //        [self nameTextFieldDidEndEditing:textField];
        //        [textField resignFirstResponder];
    }
}


#pragma SearchRouteTableViewDelegate
-(void)didSelectPlaceWithTableView:(UITableView *)tableView infoItem:(InfoItem *)item {
    if (segment.selectedSegmentIndex==0) {
        NSMutableArray *titles=[[NSMutableArray alloc] init];
        for (InfoItem *item1 in crTableView.dataArray) {
            [titles addObject:item1.title];
        }
        
        if ([titles containsObject:item.title]) {
            [self BackgroundTaped];
            [PublicMethod HUDOnlyLabelForView:self.view
                                  withMessage:@"该目标已添加"];
        } else {
            [PublicMethod resignKeyBoardInView:self.view];
            [self nameTextFieldDidEndEditing:nil];
            crTableView.needAddInfo=item;
            [crTableView tableView:crTableView
                commitEditingStyle:UITableViewCellEditingStyleInsert
                 forRowAtIndexPath:[NSIndexPath indexPathForRow:crTableView.dataArray.count-1 inSection:0]];
        }
        
    } else {
        NSMutableArray *titles=[[NSMutableArray alloc] init];
        for (InfoItem *item1 in facilityTableView.dataArray) {
            [titles addObject:item1.title];
        }
        
        if ([titles containsObject:item.title]) {
            [PublicMethod HUDOnlyLabelForView:self.view
                                  withMessage:@"该目标已添加"];
        } else {
            facilityTableView.needAddInfo=item;
            [facilityTableView tableView:facilityTableView
                      commitEditingStyle:UITableViewCellEditingStyleInsert
                       forRowAtIndexPath:[NSIndexPath indexPathForRow:facilityTableView.dataArray.count-1 inSection:0]];
        }
    }
    
}



#pragma ShakeAndDeleteViewDelegate
-(void)willDeleteView:(MyVisitRouteView *)shakeView {//shakeView是id型的，MyVisitRouteView可以随便改，可以改成ShakeAndDeleteView
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGPoint point1=shakeView.center;
                         shakeView.center=CGPointMake(point1.x, point1.y-1000);
                         for (MyVisitRouteView *routeView in myRouteScrollView.subviews) {
                             if (routeView.tag>shakeView.tag) {
                                 CGPoint point=routeView.center;
                                 routeView.center=CGPointMake(point.x-241, point.y);
                             }
                         }
                     } completion:^(BOOL finished) {
                         [shakeView removeFromSuperview];
                         [myRouteDataArray removeObjectAtIndex:shakeView.tag];
                         for (MyVisitRouteView *routeView in myRouteScrollView.subviews) {
                             if (routeView.tag>shakeView.tag) {
                                 routeView.tag=routeView.tag-1;
                             }
                         }
                         
                         //                         CGRect rect=myRouteScrollView.frame;
                         myRouteScrollView.contentSize=CGSizeMake(myRouteScrollView.contentSize.width-241, myRouteScrollView.contentSize.height);
                         if (myRouteDataArray.count==4 || myRouteDataArray.count==3) {
                             //                             [myRouteScrollView scrollRectToVisible:CGRectMake(rect.size.width*1, 0, rect.size.width, rect.size.height)
                             //                                                           animated:YES];
                         } else {
                             //                             [myRouteScrollView scrollRectToVisible:CGRectMake(0, 0, rect.size.width, rect.size.height)
                             //                                                           animated:YES];
                             doneButton.hidden=YES;
                             crTableView.userInteractionEnabled=YES;
                             facilityTableView.userInteractionEnabled=YES;
                         }
                         
                     }];
    
}
-(void)didStartShake:(MyVisitRouteView *)shakeView {
    doneButton.hidden=NO;
    crTableView.userInteractionEnabled=NO;
    facilityTableView.userInteractionEnabled=NO;
}

#pragma MyVisitRouteViewDelegate
-(void)willShowRouteForData:(NSArray *)dataArray routeView:(MyVisitRouteView *)routeView {
    
    if (routeView.tag==111) {//最热路线
        NSLog(@"显示最热门路线");
        [DataManager loadPraiseRouteInfoItems:^(NSArray *infos, BOOL success) {
            if (success) {
                
                
                
                if ([delegate respondsToSelector:@selector(needShowRoute:title:originalData:)]) {
                    [delegate needShowRoute:infos title:routeView.title originalData:dataArray];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
         NSLog(@"显示第%i条路线",routeView.tag+1);
        if ([routeView.title rangeOfString:@"我的"].length<=0) {
            [DataManager loadInfoItemsWithRecommendRoute:[twoRecommendRouteItems objectAtIndex:routeView.tag] callback:^(NSArray *infos, BOOL successs) {
                if (successs) {
                    if ([delegate respondsToSelector:@selector(needShowRoute:title:originalData:)]) {
                        [delegate needShowRoute:infos title:routeView.title originalData:dataArray];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
#warning 定位还没做，没有当前位置，先自己修改point
            [DataManager loadCustomRouteWithFloor:floor point:CGPointMake(1000, 1000) routes:dataArray callback:^(NSArray *infos, BOOL success) {
                if (success) {
                    if ([delegate respondsToSelector:@selector(needShowRoute:title:originalData:)]) {
                        [delegate needShowRoute:infos title:routeView.title originalData:dataArray];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    
}





#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
