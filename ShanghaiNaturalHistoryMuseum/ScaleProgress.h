//
//  ScaleView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/29.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleProgress : UIView

@property (nonatomic, assign) CGFloat progress;

//Event
@property (nonatomic, strong) void (^onZoomIn)();
@property (nonatomic, strong) void (^onZoomOut)();

@end
