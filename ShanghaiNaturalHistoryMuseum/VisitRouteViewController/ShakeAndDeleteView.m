//
//  ShakeAndDeleteView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-17.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ShakeAndDeleteView.h"
#import <QuartzCore/QuartzCore.h>

/////////////////////////////////////////////////////////////////
static const CGFloat kWobbleRadians = 0.5;
static const NSTimeInterval kWobbleTime = 0.2;
static const CGFloat enlargeLength = 1.05;
static const NSTimeInterval enlargeTime = 0.25;
/////////////////////////////////////////////////////////////////


@implementation ShakeAndDeleteView

@synthesize delegate;
@synthesize isShaking;
@synthesize canShake;
@synthesize deleteButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isShaking=NO;
        canShake=YES;
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
		longPressRecognizer.allowableMovement = 30;
		[self addGestureRecognizer:longPressRecognizer];
		      
        deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        deleteButton.frame=CGRectMake(self.frame.size.width-41, 0, 41, 41);
        [deleteButton setImage:[UIImage imageNamed:@"route_shake_delete.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self
                         action:@selector(delete:)
               forControlEvents:UIControlEventTouchUpInside];
        deleteButton.alpha=0;
        [self addSubview:deleteButton];
        
    }
    return self;
}

#pragma mark -
#pragma mark Handling long presses
- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
	if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
		[self startShake];
	}
}
-(void)stopShake {
    if (isShaking && canShake) {
        isShaking = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        deleteButton.alpha=0;
        self.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
}

-(void)startShake {
    if (!isShaking && canShake) {
        isShaking=YES;
       
        [self.superview bringSubviewToFront:self];
        [self bringSubviewToFront:deleteButton];

        CGRect initRect=self.frame;
        [UIView animateWithDuration:enlargeTime
                         animations:^{
                             deleteButton.alpha=1;
                             
                             CGFloat newX=initRect.origin.x-initRect.size.width*enlargeLength/2+initRect.size.width/2.0;
                             CGFloat newY=initRect.origin.y-initRect.size.height*enlargeLength/2+initRect.size.height/2.0;
                             self.frame=CGRectMake(newX, newY, initRect.size.width*enlargeLength, initRect.size.height*enlargeLength);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:enlargeTime
                                              animations:^{
                                                  self.frame=initRect;
                                              } completion:^(BOOL finished) {
                                                  [self wobble];
                                              }];
                         }];
        
        if ([delegate respondsToSelector:@selector(didStartShake:)]) {
            [delegate didStartShake:self];
        }
        
    }
}
-(void)wobble {
    static BOOL wobblesLeft = NO;
	
	if (isShaking) {
        CGFloat rotation = (kWobbleRadians * M_PI) / 180.0;
        CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
        CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
        
        [UIView beginAnimations:nil context:nil];
        
        NSInteger i = 0;
        NSInteger nWobblyButtons = 0;
        
        
        ++nWobblyButtons;
        if (i % 2) {
            self.transform = wobblesLeft ? wobbleRight : wobbleLeft;
        } else {
            self.transform = wobblesLeft ? wobbleLeft : wobbleRight;
        }
        ++i;
        
        if (nWobblyButtons >= 1) {
            [UIView setAnimationDuration:kWobbleTime];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobble)];
            wobblesLeft = !wobblesLeft;
            
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(wobble) withObject:nil afterDelay:kWobbleTime];
        }
        
        [UIView commitAnimations];
    }
}


#pragma mark -
#pragma mark deleteButtonEvent
- (void)delete:(UIButton *)sender {
    //如果要写动画，下面这行写在回调里
//    [self removeFromSuperview];
    if ([delegate respondsToSelector:@selector(willDeleteView:)]) {
        [delegate willDeleteView:self];
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
