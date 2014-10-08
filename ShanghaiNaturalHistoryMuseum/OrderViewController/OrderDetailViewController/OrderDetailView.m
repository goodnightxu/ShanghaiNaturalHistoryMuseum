//
//  OrderDetailView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-28.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "OrderDetailView.h"

@implementation OrderDetailView

@synthesize titleLabel;
@synthesize iconImageView;
@synthesize contentLabel;
@synthesize peopleLabel;
@synthesize orderButton;
@synthesize statusImageView;
@synthesize mapButton;
@synthesize loginButton;

@synthesize successfulView;
@synthesize successfulTimeLabel;
@synthesize successfulPlaceLabel;
@synthesize codeLabel;

@synthesize unsuccessfulView;
@synthesize timeAndPalceDic;
@synthesize orderedTime;
@synthesize unsuccessfulPlaceLabel;
@synthesize orderNumView;



- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 30, 638-30, 26)];
        titleLabel.font=[UIFont fontWithName:LanTingHei size:24.0f];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        [self addSubview:titleLabel];
        
        contentLabel = [[DetailTextView alloc]initWithFrame:CGRectMake(170, 70, 638-200, 200)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.showShadow=@"NO";
        [self addSubview:contentLabel];
        
        
        successfulView=[[UIView alloc] initWithFrame:CGRectMake(170, 280, contentLabel.frame.size.width, 200)];
        successfulView.backgroundColor=[UIColor clearColor];
        [self addSubview:successfulView];
        
        successfulTimeLabel = [[DetailTextView alloc]initWithFrame:CGRectMake(0, 0, successfulView.frame.size.width, 24)];
        successfulTimeLabel.backgroundColor=[UIColor clearColor];
        successfulTimeLabel.showShadow=@"NO";
        [successfulView addSubview:successfulTimeLabel];
        
        successfulPlaceLabel = [[DetailTextView alloc]initWithFrame:CGRectMake(0, 30, successfulView.frame.size.width, 24)];
        successfulPlaceLabel.backgroundColor=[UIColor clearColor];
        successfulPlaceLabel.showShadow=@"NO";
        [successfulView addSubview:successfulPlaceLabel];
        
        UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, successfulView.frame.size.width, 20)];
        label3.font=[UIFont fontWithName:LanTingHei size:18.0f];
        label3.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        label3.text=@"预约成功！";
        [successfulView addSubview:label3];
        
        codeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 90, successfulView.frame.size.width, 20)];
        codeLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
        codeLabel.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        codeLabel.text=@"预约码： ##### 已保存至我的预约";
        [successfulView addSubview:codeLabel];
        
        UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake(0, 120, successfulView.frame.size.width, 20)];
        label4.font=[UIFont fontWithName:LanTingHei size:18.0f];
        label4.textColor=[UIColor grayColor];
        label4.text=@"请于入场前出示";
        [successfulView addSubview:label4];
        
        
        unsuccessfulView=[[UIView alloc] initWithFrame:CGRectMake(170, 280, contentLabel.frame.size.width, 200)];
        unsuccessfulView.backgroundColor=[UIColor clearColor];
        [self addSubview:unsuccessfulView];
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, unsuccessfulView.frame.size.width, 20)];
        label1.font=[UIFont fontWithName:LanTingHei size:18.0f];
        label1.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        label1.text=@"选择场次";
        [unsuccessfulView addSubview:label1];
        
        unsuccessfulPlaceLabel = [[DetailTextView alloc]initWithFrame:CGRectMake(0, 85, unsuccessfulView.frame.size.width, 24)];
        unsuccessfulPlaceLabel.backgroundColor=[UIColor clearColor];
        unsuccessfulPlaceLabel.showShadow=@"NO";
        [unsuccessfulView addSubview:unsuccessfulPlaceLabel];
        
        label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 120, unsuccessfulView.frame.size.width, 20)];
        label2.font=[UIFont fontWithName:LanTingHei size:18.0f];
        label2.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        label2.text=@"预约人数";
        [unsuccessfulView addSubview:label2];
       
        orderNumView=[[OrderPeopleNumberView alloc] initWithFrame:CGRectMake(100, label2.frame.origin.y-6, 131, 35)];
        [unsuccessfulView addSubview:orderNumView];
        
        
        UIView *downBackView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
        downBackView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0f];
        [self addSubview:downBackView];

        
        peopleLabel=[[UILabel alloc] initWithFrame:CGRectMake(169,0,downBackView.frame.size.width,downBackView.frame.size.height)];
        peopleLabel.textColor=[UIColor grayColor];
        peopleLabel.backgroundColor=[UIColor clearColor];
        peopleLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
        [downBackView addSubview:peopleLabel];
        
        mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame=CGRectMake(30, downBackView.frame.size.height-38, 115, 25);
        [mapButton setImage:[UIImage imageNamed:@"order_seemap.png"] forState:UIControlStateNormal];
        mapButton.tag=5;
        [downBackView addSubview:mapButton];
        
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(30, 70, 120, 85)];
        iconImageView.image=[UIImage imageNamed:@"order_placeholder_image.jpg"];
        iconImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:iconImageView];
        
        
        orderButton=[UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame=CGRectMake(downBackView.frame.size.width-162, downBackView.frame.size.height-45, 163, 45);
        [orderButton setImage:[UIImage imageNamed:@"order_btn.png"] forState:UIControlStateNormal];
        orderButton.tag=4;
        orderButton.hidden=YES;
        [downBackView addSubview:orderButton];
        
        loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame=orderButton.frame;
        [loginButton setImage:[UIImage imageNamed:@"order_login.png"] forState:UIControlStateNormal];
        loginButton.tag=4;
        loginButton.hidden=YES;
        [downBackView addSubview:loginButton];
        
        statusImageView=[[UIImageView alloc] initWithFrame:CGRectMake(468, 370, 164, 106)];
        statusImageView.backgroundColor=[UIColor clearColor];
        statusImageView.hidden=YES;
        [self addSubview:statusImageView];
    }
    return self;
}


