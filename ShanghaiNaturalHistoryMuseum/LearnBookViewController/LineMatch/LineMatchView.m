//
//  LineMatchView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LineMatchView.h"





@implementation LineMatchView


- (id)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[[UIColor redColor] colorWithAlphaComponent:0.5f];

        NSArray *titleArray=[NSArray arrayWithObjects:@"加州海豹",@"髯海豹",@"南象海豹",@"威德尔海豹",@"斑海豹", nil];
        answer1=[[LineMatchAnswer alloc] initWithFrame:CGRectMake(31+193*0, 480, 185, 45) title:titleArray[0]];
        [self addSubview:answer1];
        answer2=[[LineMatchAnswer alloc] initWithFrame:CGRectMake(31+193*1, 480, 185, 45) title:titleArray[1]];
        [self addSubview:answer2];
        answer3=[[LineMatchAnswer alloc] initWithFrame:CGRectMake(31+193*2, 480, 185, 45) title:titleArray[2]];
        [self addSubview:answer3];
        answer4=[[LineMatchAnswer alloc] initWithFrame:CGRectMake(31+193*3, 480, 185, 45) title:titleArray[3]];
        [self addSubview:answer4];
        answer5=[[LineMatchAnswer alloc] initWithFrame:CGRectMake(31+193*4, 480, 185, 45) title:titleArray[4]];
        [self addSubview:answer5];
        
        
    }
    return self;
}


-(void)beginDraw {
    LineMatchAnswer *locateAnswer;
    CGPoint currentPoint=CGPointMake(longPressPoint.x, longPressPoint.y);
    if ([self answerForLocation:longPressPoint]==1) {
        locateAnswer=answer1;
    } else if ([self answerForLocation:longPressPoint]==2) {
        locateAnswer=answer2;
    } else if ([self answerForLocation:longPressPoint]==3) {
        locateAnswer=answer3;
    } else if ([self answerForLocation:longPressPoint]==4) {
        locateAnswer=answer4;
    } else if ([self answerForLocation:longPressPoint]==5) {
        locateAnswer=answer5;
    }
    if (locateAnswer) {
        [locateAnswer animate];
        [self drawLineToPoint:currentPoint];
    }
   
    
}

-(void)drawLineToPoint:(CGPoint)point {
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    

}




-(void)beginTouch:(CGPoint)sender {
    
    NSLog(@"point====%@",NSStringFromCGPoint(sender));
    longPressPoint=sender;
    longPressTimer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(beginDraw) userInfo:nil repeats:NO];
}

-(void)endTouch:(CGPoint)sender {
    [longPressTimer invalidate];
    longPressTimer=nil;
    NSLog(@"point====%@",NSStringFromCGPoint(sender));
}

-(void)moveTouch:(CGPoint)sender {
    [longPressTimer invalidate];
    longPressTimer=nil;
    NSLog(@"point====%@",NSStringFromCGPoint(sender));
    
    [self drawLineToPoint:sender];
}



-(NSInteger)answerForLocation:(CGPoint)location {//0表示未按在答案处
    CGFloat locationX=location.x;
    CGFloat locationY=location.y;
    if (locationX>=31 && locationX<=31+185 && locationY>=480 && locationY<=480+45) {
        longPressPoint=CGPointMake(31+185/2, 480+45/2);
        return 1;
    } else if (locationX>=31+193 && locationX<=31+185+193 && locationY>=480 && locationY<=480+45) {
        longPressPoint=CGPointMake(31+185/2+193, 480+45/2);
        return 2;
    } else if (locationX>=31+193+193 && locationX<=31+185+193+193 && locationY>=480 && locationY<=480+45) {
        longPressPoint=CGPointMake(31+185/2+193+193, 480+45/2);
        return 3;
    } else if (locationX>=31+193+193+193 && locationX<=31+185+193+193+193 && locationY>=480 && locationY<=480+45) {
        longPressPoint=CGPointMake(31+185/2+193+193+193, 480+45/2);
        return 4;
    } else if (locationX>=31+193+193+193+193 && locationX<=31+185+193+193+193+193 && locationY>=480 && locationY<=480+45) {
        longPressPoint=CGPointMake(31+185/2+193+193+193+193, 480+45/2);
        return 5;
    } else {
        return 0;
    }
    
}

@end
