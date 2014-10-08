//
//  RoutePathView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-24.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "RoutePathView.h"
#import "InfoItem.h"
#import <objc/message.h>


@interface ShapeView : UIView
@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
@end

@implementation ShapeView
@synthesize shapeLayer;
+ (Class)layerClass {
    return [CAShapeLayer class];
}
- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}
@end



@implementation RoutePathView

- (id)initWithDataArray:(NSArray *)datas animated:(BOOL)animated {
    InfoItem *item=(InfoItem *)[datas objectAtIndex:0];
    CGFloat minX=item.pt.x,minY=item.pt.y,maxX=minX,maxY=minY;
    for (InfoItem *item in datas) {
        minX = minX < item.pt.x ? minX : item.pt.x;
        maxX = maxX > item.pt.x ? maxX : item.pt.x;
        minY = minY < item.pt.y ? minY : item.pt.y;
        maxY = maxY > item.pt.y ? maxY : item.pt.y;
    }
    
    CGRect rect = CGRectMake(minX, minY-9, maxX-minX, maxY-minY+9);
    self = [super initWithFrame:rect];
    if (self) {
        canAnimated=animated;
        dataArray=[NSArray arrayWithArray:datas];
        self.backgroundColor=[UIColor clearColor];
        
        if (canAnimated) {
            NSMutableArray *pointsArray=[[NSMutableArray alloc] init];
            for (InfoItem *item in datas) {
                CGPoint point=CGPointMake(item.pt.x-self.frame.origin.x, item.pt.y-self.frame.origin.y-9);
                [pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
            }
            points=[NSArray arrayWithArray:pointsArray];
            if (points.count>=2) {
                 [self performSelector:@selector(showLinesAnimation:)
                            withObject:[UIColor whiteColor]
                            afterDelay:0.5f];
                 [self performSelector:@selector(showLinesAnimation:)
                            withObject:VISITROUTE_THEME_ORANGE_COLOR
                            afterDelay:0.5f];
            }
        }
        
    }
    return self;
}


- (void)showLinesAnimation:(UIColor *)color {
    ShapeView *pathShapeView = [[ShapeView alloc] init];
    pathShapeView.backgroundColor = [UIColor clearColor];
    pathShapeView.opaque = NO;
    pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
    pathShapeView.shapeLayer.strokeColor =color.CGColor;
    pathShapeView.shapeLayer.fillColor=nil;//这句不能少
    if (CGColorEqualToColor(color.CGColor, [UIColor whiteColor].CGColor)) {
        pathShapeView.shapeLayer.lineWidth=6.0f;
        pathShapeView.shapeLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        pathShapeView.shapeLayer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        pathShapeView.shapeLayer.shadowOpacity = 0.3;//阴影透明度，默认0
        pathShapeView.shapeLayer.shadowRadius = 4;//阴影半径，默认3
    } else {
        pathShapeView.shapeLayer.lineWidth=3.0f;
    }
    [self addSubview:pathShapeView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    animation.duration = 0.2*(points.count-1)+0.5;
    [pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    if ([points count] >= 2) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:[[points firstObject] CGPointValue]];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [points count] - 1)];
        [points enumerateObjectsAtIndexes:indexSet
                                     options:0
                                  usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                      [path addLineToPoint:[pointValue CGPointValue]];
                                      
                                      
                                  }];
        path.usesEvenOddFillRule = YES;
        pathShapeView.shapeLayer.path = path.CGPath;
    }
    else {
        pathShapeView.shapeLayer.path = nil;
    }
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!canAnimated) {
        if (dataArray.count>=2) {
            for (int i=0; i<dataArray.count-1; i++) {
                InfoItem *startItem=(InfoItem *)[dataArray objectAtIndex:i];
                InfoItem *endItem=(InfoItem *)[dataArray objectAtIndex:i+1];
                CGPoint startPoint=CGPointMake(startItem.pt.x-self.frame.origin.x, startItem.pt.y-self.frame.origin.y-9);
                CGPoint endPoint=CGPointMake(endItem.pt.x-self.frame.origin.x, endItem.pt.y-self.frame.origin.y-9);
                CGContextRef whiteLine=UIGraphicsGetCurrentContext();
                CGContextBeginPath(whiteLine);
                CGContextMoveToPoint(whiteLine,startPoint.x,startPoint.y);
                CGContextAddLineToPoint(whiteLine,endPoint.x,endPoint.y);
                CGContextSetRGBStrokeColor(whiteLine, 1, 1, 1, 1);
                CGContextSetLineWidth(whiteLine, 6);
                CGContextSetShadow(whiteLine, CGSizeMake(1, 1), 6);
                CGContextStrokePath(whiteLine);
                
                CGContextRef orangeLine=UIGraphicsGetCurrentContext();
                CGContextBeginPath(orangeLine);
                CGContextMoveToPoint(orangeLine,startPoint.x,startPoint.y);
                CGContextAddLineToPoint(orangeLine,endPoint.x,endPoint.y);
                CGContextSetRGBStrokeColor(orangeLine, 253/255.0, 132/255.0, 43/255.0, 1);
                CGContextSetLineWidth(orangeLine, 3);
                CGContextStrokePath(orangeLine);
                
            }
        }
    }
}


@end
