//
//  Comment.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/26.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommentStory = 0,
    CommentExhibit = 1,
    CommentQuestionAnswer = 2,
    CommentDisscus = 3,
    CommentTakePhoto = 4,
} CommentType;

@interface CommentItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *portraitPath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, assign) BOOL auditing;
@end
