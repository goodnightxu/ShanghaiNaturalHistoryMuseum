//
//  OrderHeaderView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-25.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverButton.h"

@protocol OrderHeaderViewDelegate <NSObject>

-(void)didSelectHeaderViewForItem:(NSString *)item;

@end



@interface OrderHeaderView : UIView<PopoverButtonDelegate>

@property(nonatomic,assign)NSInteger eventCount;
@property(nonatomic,strong)NSArray *eventDataArray;
@property(nonatomic,weak)id<OrderHeaderViewDelegate>delegate;
@property(nonatomic,strong)PopoverButton *eventBtn;
@property(nonatomic,strong)UIButton *movieBtn;
@property(nonatomic,strong)UIButton *myOrderBtn;

@end