-(void)setTimeAndPalceDic:(NSDictionary *)_timeAndPalceDic {
    for (UIButton *btn in unsuccessfulView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    timeAndPalceDic=[NSDictionary dictionaryWithDictionary:_timeAndPalceDic];
    
    NSInteger count=_timeAndPalceDic.count<6 ? _timeAndPalceDic.count : 6;
    
    for (int i=0; i<count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth=2.0f;
        btn.layer.cornerRadius=3;
        btn.layer.masksToBounds=YES;
        btn.tag=i;
        btn.frame=CGRectMake(100+115*(i%3), 2+40*(i/3), 105, 32);
        NSString *title=[[[_timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",i]] componentsSeparatedByString:@","] objectAtIndex:0];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:233/255.0 green:235/255.0 blue:232/255.0 alpha:1.0f]];
        [btn addTarget:self
                action:@selector(clicktTimeBtn:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:LanTingHei size:17.0f]];
        [unsuccessfulView addSubview:btn];
        if (i==0) {
            orderedTime=[btn titleForState:UIControlStateNormal];
            [btn setTitleColor:ORDERVIEW_THEME_GREEN_COLOR forState:UIControlStateNormal];
            btn.layer.borderColor=ORDERVIEW_THEME_GREEN_COLOR.CGColor;
            
            NSString *place=[[[_timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",i]] componentsSeparatedByString:@","] objectAtIndex:1];
            [self.unsuccessfulPlaceLabel setText:[NSString stringWithFormat:@"地点             %@",place]
                                        WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                        AndColor:[UIColor grayColor]];
            [self.unsuccessfulPlaceLabel setKeyWordTextString:@"地点"
                                                     WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                                     AndColor:ORDERVIEW_THEME_GREEN_COLOR];
            NSString *bookCode=[[[timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",i]] componentsSeparatedByString:@","] objectAtIndex:3];
            if ([bookCode rangeOfString:@"null"].length>0) {
                orderButton.enabled=YES;
                orderButton.tag=0;
            } else {
                orderButton.enabled=NO;
            }
            
            NSString *booknum=[[[timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",i]] componentsSeparatedByString:@","] objectAtIndex:2];
            NSString *string1= [[peopleLabel.text componentsSeparatedByString:@"人"] objectAtIndex:1];
            if ([booknum rangeOfString:@"null"].length>0) {
                peopleLabel.text=[NSString stringWithFormat:@"已有0人%@",string1];
            } else {
                peopleLabel.text=[NSString stringWithFormat:@"已有%@人%@",booknum,string1];
            }
        }
    }
    
    if (count>=4) {
        unsuccessfulPlaceLabel.frame=CGRectMake(unsuccessfulPlaceLabel.frame.origin.x, 85, unsuccessfulPlaceLabel.frame.size.width, unsuccessfulPlaceLabel.frame.size.height);
        label2.frame=CGRectMake(label2.frame.origin.x, 120, label2.frame.size.width, label2.frame.size.height);
        orderNumView.frame=CGRectMake(orderNumView.frame.origin.x, label2.frame.origin.y-6, orderNumView.frame.size.width, orderNumView.frame.size.height);
    } else {
        unsuccessfulPlaceLabel.frame=CGRectMake(unsuccessfulPlaceLabel.frame.origin.x, 55, unsuccessfulPlaceLabel.frame.size.width, unsuccessfulPlaceLabel.frame.size.height);
        label2.frame=CGRectMake(label2.frame.origin.x, 100, label2.frame.size.width, label2.frame.size.height);
        orderNumView.frame=CGRectMake(orderNumView.frame.origin.x, label2.frame.origin.y-6, orderNumView.frame.size.width, orderNumView.frame.size.height);
    }
    
}

-(void)clicktTimeBtn:(UIButton *)sender {
    for (UIButton *btn in unsuccessfulView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        }
    }
    orderedTime=[sender titleForState:UIControlStateNormal];
    [sender setTitleColor:ORDERVIEW_THEME_GREEN_COLOR forState:UIControlStateNormal];
    sender.layer.borderColor=ORDERVIEW_THEME_GREEN_COLOR.CGColor;
    
    NSString *place=[[[timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",sender.tag]] componentsSeparatedByString:@","] objectAtIndex:1];
    
    [self.unsuccessfulPlaceLabel setText:[NSString stringWithFormat:@"地点             %@",place]
                                WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                AndColor:[UIColor grayColor]];
    [self.unsuccessfulPlaceLabel setKeyWordTextString:@"地点"
                                             WithFont:[UIFont fontWithName:LanTingHei size:18.0f]
                                             AndColor:ORDERVIEW_THEME_GREEN_COLOR];
    NSString *bookCode=[[[timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",sender.tag]] componentsSeparatedByString:@","] objectAtIndex:3];
    if ([bookCode rangeOfString:@"null"].length>0) {
        orderButton.enabled=YES;
        orderButton.tag=sender.tag;
    } else {
        orderButton.enabled=NO;
    }
    
    NSString *booknum=[[[timeAndPalceDic objectForKey:[NSString stringWithFormat:@"%i",sender.tag]] componentsSeparatedByString:@","] objectAtIndex:2];
    NSString *string1= [[peopleLabel.text componentsSeparatedByString:@"人"] objectAtIndex:1];
    if ([booknum rangeOfString:@"null"].length>0) {
        peopleLabel.text=[NSString stringWithFormat:@"已有0人%@",string1];
    } else {
        peopleLabel.text=[NSString stringWithFormat:@"已有%@人%@",booknum,string1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
