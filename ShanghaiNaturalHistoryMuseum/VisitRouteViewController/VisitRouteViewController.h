//
//  VisitRouteViewController.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-3.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VisitRouteViewControllerDelegate <NSObject>

-(void)needShowRoute:(NSArray *)infoItemsData title:(NSString *)title originalData:(NSArray *)datas;

@end

@interface VisitRouteViewController : UIViewController

@property(nonatomic,weak)id<VisitRouteViewControllerDelegate>delegate;
@property(nonatomic,assign)NSInteger floor;

@end
