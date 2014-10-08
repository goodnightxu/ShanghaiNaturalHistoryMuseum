//
//  RoutePathView.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-24.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutePathView : UIView {
    BOOL canAnimated;
    NSArray *dataArray;
    NSArray *points;
}

- (id)initWithDataArray:(NSArray *)datas animated:(BOOL)animated;

@end
