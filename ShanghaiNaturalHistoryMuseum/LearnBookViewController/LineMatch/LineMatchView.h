//
//  LineMatchView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineMatchAnswer.h"

@interface LineMatchView : UIView {
    LineMatchAnswer *answer1;
    LineMatchAnswer *answer2;
    LineMatchAnswer *answer3;
    LineMatchAnswer *answer4;
    LineMatchAnswer *answer5;
    
    NSTimer *longPressTimer;
    CGPoint longPressPoint;
}


-(void)beginTouch:(CGPoint)sender;
-(void)endTouch:(CGPoint)sender;
-(void)moveTouch:(CGPoint)sender;


@end
