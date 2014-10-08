//
//  OrderDetailView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-28.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"
#import "OrderPeopleNumberView.h"

@interface OrderDetailView : UIView {
    UILabel *label2;
}

//共有的
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)DetailTextView *contentLabel;
@property(nonatomic,strong)UILabel *peopleLabel;
@property(nonatomic,strong)UIButton *orderButton;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIImageView *statusImageView;
@property(nonatomic,strong)UIButton *mapButton;

//预约成功显示的
@property(nonatomic,strong)UIView *successfulView;
@property(nonatomic,strong)DetailTextView *successfulTimeLabel;
@property(nonatomic,strong)DetailTextView *successfulPlaceLabel;
@property(nonatomic,strong)UILabel *codeLabel;

//未预约显示的
@property(nonatomic,strong)UIView *unsuccessfulView;
@property(nonatomic,strong)NSDictionary *timeAndPalceDic;
@property(nonatomic,copy,readonly)NSString *orderedTime;
@property(nonatomic,strong)DetailTextView *unsuccessfulPlaceLabel;
@property(nonatomic,strong)OrderPeopleNumberView *orderNumView;


@end
