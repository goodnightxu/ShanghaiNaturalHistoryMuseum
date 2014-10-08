//
//  User.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "User.h"
#import "KeychainItemWrapper.h"

@implementation User

- (id)init
{
    if (self) {
        //mac
        //获取固定uuid
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
        NSString *uuidString = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
        
        //没有uuid, 第一次生成
        if ([uuidString isEqualToString:@""] || uuidString == nil) {
            [wrapper setObject:[[NSUUID UUID] UUIDString] forKey:(__bridge id)kSecAttrAccount];
        }
        //
        self.mac = uuidString;
    }
 
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.sid = [aDecoder decodeObjectForKey:@"sid"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.pwd = [aDecoder decodeObjectForKey:@"pwd"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.portraitPath = [aDecoder decodeObjectForKey:@"portraitPath"];
        self.portraitImage = [aDecoder decodeObjectForKey:@"portraitImage"];
        self.mail = [aDecoder decodeObjectForKey:@"mail"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.mac = [aDecoder decodeObjectForKey:@"mac"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        
        self.isAutoLogin = [aDecoder decodeBoolForKey:@"isAutoLogin"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sid forKey:@"sid"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.portraitPath forKey:@"portraitPath"];
    [aCoder encodeObject:self.portraitImage forKey:@"portraitImage"];
    [aCoder encodeObject:self.mail forKey:@"mail"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.mac forKey:@"mac"];
    [aCoder encodeObject:self.score forKey:@"score"];
    
    [aCoder encodeBool:self.isAutoLogin forKey:@"isAutoLogin"];
}

@end
