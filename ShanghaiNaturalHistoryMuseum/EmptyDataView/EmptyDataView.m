//
//  EmptyDataView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-23.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "EmptyDataView.h"

@implementation EmptyDataView

- (id)initWithFrame:(CGRect)frame text:(NSString *)showText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2-30, frame.size.width, 60)];
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.text=showText;
        textLabel.textColor=ORDERVIEW_THEME_GREEN_COLOR;
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        textLabel.numberOfLines=3;
        textLabel.font=[UIFont fontWithName:LanTingHei size:20.0f];
        [self addSubview:textLabel];
    }
    return self;
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
