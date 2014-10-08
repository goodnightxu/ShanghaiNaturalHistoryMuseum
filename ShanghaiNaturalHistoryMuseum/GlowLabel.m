//
//  GlowLabel.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/3.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "GlowLabel.h"

#define kBlur 0.75f

@implementation GlowLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    [super drawTextInRect:rect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2), kBlur, [UIColor whiteColor].CGColor);
    [textImage drawAtPoint:rect.origin];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, -2), kBlur, [UIColor whiteColor].CGColor);
    [textImage drawAtPoint:rect.origin];
    CGContextSetShadowWithColor(ctx, CGSizeMake(2, 0), kBlur, [UIColor whiteColor].CGColor);
    [textImage drawAtPoint:rect.origin];
    CGContextSetShadowWithColor(ctx, CGSizeMake(-2, 0), kBlur, [UIColor whiteColor].CGColor);
    [textImage drawAtPoint:rect.origin];
    
    CGContextRestoreGState(ctx);
}


@end
