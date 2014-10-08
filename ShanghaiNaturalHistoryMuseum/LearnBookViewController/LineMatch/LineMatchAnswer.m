//
//  LineMatchAnswer.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LineMatchAnswer.h"

@implementation LineMatchAnswer


- (id)initWithFrame:(CGRect )frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor lightGrayColor];
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.text=title;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont fontWithName:LanTingHei size:30.0f];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:titleLabel];
       
    }
    return self;
}


-(void)animate {
    CGRect rect=self.frame;
    [UIView animateWithDuration:0.125 animations:^{
        self.frame=CGRectMake(rect.origin.x-rect.size.width*1.2/2+rect.size.width/2, rect.origin.y-rect.size.height*1.2/2+rect.size.height/2, rect.size.width*1.2, rect.size.height*1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.125 animations:^{
            self.frame=rect;
        } completion:nil];
    }];
}
-(void)setRight {
    self.backgroundColor=[UIColor colorWithRed:25/255.0 green:148/255.0 blue:77/255.0 alpha:1.0];
}
-(void)setWrong {
    self.backgroundColor=[UIColor colorWithRed:187/255.0 green:27/255.0 blue:53/255.0 alpha:1.0];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
