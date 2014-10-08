//
//  OrderPeopleNumberView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-11.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "OrderPeopleNumberView.h"

@implementation OrderPeopleNumberView

@synthesize currentNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor=ORDERVIEW_THEME_GREEN_COLOR.CGColor;
        self.layer.borderWidth=2.0f;
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        
        numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height)];
        numberLabel.backgroundColor=[UIColor clearColor];
        numberLabel.font=[UIFont fontWithName:@"DINCondensed-Bold" size:19.0f];
        numberLabel.textColor=[UIColor grayColor];
        numberLabel.textAlignment=NSTextAlignmentCenter;
        numberLabel.text=@"1";
        currentNumber=1;
        [self addSubview:numberLabel];
        
        UIButton *minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        minusButton.frame=CGRectMake(0, 0, self.frame.size.width*0.3, self.frame.size.height);
        [minusButton setImage:[UIImage imageNamed:@"order_minus.png"] forState:UIControlStateNormal];
        minusButton.tag=1;
        [minusButton addTarget:self
                       action:@selector(clickBtn:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:minusButton];
        
        UIButton *plusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame=CGRectMake( self.frame.size.width-minusButton.frame.size.width, 0,minusButton.frame.size.width, minusButton.frame.size.height);
        [plusButton setImage:[UIImage imageNamed:@"order_plus.png"] forState:UIControlStateNormal];
        plusButton.tag=2;
        [plusButton addTarget:self
                       action:@selector(clickBtn:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        
    }
    return self;
}

-(void)setCurrentNumber:(NSInteger)_currentNumber {
    numberLabel.text=[NSString stringWithFormat:@"%i",_currentNumber];
}

-(void)clickBtn:(UIButton *)sender {
    if (sender.tag==1) {
        if (currentNumber<=3 && currentNumber>1) {
            currentNumber--;
        }
    } else {
        if (currentNumber>=1 && currentNumber<3) {
            currentNumber++;
        }
    }
    numberLabel.text=[NSString stringWithFormat:@"%i",currentNumber];
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
