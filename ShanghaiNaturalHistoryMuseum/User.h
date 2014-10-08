//
//  User.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *sid;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *nickname;
///下载URL
@property (nonatomic, strong) NSString *portraitPath;
///上传用的image
@property (nonatomic, strong) UIImage *portraitImage;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mac;
//社区积分
@property (nonatomic, strong) NSNumber *score;

//是否自动登录
@property (nonatomic, assign) BOOL isAutoLogin;

@end
