//
//  MapViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
@class MenuList;

@interface FloorButton : UIButton

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) FloorType floorType;
@property (nonatomic, strong) UILabel *customLabel;

@end

@interface MapViewController : UIViewController <UIScrollViewDelegate>


///菜单
@property (nonatomic, strong) MenuList *menuList;

- (void)mapZoomInWithScale:(CGFloat)scale;
- (void)mapZoomOutWithScale:(CGFloat)scale;
@end
