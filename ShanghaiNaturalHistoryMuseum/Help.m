//
//  Help.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "Help.h"

//字体
#define OfficeWeb @"http://"

@implementation Help

+ (NSDictionary *)navSubTitleAttribute1
{
    return @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:50], NSForegroundColorAttributeName:Color(201.0f, 85.0f, 56.0f, 1.0f)};
}

+ (NSDictionary *)navSubTitleAttribute2
{
    return @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50], NSForegroundColorAttributeName:Color(201.0f, 85.0f, 56.0f, 1.0f)};
}


#pragma mark - 楼层切换按钮
+ (NSDictionary *)floorTitleAttribute1
{
    return @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18], NSForegroundColorAttributeName:Color(201.0f, 85.0f, 56.0f, 1.0f)};
}

+ (NSDictionary *)floorTitleAttribute2
{
    return @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18], NSForegroundColorAttributeName:Color(201.0f, 85.0f, 56.0f, 1.0f)};
}


//
+ (CGSize)viewSize:(UIView *)view
{
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        return view.bounds.size;
    }
    
    return CGSizeMake(view.bounds.size.height, view.bounds.size.width);
}

@end
