//
//  CreateRouteTableView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-3.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"


@protocol CreateRouteTableViewDelegate <NSObject>

-(void)nameTextFieldDidBeginEditing:(UITextField *)textField;
-(void)nameTextFieldDidEndEditing:(UITextField *)textField;
-(void)nameTextFieldDidInput:(UITextField *)textField;

@end


@interface CreateRouteTableView : UITableView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,weak)id<CreateRouteTableViewDelegate>delegate1;
@property(nonatomic,strong)InfoItem *needAddInfo;

@end
