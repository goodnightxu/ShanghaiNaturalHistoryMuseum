//
//  GameTaskItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 9/11/14.
//  Copyright (c) 2014 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameTaskItem : NSObject

///任务ID
@property (nonatomic, strong) NSNumber *sid;
///游戏主题id
@property (nonatomic, strong) NSNumber *tid;
///游戏名称
@property (nonatomic, strong) NSString *title;
///提示
@property (nonatomic, strong) NSString *prompt;
///标题图
@property (nonatomic, strong) NSString *titlePic;
///游戏任务描述
@property (nonatomic, strong) NSString *desc;
///积分
@property (nonatomic, strong) NSNumber *score;
///任务是否完成
@property (nonatomic, assign) BOOL status;

@end
