//
//  AreaItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

///展区信息
@interface AreaItem : NSObject

@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *threshold;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *iconPath;

@end
