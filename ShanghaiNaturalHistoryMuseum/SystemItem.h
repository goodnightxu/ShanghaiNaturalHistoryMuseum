//
//  SystemItem.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/26.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemItem : NSObject

///系统根目录
@property (nonatomic, strong) NSString *baseUrl;
///资源根目录
@property (nonatomic, strong) NSString *resourceBaseUrl;
///实时拥挤度地址
@property (nonatomic, strong) NSString *udpPath;
///每个账号预约最大数预约
@property (nonatomic, strong) NSString *bookThreshold;

@end
