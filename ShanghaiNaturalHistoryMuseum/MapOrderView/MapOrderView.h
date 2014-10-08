//
//  MapOrderView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "OrderItem.h"
#import <JDFlipNumberView.h>


@interface MapOrderView : UIView {
    NSString *hourString;
    NSTimer *orderTimer;
    JDFlipNumberView *hourNumberView;
    JDFlipNumberView *minNumberView;
    JDFlipNumberView *secNumberView;
}

- (id)initWithFloor:(FloorType)floor position:(CGPoint)point orderItem:(OrderItem *)orderItem ;

@end
