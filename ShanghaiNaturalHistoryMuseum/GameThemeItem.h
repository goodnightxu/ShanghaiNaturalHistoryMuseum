//
//  GameThemes.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/10.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>


///游戏主题
@interface GameThemeItem : NSObject

@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titlePic;
@property (nonatomic, strong) NSString *introduction;

@end
