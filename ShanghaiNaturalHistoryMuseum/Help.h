//
//  Help.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - App Config
//官网
#define kOfficeWebUrl @"http://baike.baidu.com/view/83946.htm?fr=aladdin"

//#define kNavSubTitleAttribute  @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:50], NSForegroundColorAttributeName:[UIColor colorWithRed:201.0f/255.0f green:85.0f/255.0f blue:56.0f/255.0f alpha:1.0]}

//工具
#define Color(r,g,b,a) [UIColor colorWithRed:(CGFloat)r/255.0f green:(CGFloat)g/255.0f blue:(CGFloat)b/255.0f alpha:(CGFloat)a]
#define viewCenter(bounds) CGPointMake(bounds.size.width*0.5f, bounds.size.height*0.5f)


#define kScreenWidth 1024

#pragma mark - NavigationBar 
#define kNavButtonItemWidth 36
#define kNavButtonItemHeight 28

//UI
#define kRightMenuWidth 270


//字体
#define kFontHeitiLight @"STHeitiSC-Light"
#define kFontDidotItalic @"Didot-Italic"

//颜色
///NavgationBar

///淡黑色
#define kColorBlack1 Color(102, 102, 102, 1)
#define kColorGary1 Color(178, 178, 178, 1)
#define kColorGary2 Color(153, 153, 153, 1)
///淡绿色
#define kColorGreen1 Color(142, 227, 220, 1)

///远亲
#define kColorDistant Color(255, 196, 38, 1)
///近邻
#define kColorNeighbour Color(255, 68, 2, 1)

///楼层色
#define kColorL1 Color(221, 155, 162, 1)
#define kColorL2 Color(133, 168, 194, 1)
#define kColorB1 Color(238, 192, 98, 1)
#define kColorB2 Color(101, 173, 58, 1)
#define kColorB2M Color(173, 149, 211, 1)

//Michael
#define     VIDEO_PATH  [NSString stringWithFormat:@"%@/Library/Caches/video",NSHomeDirectory()] //video路径
#define ORDERVIEW_THEME_GREEN_COLOR [UIColor colorWithRed:92/255.0 green:122/255.0 blue:59/255.0 alpha:1.0f]
#define LanTingHei @"STHeitiSC-Light"
#define VISITROUTE_THEME_ORANGE_COLOR [UIColor colorWithRed:253/255.0 green:132/255.0 blue:43/255.0 alpha:1.0f]
#define DURATION 0.25

//错误
#define kBriscErrorDomain @"cn.net.brisc.error"

@interface Help : NSObject

//当前设备方向下的size
+ (CGSize)viewSize:(UIView *)view;

+ (NSDictionary *)navSubTitleAttribute1;
+ (NSDictionary *)navSubTitleAttribute2;
+ (NSDictionary *)floorTitleAttribute1;
+ (NSDictionary *)floorTitleAttribute2;


@end
