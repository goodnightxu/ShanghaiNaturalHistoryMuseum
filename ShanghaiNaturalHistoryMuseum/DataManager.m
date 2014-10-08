//
//  DataManager.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/22.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "DataManager.h"
#import "User.h"
#import "SystemItem.h"
#import "ExhibitItem.h"
#import "SpecimenItem.h"
#import "InfoItem.h"
#import "RemoteVideoItem.h"
#import "AreaItem.h"
#import "OrderItem.h"
#import "FilmItem.h"
#import "ActivityItem.h"
#import "ScheduleItem.h"
#import "GameThemeItem.h"
#import "GameTaskItem.h"
#import "RecommendRouteItem.h"
#import "LocateItem.h"

#import <Reachability.h>

#pragma mark - 配置
#define kServerAddress @"http://211.144.107.201:9090/"
//#define kServerAddress @"http://10.2.10.16:8080/"

//用户管理
#define kRegistPath @"museum/app/museum/accounts/register"
#define kLoginPath @"museum/app/museum/accounts/login"
#define kChangePasswordPath @"museum/app/museum/accounts/changePwd"
#define kUpdateUserPath @"museum/app/museum/accounts/update"

//系统参数
#define kSystemPath @"museum/app/museum/systems"

//可视化搜索
#define kExhibitKeywordPath @"museum/app/museum/exhibits/searchKeyword"
#define kRelationExhibitPath @"museum/app/museum/exhibits"
#define kExhibitDetailPath @"museum/app/museum/exhibits"
#define kExhibitPositionPath @"museum/app/museum/exhibits"
//标本
#define kSpecimenPath @"museum/app/museum/specimens"

//评论
#define kCommentsPath @"museum/app/museum/comments"

//行程

//电子地图
#define kPointInfoPath @"museum/app/museum/floors"
#define kInfoPtWithInfoPath @"museum/app/museum/informationPoints"
#define kExhibitDetailWithInfoPath @"museum/app/museum/pointinfos/1"
#define kSpecimenDetailWihtInfoPath @"museum/app/museum/pointinfos/0"
#define kRemoteVideoPath @"museum/app/museum/pointinfos/2"
#define kPraiseWithInfoPath @"museum/app/museum/pointinfos"
#define kAreaPath @"museum/app/museum/floors/areas"

//预约
#define kPersonTypesPath @"museum/app/museum/book/personTypes"
#define kFilmsPath @"museum/app/museum/book/films"
#define kActivitiesPath @"museum/app/museum/book/activities"
#define kSchedulePath @"museum/app/museum/book"
#define kPreorderPath @"museum/app/museum/book/preorder"
#define kMyPreorderPath @"museum/app/museum/book"
#define kPreorderCancelPath @"museum/app/museum/book"
#define kPreorderBrowsePath @"museum/app/museum/book/browse"

//参观路线
#define kRoutesKeywordPath @"museum/app/museum/routes/searchKeyword"
#define kFacilityPath @"museum/app/museum/routes/publics"
#define kRecommendRoutePath @"museum/app/museum/routes/recommend"
#define kPraiseRoutePath @"museum/app/museum/routes/praise"
#define kPraiseRouteGuidePath @"museum/app/museum/routes/praise/guide"
#define kFindingPath @"museum/app/museum/routes/pathfinding"
#define kCustomRoutePath @"museum/app/museum/routes/customroute"

//寻宝游戏
#define kGamePath @"museum/app/museum/games"
#define kGameThemesPath @"museum/app/museum/games/themes"
#define kGameTaskPath @"museum/app/museum/games"

@implementation DataManager


#pragma mark - 用户管理
#pragma mark 用户注册
+ (void)registWithUser:(User *)user callback:(void (^)(BOOL success))callback
{
    NSAssert(user != nil, @"用户注册，user不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kRegistPath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            NSLog(@"register user: %@", result.responseString);
        }
        
        callback(success);
    }];
    
    //
    [request setPostValue:user.account forKey:@"account"];
    [request setPostValue:user.pwd forKey:@"pwd"];
    [request setPostValue:user.nickname forKey:@"nickname"];
    
    //头像转base64
    NSData *portraitData = UIImagePNGRepresentation(user.portraitImage);
    NSString *portraitString = [portraitData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [request setPostValue:portraitString forKey:@"portrait"];
    [request setPostValue:user.mail forKey:@"mail"];
    [request setPostValue:user.mobile forKey:@"mobile"];
    request.requestMethod = @"POST";
    
#warning 调试Debug开
    request.showError = YES;
    
    [request startAsynchronous];
}

#pragma mark 登入
//登入成功保存到本地
+ (void)loginWithUser:(User *)user callback:(void (^)(User *user, BOOL success))callback
{
    NSAssert(user != nil, @"登入，用户不能为空");
    NSAssert(user.account != nil && ![user.account isEqualToString:@""], @"登入，用户账号不能为空");
    NSAssert(user.pwd != nil && ![user.pwd isEqualToString:@""], @"登入，用户密码不能为空");
    NSAssert(user.mac != nil && ![user.mac isEqualToString:@""], @"登入，用户mac不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?account=%@&pwd=%@&mac=%@", kServerAddress, kLoginPath, user.account, user.pwd, user.mac];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToUserWithRequest:result callback:^(User *result, BOOL success) {
                if (success) {
                    //保存到本地
                    NSAssert(result.sid != nil, @"登入成功后， usr.sid不为空");
                    result.isAutoLogin = user.isAutoLogin;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:result];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUser];
                }
                callback(result, success);
                
            }];
        }else{
            callback(nil, success);
        }
    }];
    
#warning Debug
    request.showError = YES;
    //
    [request startAsynchronous];
}

+ (void)convertToUserWithRequest:(DataRequest *)request callback:(void (^)(User *user, BOOL success))callback
{
    User *user = [[User alloc] init];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        user.sid = dic[@"result"][@"uid"];
        user.account = dic[@"result"][@"account"];
        user.pwd = dic[@"result"][@"pwd"];
        user.nickname = dic[@"result"][@"nickname"];
        
        if (dic[@"result"][@"portrait"] == [NSNull null]) {
            user.portraitPath = nil;
        }else{
            user.portraitPath = dic[@"result"][@"portrait"];
        }
        user.mail = dic[@"result"][@"mail"];
        user.mobile = dic[@"result"][@"mobile"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(user, success);
    }
}

#pragma mark  获取本地用户信息
+ (User *)getUser
{
    User *user= nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUser];
    if (data != nil) {
        user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return user;
}

#pragma mark 修改会员密码
+ (void)changePasswordWithUser:(User *)user newPassword:(NSString *)newPassword callback:(void (^)(BOOL success))callback
{
    NSAssert(user.account != nil, @"修改会员密码， 账号不能为空");
    NSAssert(![user.account isEqualToString:@""],  @"修改会员密码， 账号不能为空");
    NSAssert(user.pwd != nil, @"修改会员密码， 原密码不能为空");
    NSAssert(![user.pwd isEqualToString:@""],  @"修改会员密码， 原密码不能为空");
    NSAssert(newPassword != nil, @"修改会员密码， 新密码不能为空");
    NSAssert(![newPassword isEqualToString:@""],  @"修改密码信息， 新密码不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kChangePasswordPath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            NSLog(@"change password: %@", result.responseString);
        }
    }];
    
    //
    [request setPostValue:user.account forKey:@"account"];
    [request setPostValue:user.pwd forKey:@"srcPwd"];
    [request setPostValue:newPassword forKey:@"newPwd"];
    request.requestMethod = @"POST";
    
#warning Debug
    request.showError = YES;
    
    [request startAsynchronous];
}

#pragma mark 修改会员信息
+ (void)updateUserInfo:(User *)user callback:(void (^)(BOOL success))callback
{
    NSAssert(user.mail != nil, @"修改会员信息， mail不能为空");
    NSAssert(![user.mail isEqualToString:@""],  @"修改会员信息， mail不能为空");
    NSAssert(user.mobile != nil, @"修改会员信息， mobile不能为空");
    NSAssert(![user.mobile isEqualToString:@""],  @"修改会员信息， mobile不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kUpdateUserPath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            NSLog(@"updateUserInfo: %@", result.responseString);
        }
    }];
    
    [request setPostValue:user.mail forKey:@"mail"];
    [request setPostValue:user.mobile forKey:@"mobile"];
    request.requestMethod = @"POST";
    
#warning Debug
    request.showError = YES;
    
    [request startAsynchronous];
}

#pragma mark - 系统参数
+ (void)loadSystem:(void (^)(SystemItem *systemItem, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kSystemPath];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        if (success) {
            [DataManager convertToSystemWithRequest:result  callback:^(SystemItem *systemItem, BOOL success) {
                callback(systemItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.showHUD = NO;
    [request startAsynchronous];
}

+ (void)convertToSystemWithRequest:(DataRequest *)request callback:(void (^)(SystemItem *systemItem, BOOL success))callback
{
    SystemItem *systemItem;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        systemItem = [[SystemItem alloc] init];
        systemItem.baseUrl = dic[@"result"][@"baseUrl"];
        systemItem.resourceBaseUrl = dic[@"result"][@"resourceBaseUrl"];
#warning 后台没有返回 udpPath和bookThreshold
#warning url 最后不一定提供 / 结尾
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(systemItem, success);
    }
}

#pragma mark - 可视化搜索
#pragma mark 关键字搜索
+ (void)loadExhibitWithKeyword:(NSString *)keyword showHUD:(BOOL)showHUD inView:(UIView *)view callback:(void (^)(NSArray *exhibits, BOOL success))callback
{
    NSAssert(keyword != nil && ![keyword isEqualToString:@""], @"可视化搜索， keyword不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?key=%@", kServerAddress, kExhibitKeywordPath, keyword];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        
        if (success) {
            [DataManager convertToExhibitWithRequest:result callback:^(NSArray *exhibits, BOOL success) {
                callback(exhibits, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    
    request.showHUD = showHUD;
    if (view != nil) {
        request.hudSuperView = view;
    }
    
    request.cache = YES;
    [request startAsynchronous];
}

#pragma mark 相关展品列表（远亲、近邻)
+ (void)loadRelationWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(NSArray *exhibits, BOOL success))callback
{
    NSAssert(exhibitItem.sid != nil, @"相关展品列表, exhibitItem 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/relationExhibits", kServerAddress, kRelationExhibitPath, exhibitItem.sid.integerValue];
    
    DataRequest *requset = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        NSLog(@"relation exhibits: %@", result.responseString);
        if (success) {
            [DataManager convertToExhibitWithRequest:result callback:^(NSArray *exhibits, BOOL success) {
                callback(exhibits, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    requset.cache = YES;
    [requset startAsynchronous];
}

+ (void)convertToExhibitWithRequest:(DataRequest *)request callback:(void (^)(NSArray *exhibits, BOOL success))callback
{
    NSMutableArray *exhibits = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *eDic in dic[@"result"]) {
            ExhibitItem *eItem = [[ExhibitItem alloc] init];
            eItem.sid = eDic[@"eid"];
            eItem.name = eDic[@"name"];
            eItem.latinName = eDic[@"latinName"];
            eItem.iconPath = eDic[@"icon"];
            @try {
                //loadRelationWithExhibit 用到
                eItem.relation =  ((NSNumber *)eDic[@"relation"]).integerValue;
            }
            @catch (NSException *exception) {
                //
            }
            @finally {
                //
            }
            
            [exhibits addObject:eItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(exhibits, success);
    }
}

#pragma mark 展品详细信息
+ (void)loadExhibitDetailWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(ExhibitItem *exhibitItem, BOOL success))callback
{
    NSAssert(exhibitItem.sid != nil, @"相关展品列表, exhibitItem 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", kServerAddress, kExhibitDetailPath, exhibitItem.sid.stringValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        NSLog(@"展品详细信息: %@", result.responseString);
        if (success) {
            [DataManager convertToExhibitDetailWithRequest:result callback:^(ExhibitItem *exhibitItem, BOOL success) {
                callback(exhibitItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToExhibitDetailWithRequest:(DataRequest *)request callback:(void (^)(ExhibitItem *exhibitItem, BOOL succeess))callback
{
    ExhibitItem *eItem;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *eDic = dic[@"result"];
        eItem = [[ExhibitItem alloc] init];
        
        eItem.sid = eDic[@"eid"];
        eItem.name = eDic[@"name"];
        eItem.latinName = eDic[@"latinName"];
        eItem.iconPath = eDic[@"icon"];
        
        //
        eItem.summary = eDic[@"summary"];
        eItem.age = eDic[@"age"];
        eItem.gathering = eDic[@"gathering"];
        eItem.code = eDic[@"code"];
        eItem.latinName = eDic[@"latinName"];
        eItem.englishName = eDic[@"englishName"];
        eItem.popularName = eDic[@"popularName"];
        eItem.pics = eDic[@"pics"];
        eItem.relationRegionId = eDic[@"erid"];
        eItem.tName = eDic[@"tname"];
        eItem.sepicmenId = eDic[@"sid"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(eItem, success);
    }
}

#pragma mark 标本背后的故事
+ (void)loadSpecimenWithSpecimenId:(NSNumber *)specimenId callback:(void (^)(SpecimenItem *specimenItem, BOOL success))callback
{
    NSAssert(specimenId != nil, @"标本背后的故事, specimenId 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i", kServerAddress, kSpecimenPath, specimenId.intValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"Specimen: %@", result.responseString);
        if (success) {
            [DataManager convertToSpecimenWithRequest:result callback:^(SpecimenItem *specimentItem, BOOL success) {
                callback(specimentItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToSpecimenWithRequest:(DataRequest *)request callback:(void (^)(SpecimenItem *specimentItem, BOOL success))callback
{
    SpecimenItem *specimenItem = nil;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *sDic = dic[@"result"];
        specimenItem = [[SpecimenItem alloc] init];
        specimenItem.sid = sDic[@"id"];
        specimenItem.name = sDic[@"specimenName"];
        specimenItem.iconPath = sDic[@"specimenIcon"];
        specimenItem.introduce = sDic[@"specimenIntroduction"];
        specimenItem.specimenType = ((NSNumber *)sDic[@"specimenType"]).integerValue;
        specimenItem.lookVideoPath = sDic[@"lookVideo"];
        specimenItem.lookARPath = sDic[@"lookVideoAr"];
        specimenItem.lookPics = sDic[@"lookPics"];
        specimenItem.studyPics = sDic[@"studyPics"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(specimenItem, success);
    }
}

#pragma mark 展品位置
+ (void)loadExhibitPositionWithExhibit:(ExhibitItem *)exhibitItem callback:(void (^)(InfoItem *infoItem, BOOL success))callback
{
    NSAssert(exhibitItem.sid != nil, @"展品位置， exhibitItem.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/position", kServerAddress, kExhibitPositionPath, exhibitItem.sid.intValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //[DataManager convertToPosition]
        NSLog(@"position: %@", result.responseString);
        if (success) {
            [DataManager convertToPositionWithRequest:result callback:^(InfoItem *infoItem, BOOL success) {
                callback(infoItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}


+(void)convertToPositionWithRequest:(DataRequest *)request callback:(void (^)(InfoItem *infoItem, BOOL success))callback
{
    InfoItem *pItem = nil;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *pDic = dic[@"result"];
        if (dic[@"result"] != [NSNull null]) {
            pItem = [[InfoItem alloc] init];
            pItem.sid = pDic[@"id"];
            pItem.floorCode = pDic[@"floorCode"];
            NSNumber *x = pDic[@"x"];
            NSNumber *y = pDic[@"y"];
            pItem.pt = CGPointMake(x.floatValue, y.floatValue);
        }
        
       
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(pItem, success);
    }

}

#warning 评论部分问题比较大，等后台修改
#pragma mark - 评论
#pragma mark 获取评论
+ (void)loadCommnetsWithUser:(User *)user type:(CommentType)commentType callback:(void (^)(NSArray *comments, BOOL success))callback
{
#warning 接口指定必须有user, 无法处理游客,  需要继续讨论
    NSAssert(user.sid != nil, @".....");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/%i", kServerAddress, kCommentsPath,commentType, user.sid.integerValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        NSLog(@"comments: %@", result.responseString);
        if (success) {
            [DataManager convertToCommentsWithRequest:result callback:^(NSArray *comments, BOOL success) {
                callback(comments, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToCommentsWithRequest:(DataRequest *)request callback:(void (^)(NSArray *comments, BOOL success))callback
{
    NSMutableArray *comments = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *commentDic in dic[@"result"]) {
            CommentItem *commentItem = [[CommentItem alloc] init];
            commentItem.name = commentDic[@"username"];
#warning portrait 空值为"null"
            commentItem.portraitPath = commentDic[@"portrait"];
            commentItem.content = commentDic[@"content"];
            commentItem.updateTime = commentDic[@"updatetime"];
            commentItem.auditing = ((NSNumber *)commentDic[@"auditing"]).boolValue;

            [comments addObject:commentItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(comments, success);
    }
}

#pragma mark 提交评论
//TODO: 后台有问题，没有继续
//+ (void)postCommentWithUser:(User *)user

#pragma mark - 行程
#pragma mark 存储用户行程
//TODO: 需要其他接口支持获取行程点，暂时不做

#pragma mark 获取用户行程
+ (void)loadToursWithUser:(User *)user date:(NSDate *)date callback:(void (^)(NSArray *tours, BOOL success))callback
{
    NSAssert(user.mac != nil && ![user.mac isEqualToString:@""], @"获取用户行程, user.mac不能为空");
}

#pragma mark - 电子地图
#pragma mark 获取楼层信息点信息
+ (void)loadPointInfoWithUser:(User *)user floor:(NSInteger)floor inView:(UIView *)view callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSAssert(user.mac != nil && ![user.mac isEqualToString:@""], @"获取楼层信息点信息, user.mac不能为空");
    if (user.sid == nil) {
        user.sid = @0;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/pointinfos?userId=%@&mac=%@", kServerAddress, kPointInfoPath, floor, user.sid, user.mac];
    DataRequest *request =[DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        NSLog(@"信息点: %@", result.responseString);
        if (success) {
            [DataManager convertToInfosWithRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    if (view != nil) {
        request.hudSuperView = view;
    }
    
    request.cache = YES;
    [request startSynchronous];
}

+ (void)convertToInfosWithRequest:(DataRequest *)request callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSMutableArray *infos = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *infoDic in dic[@"result"]) {
            InfoItem *iItem = [[InfoItem alloc] init];
            iItem.sid = infoDic[@"id"];
            iItem.title = infoDic[@"title"];
            iItem.iconPath = infoDic[@"icon"];
            iItem.type = ((NSNumber *)infoDic[@"type"]).intValue;
            iItem.relationId = infoDic[@"relationshipId"];
            iItem.gameTaskId = infoDic[@"gameTaskId "];
            iItem.praise = infoDic[@"praise"];
            NSNumber *x = infoDic[@"pointX"];
            NSNumber *y = infoDic[@"pointY"];
            iItem.pt = CGPointMake(x.floatValue, y.floatValue);
            iItem.visit = ((NSNumber *)infoDic[@"visit"]).boolValue;
#warning 后台可能返回null, 需要后台调整
            if (infoDic[@"positionType"] == [NSNull null]) {
                iItem.specimenType = SpecimenTypeGround;
            }else{
                iItem.specimenType = ((NSNumber *)infoDic[@"positionType"]).intValue;
            }
            
            
            [infos addObject:iItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(infos, success);
    }
}

#pragma mark 6.2 获取信息点的地图所在位置
+ (void)loadPointInfoWithInfoItem:(InfoItem *)infoItem callback:(void (^)(InfoItem *infoItem, BOOL success))callback
{
    NSAssert(infoItem != nil, @"获取信息点的地图所在位置, infoItem 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/%i/position", kServerAddress, kInfoPtWithInfoPath, infoItem.type, infoItem.relationId.intValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            //
            [DataManager convertToInfoWithPointRequest:result callback:^(InfoItem *infoItem, BOOL success) {
                callback(infoItem, success);
            } ];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
    
}

+ (void)convertToInfoWithPointRequest:(DataRequest *)request callback:(void (^)(InfoItem *infoItem, BOOL success))callback
{
    InfoItem *infoItem = nil;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *infoDic = dic[@"result"];
        infoItem  = [[InfoItem alloc] init];
        NSNumber *x;
        NSNumber *y;
        if (infoDic[@"x"] == [NSNull null]) {
            x = @0;
            y = @0;
        } else {
            x = infoDic[@"x"];
            y = infoDic[@"y"];
        }
        
        infoItem.pt = CGPointMake(x.floatValue, y.floatValue);
        infoItem.floorCode = infoDic[@"floorCode"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(infoItem, success);
    }
}

#pragma mark 获取信息点展品详细信息
+ (void)loadExhibitDetailWithInfo:(InfoItem *)infoItem callback:(void (^)(ExhibitItem *exhibitItem, BOOL success))callback
{
    NSAssert(infoItem.sid != nil, @"获取信息点展品详细信息, infoItem.sid 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li", kServerAddress, kExhibitDetailWithInfoPath, infoItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"exhibit: %@", result.responseString);
        if (success) {
            [DataManager convertToExhibitDetailWithRequest:result
                                                  callback:^(ExhibitItem *exhibitItem, BOOL succeess) {
                callback(exhibitItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

#pragma mark 获取标本背后详细信息
+ (void)loadSpecimenDetailWithInfo:(InfoItem *)infoItem callback:(void (^)(SpecimenItem *specimenItem, BOOL success))callback
{
    NSAssert(infoItem.sid != nil, @"获取标本背后详细信息, infoItem.sid不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li", kServerAddress, kSpecimenDetailWihtInfoPath, infoItem.sid.integerValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        NSLog(@"specimen: %@", result.responseString);
        if (success) {
            [DataManager convertToSpecimenWithRequest:result callback:^(SpecimenItem *specimentItem, BOOL success) {
                callback(specimentItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

#pragma mark 获取远程视频详细信息
+ (void)loadRemoteVideoWithInfo:(InfoItem *)infoItem callback:(void (^)(RemoteVideoItem *remoteVideoItem, BOOL success))callback
{
    NSAssert(infoItem.sid != nil, @"获取远程视频详细信息, infoItem.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li", kServerAddress, kRemoteVideoPath, infoItem.sid.integerValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"remote video :%@", result.responseString);
        if (success) {
            [DataManager convertToRemoteVideoWithRequest:result callback:^(RemoteVideoItem *remoteVideoItem, BOOL success) {
                callback(remoteVideoItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToRemoteVideoWithRequest:(DataRequest *)request callback:(void (^)(RemoteVideoItem *remoteVideoItem, BOOL success))callback
{
    RemoteVideoItem *videoItem;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *vDic = dic[@"result"];
        if (dic[@"result"] != [NSNull null]) {
            videoItem.sid = vDic[@"id"];
            videoItem.title = vDic[@"title"];
            videoItem.iconPath = vDic[@"iconPath"];
            videoItem.urlPath = vDic[@"url"];

        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(videoItem, success);
    }
}

#pragma mark 信息点点赞
+ (void)postPraiseWithInfoItem:(InfoItem *)infoItem callback:(void (^)(NSInteger praiseNum, BOOL success))callback
{
    NSAssert(infoItem.sid != nil, @"信息点点赞，infoItem.sid 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/praise", kServerAddress, kPraiseWithInfoPath, infoItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"praise: %@", result.responseString);
        if (success) {
            [DataManager convertToPraiseWithRequest:result callback:^(NSInteger praiseNum, BOOL success) {
                callback(praiseNum, success);
            }];
        }else{
            callback(0, success);
        }
    }];
    
    request.requestMethod =  @"POST";
    [request startAsynchronous];
}

+ (void)convertToPraiseWithRequest:(DataRequest *)request callback:(void (^)(NSInteger praiseNum, BOOL success))callback
{
    NSNumber *praise;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        if (dic[@"result"] != nil) {
            praise = dic[@"result"];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(praise.integerValue, success);
    }
}

#pragma mark 获取展区信息
+ (void)loadAreas:(void (^)(NSArray *areas, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kAreaPath];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"Areas: %@", result.responseString);
        if (success) {
            [DataManager convertToAreasWithRequest:result callback:^(NSArray *areas, BOOL success) {
                callback(areas, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToAreasWithRequest:(DataRequest *)request callback:(void (^)(NSArray *areas, BOOL success))callback
{
    NSMutableArray *areas = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *areaDic in dic[@"result"]) {
            AreaItem *areaItem = [[AreaItem alloc] init];
            areaItem.sid = areaDic[@"id"];
            areaItem.name = areaDic[@"name"];
            areaItem.threshold = areaDic[@"threshold"];
            areaItem.code = areaDic[@"code"];
            areaItem.iconPath = areaDic[@"icon"];
        
            [areas addObject:areaItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(areas, success);
    }
}

#pragma mark 展区拥挤度
#warning 后台缺少 udpPath 暂时不做

#pragma marm - 展品互动
#warning 暂时不做

#pragma mark - 预约
#pragma mark 获取受众类型
+ (void)loadPersonTypes:(void (^)(NSDictionary *personDic, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kPersonTypesPath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToPersonTypesWithRequest:result callback:^(NSDictionary *result, BOOL success) {
                NSLog(@"Person types: %@", result);
                callback(result, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToPersonTypesWithRequest:(DataRequest *)request callback:(void (^)(NSDictionary *result, BOOL success))callback
{
    NSDictionary *result = nil;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        result = dic[@"result"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(result, success);
    }
}

#pragma mark 电影列表
+ (void)loadFilmsWithPersonType:(NSString *)personType  user:(User *)user callback:(void (^)(NSArray *films, BOOL success))callback
{

    NSString *sid;
    if (user.sid == nil) {
        sid = @"";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?userId=%@", kServerAddress, kFilmsPath, sid];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            NSLog(@"films: %@", result.responseString);
            [DataManager convertToFilmsWithRequest:result callback:^(NSArray *films, BOOL success) {
                callback(films, success);
            }];
            
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];

}

+ (void)convertToFilmsWithRequest:(DataRequest *)request callback:(void (^)(NSArray *films, BOOL success))callback
{
    NSMutableArray *films = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *filmDic in dic[@"result"]) {
            FilmItem *filmItem = [[FilmItem alloc] init];
            filmItem.sid = filmDic[@"id"];
            filmItem.name = filmDic[@"name"];
            filmItem.titlePic = filmDic[@"titlePic"];
            filmItem.playTime = filmDic[@"playTime"];
            filmItem.introduction = filmDic[@"introduction"];
            
            filmItem.bookNum = filmDic[@"bookNum"];
            if (filmDic[@"bookNum"] == [NSNull null]) {
                filmItem.bookNum = @0;
            }
            
            filmItem.browseNum = filmDic[@"browseNum"];
            if (filmDic[@"browseNum"] == [NSNull null]) {
                filmItem.browseNum = @0;
            }
            
            [films addObject:filmItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(films, success);
    }
}


/*
#pragma mark 获取电影预约明细
+ (void)loadFilmWithFilmItem:(FilmItem *)filmItem user:(User *)user callback:(void (^)(FilmItem *filItem, BOOL success))callback
{
    NSAssert(user.sid != nil, @"获取电影预约明细， user.sid 不能为空");
    NSAssert(filmItem.sid != nil, @"获取电影预约明细， filmItem.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i", kServerAddress, kFilmsPath, filmItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        if (success) {
            //
            [DataManager convertToFilmItemWithRequest:result filmItem:filmItem callback:^(FilmItem *fileItem, BOOL success) {
                callback(filmItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

///电影详细信息
+ (void)convertToFilmItemWithRequest:(DataRequest *)request filmItem:(FilmItem *)filmItem   callback:(void (^)(FilmItem *fileItem, BOOL success))callback
{
    FilmItem *result = nil;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    @try {
        NSDictionary *filmDic = dic[@"result"];
        filmItem.filmType = ((NSNumber *)filmDic).integerValue;
        filmItem.screenings = filmDic[@"screenings"];
        filmItem.maxBookNum = filmDic[@"maxBookNum"];
        
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(filmItem, success);
    }
}
 */

#pragma mark 活动列表
+ (void)loadActivitesWithPersonType:(NSString *)personType user:(User *)user callback:(void (^)(NSArray *activities, BOOL success))callback
{
    //可以不要personType
    
    //NSAssert(personType != nil && ![personType isEqualToString:@""], @"获取活动预约列表, personType不能为空");
    //NSArray *keys = [personTypeDic allKeysForObject:personType];
    //NSAssert1(keys != nil && keys[0] != nil, @"获取活动预约列表, 没有personType = %@", personType);
    

    NSString *sid;
    if (user.sid == nil) {
        sid = @"";
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@?userId=%@&personType=%@", kServerAddress, kActivitiesPath, sid, personType];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    DataRequest *request = [DataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            NSLog(@"activities: %@", result.responseString);
            [DataManager convertToActivitiesWithRequest:result callback:^(NSArray *activities, BOOL success) {
                callback(activities, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToActivitiesWithRequest:(DataRequest *)request callback:(void (^)(NSArray *results, BOOL success))callback
{
    
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    
    NSMutableArray *activities = [NSMutableArray array];
    
#warning mark 接口问题 result == null
    if (dic[@"result"] == [NSNull null]) {
        callback(activities, YES);
        return;
    }
    
    //格式错误
    @try {
        for (NSDictionary *activityDic in dic[@"result"]) {
            ActivityItem *activityItem = [[ActivityItem alloc] init];
            activityItem.sid = activityDic[@"id"];
            activityItem.name = activityDic[@"name"];
            activityItem.titlePic = activityDic[@"titlePic"];
            activityItem.contents = activityDic[@"contents"];
            
            if (activityDic[@"browseNum"] == [NSNull null]){
                activityItem.browseNum = @0;
            }else{
                activityItem.browseNum = activityDic[@"browseNum"];
            }
            [activities addObject:activityItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(activities, success);
    }
}

#pragma mark 查询活动或影片安排的信息
+ (void)loadSchedulesWithItem:(NSObject *)item user:(User *)user callback:(void (^)(NSArray *schudules, BOOL success))callback
{
    
    NSNumber *sid = nil;
    PreorderType preorderType = -1;
    if ([item isKindOfClass:[FilmItem class]]) {
        //
        FilmItem *filmItem = (FilmItem *)item;
        NSAssert(filmItem.sid != nil, @"查询安排信息， filmItem.sid不能为空");
        sid = filmItem.sid;
        preorderType = PreorderFilm;
    }
    
    if ([item isKindOfClass:[ActivityItem class]]) {
        //
        ActivityItem *activityItem = (ActivityItem *)item;
        NSAssert(activityItem.sid != nil, @"查询安排信息， activityItem.sid不能为空");
        sid = activityItem.sid;
        preorderType = PreorderActivity;
    }
    
    if ([item isKindOfClass:[OrderItem class]]) {
        OrderItem *orderItem = (OrderItem *)item;
        NSAssert(orderItem.cid != nil, @"查询安排信息， orderItem.sid不能为空");
        sid = orderItem.cid;
        preorderType = orderItem.preorderType;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/%li/scheduleList?userId=%i", kServerAddress, kSchedulePath, preorderType, sid.integerValue, user.sid.intValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToSchedulesWithRequest:result preorderType:preorderType callback:^(NSArray *schedules, BOOL success) {
                callback(schedules, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToSchedulesWithRequest:(DataRequest *)request preorderType:(PreorderType)preorderType callback:(void (^)(NSArray *schedules, BOOL success))callback
{
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    NSMutableArray *schedules = [NSMutableArray array];
    @try {
#warning mark 接口问题 result == null
        if (dic[@"result"] == [NSNull null]) {
            callback(schedules, YES);
            return;
        }
        
        for (NSDictionary *schDic in dic[@"result"]) {
            ScheduleItem *schItem = [[ScheduleItem alloc] init];
            schItem.sid = schDic[@"id"];
            schItem.beginTime = schDic[@"beginTime"];
            schItem.address = schDic[@"addressName"];
            schItem.cid = schDic[@"cId"];
            schItem.infoItemType = ((NSNumber *)schDic[@"pointType"]).intValue;
            schItem.preoderType = preorderType;
            
            if (schDic[@"bookNum"] == [NSNull null]) {
                schItem.bookNum = @0;
            }else{
                schItem.bookNum = schDic[@"bookNum"];
            }
            
            if (schDic[@"bookCode"] == [NSNull null])
            {
                schItem.bookCode = nil;
            }else{
                schItem.bookCode = schDic[@"bookCode"];

            }
            
            [schedules addObject:schItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
        schedules = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(schedules, success);
    }
}

#pragma mark 在线预约
+ (void)loadPreorderWithScheduleItem:(ScheduleItem *)scheduleItem user:(User *)user num:(NSNumber *)num callback:(void (^)(NSString *code, BOOL success))callback
{
    
    NSAssert(scheduleItem.preoderType == PreorderFilm || scheduleItem.preoderType  == PreorderActivity, @"在线预约，未知的预约类型");
    NSAssert(scheduleItem.sid != nil, @"在线预约, 活动安排或排片id, 不能为空");
    NSAssert(user.sid != nil, @"在线预约, 用户id, 不能为空");
    NSAssert(num != nil && num.integerValue >0 , @"在线预约, 预约数量不能为空且大于0");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kPreorderPath];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToPreorderCodeWithRequest:result callback:^(NSString *code, BOOL success) {
                callback(code, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    
    [request setPostValue:scheduleItem.sid forKey:@"scheduleId"];
    [request setPostValue:[NSNumber numberWithInteger:scheduleItem.preoderType] forKey:@"type"];
    [request setPostValue:user.sid forKey:@"userId"];
    [request setPostValue:num.stringValue forKey:@"num"];
    
    request.requestMethod = @"POST";
    
    [request start];
    
}

+ (void)convertToPreorderCodeWithRequest:(DataRequest *)request callback:(void (^)(NSString *code, BOOL success))callback
{
    NSString *code;
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        code = dic[@"result"];
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(code, success);
    }
}


#pragma mark 获取我的预约列表
+ (void)loadAppointmentWithUser:(User *)user callback:(void (^)(NSArray *orders, BOOL success))callback
{
    NSAssert(user.sid != nil, @"我的预约列表， user.sid 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/bookList", kServerAddress, kMyPreorderPath, user.sid.integerValue];

    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToOrderItemWithRequest:result callback:^(NSArray *orders, BOOL success) {
                callback(orders, success);
            }];
        }else{
            callback(nil, success);
        }
    }];

    [request startAsynchronous];
    
}

+ (void)convertToOrderItemWithRequest:(DataRequest *)request callback:(void (^)(NSArray *orders, BOOL success))callback
{

    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    NSMutableArray *orders = [NSMutableArray array];
    @try {
        NSDictionary *results = dic[@"result"];
        //TODO: 没有试过
        for (NSDictionary *orderDic in results) {
            OrderItem *orderItem = [[OrderItem alloc] init];
            orderItem.sid = orderDic[@"id"];
            orderItem.scheduleId = orderDic[@"scheduleId"];
            orderItem.preorderType = ((NSNumber *)orderDic[@"type"]).intValue;
            orderItem.cid = orderDic[@"cId"];
            orderItem.name = orderDic[@"name"];
            orderItem.address = orderDic[@"address"];
            orderItem.bookCode = orderDic[@"bookCode"];
            orderItem.bookNum = orderDic [@"bookNum"];
            orderItem.bookDate = orderDic[@"bookDate"];
            orderItem.beginTime = orderDic[@"beginTime"];
            
            if (orderDic[@"check"] == [NSNull null]) {
                orderItem.check = NO;
            }else{
                orderItem.check = ((NSNumber *)orderDic[@"check"]).boolValue;
            }
            
            [orders addObject:orderItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(orders, success);
    }
}

#pragma mark 获取电影预约明细
+ (void)loadFilmWithScheduleItem:(ScheduleItem *)scheduleItem user:(User *)user callback:(void (^)(FilmItem *filmItem, BOOL success))callback
{
    NSAssert(user.sid != nil, @"获取电影预约明细， user.sid 不能为空");
    NSAssert(scheduleItem.sid != nil, @"获取电影预约明细， orderItem.scheduleId 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/%li", kServerAddress, kFilmsPath, user.sid.integerValue, scheduleItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        //
        if (success) {
            //
            [DataManager convertToFilmItemWithRequest:result callback:^(FilmItem *filmItem, BOOL success) {
                callback(filmItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

///电影详细信息
+ (void)convertToFilmItemWithRequest:(DataRequest *)request  callback:(void (^)(FilmItem *filmItem, BOOL success))callback
{
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    FilmItem *filmItem = [[FilmItem alloc] init];
    @try {
        NSDictionary *filmDic = dic[@"result"];
        //filmItem.sid =filmDic[@"scheduleId"];
        filmItem.scheduleId = filmDic[@"id"];
        filmItem.name = filmDic[@"name"];
        filmItem.titlePic =  filmDic[@"titleDic"];
        filmItem.filmType = ((NSNumber *)filmDic[@"filemType"]).intValue;
        filmItem.beginTime = filmDic[@"beginDate"];
        filmItem.endTime = filmDic[@"endDate"];
        filmItem.playBeginTime = filmDic[@"playBeginTime"];
        filmItem.playTime = filmDic[@"playTime"];
        filmItem.screenings = filmDic[@"screenings"];
        filmItem.address = filmDic[@"address"];
        filmItem.introduction = filmDic[@"introduction"];
        filmItem.maxBookNum = filmDic[@"maxBookNum"];
        filmItem.bookNum = filmDic[@"bookNum"];
        filmItem.browseNum = filmDic[@"browseNum"];
        filmItem.bookCode = filmDic[@"bookCode"];
        filmItem.bookDate = filmDic[@"bookDate"];
#warning 接口问题
        if (filmDic[@"check"] ==  [NSNull null]) {
            filmItem.check = NO;
        }else{
            filmItem.check = ((NSNumber *)filmDic[@"check"]).boolValue;
        }
        
        filmItem.bookId = filmDic[@"bookId"];
        filmItem.cId = filmDic[@"cId"];
        filmItem.infoItemType = ((NSNumber *)filmDic[@"pointType"]).integerValue;

    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
        filmItem = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(filmItem, success);
    }
}


#pragma mark 获取活动预约明细
+ (void)loadActivityWithScheduleItem:(ScheduleItem *)scheduleItem  user:(User *)user callback:(void (^)(ActivityItem *activityItem, BOOL success))callback
{
    NSAssert(user.sid != nil, @"获取电影预约明细， user.sid 不能为空");
    NSAssert(scheduleItem.sid != nil, @"获取活动预约明细， orderItem.scheduleId 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/%li", kServerAddress, kActivitiesPath, user.sid.integerValue, scheduleItem.sid.integerValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToActivityWithRequest:result callback:^(ActivityItem *activityItem, BOOL success) {
                callback(activityItem, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToActivityWithRequest:(DataRequest *)request callback:(void (^)(ActivityItem *activityItem, BOOL success))callback
{
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    ActivityItem *actItem = [[ActivityItem alloc] init];
    @try {
        NSDictionary *actDic = dic[@"result"];
        actItem.sid =actDic[@"id"];
        actItem.scheduleId = actDic[@"scheduleId"];
        actItem.name = actDic[@"name"];
        actItem.titlePic =  actDic[@"titleDic"];
        actItem.pics = actDic[@"pics"];
        actItem.contents = actDic[@"contents"];
        actItem.address = actDic[@"address"];
        actItem.addressType = ((NSNumber *)actDic[@"addressType"]).intValue;
        actItem.activityDate = actDic[@"activityDate"];
        actItem.beginTime = actDic[@"beginTime"];
        actItem.endTime = actDic[@"endTime"];
        actItem.personType = actDic[@"personType"];
        actItem.maxBookNum = actDic[@"maxBookNum"];
        actItem.bookNum = actDic[@"bookNum"];
        actItem.browseNum = actDic[@"browseNum"];
        actItem.bookCode = actDic[@"bookCode"];
        actItem.bookDate = actDic[@"bookdDate"];
        if (actDic[@"check"] == [NSNull null]) {
            actItem.check = NO;
        }else
        {
            actItem.check = ((NSNumber *)actDic[@"check"]).boolValue;
        }
        
        actItem.bookId = actDic[@"bookId"];
        actItem.cId = actDic[@"cId"];
        actItem.infoItemType = ((NSNumber *)actDic[@"pointType"]).integerValue;
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
        actItem = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(actItem, success);
    }
}

#pragma mark 获取信息点的影片或活动信息合集
+ (void)loadOrdersWithFloor:(NSInteger)floorCode callback:(void (^)(NSArray *orders, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/mapDisplay", kServerAddress, kMyPreorderPath, floorCode];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToOrdersWithRequest:result callback:^(NSArray *orders, BOOL success) {
                callback(orders, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToOrdersWithRequest:(DataRequest *)request callback:(void (^)(NSArray *orders, BOOL success))callback
{
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }

    //
    NSMutableArray *orders = [NSMutableArray array];
    @try {
        for (NSDictionary *orderDic in dic[@"result"]) {
            OrderItem *orderItem = [[OrderItem alloc] init];
            orderItem.sid = orderDic[@"id"];
            orderItem.scheduleId = orderDic[@"scheduleId"];
            orderItem.preorderType = ((NSNumber *)orderDic[@"type"]).intValue;
            orderItem.cid = orderDic[@"cId"];
            orderItem.name = orderDic[@"name"];
            orderItem.beginTime = orderDic[@"beginTime"];
            
            NSNumber *x = orderDic[@"x"];
            NSNumber *y = orderDic[@"y"];
            orderItem.pt = CGPointMake(x.floatValue, y.floatValue);
            
            [orders addObject:orderItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
        orders = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(orders, success);
    }
}

#pragma mark 取消预约
+ (void)postCancelWithOrder:(OrderItem *)orderItem user:(User *)user callback:(void (^)(BOOL success))callback
{
    NSAssert(orderItem.sid != nil, @"取消预约， orderItem.sid不能为空");
    NSAssert(user.sid != nil, @"取消预约, user.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/cancel", kServerAddress, kPreorderCancelPath, orderItem.sid.integerValue];
    
    //TODO: 后台问题，没有测试
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"result: %@", result.responseString);
        callback(success);
    }];
    
    [request setPostValue:user.sid forKey:@"userId"];
    [request startAsynchronous];
}

#pragma mark 记录浏览数
+ (void)postPreorderBrowseCountWithItem:(NSObject *)item callback:(void (^)(BOOL success))callback
{
#warning 在没有网络的情况下，没有缓存浏览数，丢失浏览数
    NSNumber *sid;
    PreorderType preorderType = PreorderOther;
    
    if ([item isKindOfClass:[FilmItem class]]) {
        sid = ((FilmItem *)item).sid;
        preorderType = PreorderFilm;
    }
    
    if ([item isKindOfClass:[ActivityItem class]]) {
        sid = ((ActivityItem *)item).sid;
        preorderType = PreorderActivity;
    }
    
    if ([item isKindOfClass:[OrderItem class]]) {
        OrderItem *orderItem = (OrderItem *)item;
        NSAssert(orderItem.cid != nil, @"记录浏览数， orderItem.sid不能为空");
        sid = orderItem.cid;
        preorderType = orderItem.preorderType;
    }
    
    NSAssert(sid != nil, @"记录浏览数: 活动或影片id不能为空");
    NSAssert(preorderType != PreorderOther, @"记录浏览数: 未知的预约类型");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kPreorderBrowsePath];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        NSLog(@"记录浏览数: %@", result.responseString);
    }];
    
    request.showHUD = NO;
    [request setPostValue:sid forKey:@"cId"];
    [request setPostValue:[NSNumber numberWithInteger:preorderType] forKey:@"type"];
    [request startAsynchronous];
}

#pragma mark - 投票 （互动社区)
#warning 暂缓开发

#pragma mark - 参观路线 （互动社区)
#pragma mark 根据关键字获取展馆资源
+ (void)loadRouteWithKeyword:(NSString *)keyword callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSAssert(keyword != nil && ![keyword isEqualToString:@""], @"根据关键字获取展馆资源， keyword不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?keyword=%@", kServerAddress, kRoutesKeywordPath, keyword];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            //
            [DataManager convertToInfosWithRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

#pragma mark 获取公共设施列表
///根据用户的所在楼层搜索同一楼层的所有公共设施，并按照用户所在位置与公共设施距离由近到远排序。参数x或y坐标为空的情况下视为点击更多查询其他所有楼层的公共设施，不排序
+ (void)loadFacilityWithFloor:(FloorType)floor point:(CGPoint)pt callback:(void (^)(NSArray *facilities, BOOL success))callback
{
    //处理CGPointZero
    NSString *urlString;
    if (CGPointEqualToPoint(pt, CGPointZero)) {
        urlString = [NSString stringWithFormat:@"%@%@?fCode=%i", kServerAddress, kFacilityPath, floor];
    }else{
        urlString = [NSString stringWithFormat:@"%@%@?fCode=%i&x=%f&y=%f", kServerAddress, kFacilityPath, floor, pt.x, pt.y];
    }
    
    //TODO:没有数据,需要修改convertToInfos
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToInfosWithRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    
    request.cache = YES;
    [request startAsynchronous];
}

#pragma mark 获取推荐路线
+ (void)loadRecommendRoutes:(void (^)(NSArray *routes, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kRecommendRoutePath];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToRecommendRouteWithRequest:result callback:^(NSArray *recommends, BOOL success) {
                callback(recommends, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
    
}

+ (void)convertToRecommendRouteWithRequest:(DataRequest *)request callback:(void (^)(NSArray *recommends, BOOL success))callback
{
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //
    NSMutableArray *recommends = [NSMutableArray array];
    @try {
        for (NSDictionary *rDic in dic[@"result"]) {
            RecommendRouteItem  *item= [[RecommendRouteItem alloc] init];
            item.sid = rDic[@"id"];
            item.title = rDic[@"title"];
            item.introduction = rDic[@"introduction"];
           
            NSMutableArray *routeRooms = [NSMutableArray array];
            for (NSDictionary *roomsDic in rDic[@"routeRooms"]) {
                InfoItem *infoItem = [[InfoItem alloc] init];
                infoItem.sid = roomsDic[@"id"];
                infoItem.title = roomsDic[@"name"];
                infoItem.iconPath = roomsDic[@"icon"];
                
                [routeRooms addObject:infoItem];
            }
            item.routesRooms = routeRooms;

            [recommends addObject:item];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
        recommends = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(recommends, success);
    }
}

#pragma mark 推荐路线引导点
+ (void)loadInfoItemsWithRecommendRoute:(RecommendRouteItem *)recommendRouteItem callback:(void (^)(NSArray *infos, BOOL successs))callback
{
    NSAssert(recommendRouteItem.sid != nil, @"获取推荐路线引导点， recommendRouteItem.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li", kServerAddress, kRecommendRoutePath, recommendRouteItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToInfosWithRecommedRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToInfosWithRecommedRequest:(DataRequest *)request callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSMutableArray *infos = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *infoDic in dic[@"result"]) {
            InfoItem *iItem = [[InfoItem alloc] init];
            iItem.floorCode = infoDic[@"fCode"];
            NSNumber *x = infoDic[@"x"];
            NSNumber *y = infoDic[@"y"];
            iItem.pt = CGPointMake(x.floatValue, y.floatValue);
            [infos addObject:iItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(infos, success);
    }
}

#pragma mark 最热门参观路线
+ (void)loadPraiseRoute:(void (^)(NSArray *infos, BOOL success))callback
{
    
    //TODO:没有数据未能测试
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kPraiseRoutePath];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            //
            [DataManager convertToInfosWithPraiseRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}


+ (void)convertToInfosWithPraiseRequest:(DataRequest *)request callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSMutableArray *infos = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *infoDic in dic[@"result"]) {
            InfoItem *iItem = [[InfoItem alloc] init];
            iItem.sid = infoDic[@"sid"];
            iItem.title = infoDic[@"name"];
            iItem.iconPath = infoDic[@"icon"];
            if (infoDic[@"praiseNum"] == [NSNull null]) {
                iItem.praise = @0;
            }else{
                iItem.praise = infoDic[@"praiseNum"];
            }
            
            [infos addObject:iItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(infos, success);
    }
}

#pragma mark 最热门参观引导点
+ (void)loadPraiseRouteInfoItems:(void (^)(NSArray *infos, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kPraiseRouteGuidePath];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToInfosWithRecommedRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    request.cache = YES;
    [request startAsynchronous];
}

#pragma mark 用户自定义寻路
+ (void)loadPathWithFloor:(FloorType)floor point:(CGPoint)point targetInfoItem:(InfoItem *)infoItem callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSAssert(infoItem.sid != nil, @"用户自定义寻路, infoItem.sid 不能为空");
    NSAssert(infoItem.type == InfoItemSpecimen || infoItem.type == InfoItemExhibit || infoItem.type == InfoItemRemoteVideo || InfoItemShowroom, @"用户自定义寻路, infoItem.type 必须为标本背后故事、展品、远程视屏或展区");
    
    NSString *urlString;
    if (CGPointEqualToPoint(point, CGPointZero)) {
        urlString =[NSString stringWithFormat:@"%@%@?fCode=%i&type=%i&cid=%li&isIn=%i", kServerAddress, kFindingPath, floor, infoItem.type, infoItem.sid.integerValue, 1];
    }else{
        urlString =[NSString stringWithFormat:@"%@%@?x=%f&y=%f&fCode=%i&type=%i&cid=%li&isIn=%i", kServerAddress, kFindingPath, point.x, point.y, floor, infoItem.type, infoItem.sid.integerValue, 1];
    }
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            //
            [DataManager convertToInfosWithRecommedRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

#pragma mark 自定义规化路线
+ (void)loadCustomRouteWithFloor:(FloorType)floor point:(CGPoint)point routes:(NSArray *)infos callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSAssert(infos != nil && infos.count > 0, @"自定义规划路线，routes不能为空");
    
    NSString *routeString =@"";
    for (InfoItem *item in infos) {
        NSNumber *type = [NSNumber numberWithInteger:item.type];
        [routeString stringByAppendingString:type.stringValue];
        [routeString stringByAppendingString:@","];
        [routeString stringByAppendingString:item.sid.stringValue];
        [routeString stringByAppendingString:@";"];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?x=%f&y=%f&fCode=%i&routes=%@&isIn=%i", kServerAddress, kCustomRoutePath, point.x, point.y, floor, routeString, 1];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToInfosWithRecommedRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else
        {
            callback(nil, success);
        }
    }];

    [request startAsynchronous];
}

#pragma mark - 寻宝游戏
#pragma mark 查询所有游戏主题
+ (void)loadGameThemesInView:(UIView *)view callback:(void (^)(NSArray *themes, BOOL success))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerAddress, kGameThemesPath];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToThemesWithRequest:result callback:^(NSArray *themes, BOOL success) {
                callback(themes, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    if (view != nil) {
        request.hudSuperView = view;
    }
    
    request.cache = YES;
    [request startAsynchronous];
    
}

+ (void)convertToThemesWithRequest:(DataRequest *)request callback:(void (^)(NSArray *themes, BOOL success))callback
{
    NSMutableArray *themes = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        NSDictionary *results = dic[@"result"];
        for (NSDictionary *themeDic in results) {
            GameThemeItem *themeItem = [[GameThemeItem alloc] init];
            themeItem.sid = themeDic[@"id"];
            themeItem.title = themeDic[@"title"];
            themeItem.titlePic = themeDic[@"titlePic"];
            themeItem.introduction = themeDic[@"introduction"];
            
            [themes addObject:themeItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(themes, success);
    }
}

#pragma mark 游戏任务列表
+ (void)loadGameTasksWithTheme:(GameThemeItem *)themeItem inView:(UIView *)view callback:(void (^)(NSArray *gameTasks, BOOL success))callback
{
    NSAssert(themeItem.sid != nil, @"获取游戏人物列表， themeItem.sid 不能为空");
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/taskList", kServerAddress, kGameTaskPath, themeItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToTasksWithRequest:result callback:^(NSArray *gameTasks, BOOL success) {
                callback(gameTasks, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    if (view != nil) {
        request.hudSuperView = view;
    }
    
    request.cache = YES;
    [request startAsynchronous];
}

+ (void)convertToTasksWithRequest:(DataRequest *)request callback:(void (^)(NSArray *gameTasks, BOOL success))callback
{
    
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    NSMutableArray *tasks = [NSMutableArray array];
    @try {
        NSDictionary *results = dic[@"result"];
        for (NSDictionary *taskDic in results) {
            GameTaskItem *taskItem = [[GameTaskItem alloc] init];
            taskItem.sid = taskDic[@"id"];
            taskItem.tid = taskDic[@"tid"];
            taskItem.title = taskDic[@"title"];
            taskItem.prompt = taskDic[@"prompt"];
            taskItem.titlePic = taskDic[@"titlePic"];
            taskItem.desc = taskDic[@"description"];
            taskItem.score = taskDic[@"score"];
            taskItem.status = ((NSNumber *)taskDic[@"status"]).boolValue;
            
            [tasks addObject:taskItem];
        }
    }
    @catch (NSException *exception) {
        message = exception.description;
        success = NO;
        tasks = nil;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(tasks, success);
    }

}

#pragma mark 游戏任务相关展品的信息点
+ (void)loadExhibitsWithGameTheme:(GameThemeItem *)themeItem callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSAssert(themeItem.sid != nil, @"获取游戏任务相关展品的信息点， themeItem.sid 不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/exhibitList", kServerAddress, kGamePath, themeItem.sid.integerValue];
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        if (success) {
            [DataManager convertToInfosWithGameRequest:result callback:^(NSArray *infos, BOOL success) {
                callback(infos, success);
            }];
        }else{
            callback(nil, success);
        }
    }];
    
    [request startAsynchronous];
}

+ (void)convertToInfosWithGameRequest:(DataRequest *)request callback:(void (^)(NSArray *infos, BOOL success))callback
{
    NSMutableArray *infos = [NSMutableArray array];
    NSString *message;
    BOOL success = YES;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
    
    //JSON 错误
    if(error != nil)
    {
        message = error.description;
        success = NO;
    }
    
    //格式错误
    @try {
        for (NSDictionary *infoDic in dic[@"result"]) {
            InfoItem *iItem = [[InfoItem alloc] init];
            iItem.sid = infoDic[@"id"];
            iItem.title = infoDic[@"title"];
            iItem.iconPath = infoDic[@"icon"];
            iItem.relationId = infoDic[@"relationshipId"];
            iItem.gameTaskId = infoDic[@"gameTaskId"];
            NSNumber *x = infoDic[@"x"];
            NSNumber *y = infoDic[@"y"];
            iItem.pt = CGPointMake(x.floatValue, y.floatValue);
            iItem.floorCode = infoDic[@"floorCode"];
            
            [infos addObject:iItem];
        }
    }
    @catch (NSException *exception) {
        success = NO;
        message = exception.description;
    }
    @finally {
        if (request.showError && !success) {
            [DataManager showMessage:message dur:request.errorDur];
        }
        callback(infos, success);
    }
}

#pragma mark Game Check
+ (void)loadCheckWithGameTask:(GameTaskItem *)taskItem user:(User *)user infoItem:(InfoItem *)infoItem callback:(void (^)(BOOL success))callback
{
    NSAssert(taskItem.sid != nil, @"Game check, taskItem.sid不能为空");
    NSAssert(user.sid != nil,  @"Game check, user.sid不能为空");
    NSAssert(infoItem.sid != nil,  @"Game check, infoItem.sid不能为空");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%li/check", kServerAddress, kGamePath, taskItem.sid.integerValue];
    
    DataRequest *request = [DataManager requestWithURL:[NSURL URLWithString:urlString] callback:^(DataRequest *result, BOOL success) {
        callback(success);
    }];
    
    //request.requestMethod = @"POST";
    [request setPostValue:user.sid forKey:@"userId"];
    [request setPostValue:infoItem.sid forKey:@"exhibitId"];
    [request startAsynchronous];
}

#pragma mark - DataManagaer默认State code 处理
+ (DataRequest *)requestWithURL:(NSURL *)url callback:(void (^)(DataRequest *result, BOOL success))callback
{
    DataRequest *request = [LXDataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
        if (success) {
            //获取State code
            NSError *error = nil;
            NSString *message = @"未知错误";
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result.responseData options:NSJSONReadingMutableContainers error:&error];
            
            //JSON 格式错误
            if (error != nil) {
                success = NO;
                message = error.debugDescription;
            }
            
            //code 错误
            NSInteger code = -1;
            @try {
                //
                code = ((NSNumber *)dic[@"code"]).integerValue;
                message = dic[@"msg"];
            }
            @catch (NSException *exception) {
                //
                success = NO;
                message = exception.description;
            }
            @finally {
                //Code码
                switch (code) {
                    case -1:
                        //
                        success = NO;
                        break;
                        
                    case 1:
                        //
                        success = YES;
                        break;
                        
                    default:
                        message = @"未知接口错误";
                        success = NO;
                        break;
                }
                
                if (!success && result.showError) {
                    [DataManager showMessage:message dur:result.errorDur];
                }
                
            }
        }
    
        callback(result, success);
    }];
    
    return request;
}

#pragma mark - 图片下载
+ (void)loadPicWithPath:(NSString *)picPath inView:(UIView *)view callback:(void (^)(UIImage *image, BOOL useCache, BOOL success))callback
{
    //NSAssert(picPath != nil && ![picPath isEqualToString:@""], @"获取图片，picPath不能为空");
    
    [DataManager loadSystem:^(SystemItem *systemItem, BOOL success) {
        if (success) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", systemItem.resourceBaseUrl, picPath];
            NSURL *url = [NSURL URLWithString:urlString];

            
            DataRequest *request = [LXDataManager requestWithURL:url callback:^(DataRequest *result, BOOL success) {
                
                if (success) {
                    UIImage *image =  [UIImage imageWithData:result.responseData];
                    callback(image, result.didUseCachedResponse, success);
                }else{
                    callback(nil, result.didUseCachedResponse,success);
                }
                //
            }];
            
            if (view != nil) {
                request.hudSuperView = view;
            }
            
            request.cache = YES;
            request.hud.mode = MBProgressHUDModeIndeterminate;
            request.hud.color = [UIColor clearColor];
        
            [request startAsynchronous];
            
        }else{
            callback(nil, NO, success);
        }
    }];
}

#pragma mark - 信息显示
+ (void)showMessage:(NSString *)message dur:(CGFloat)dur
{
    MBProgressHUD *errorHUD = nil;
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    errorHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    errorHUD.removeFromSuperViewOnHide = YES;
    errorHUD.mode = MBProgressHUDModeText;
    errorHUD.detailsLabelText = message;
    [errorHUD show:YES];
    
    [errorHUD hide:YES afterDelay:dur];
}

#pragma mark - 定位
+ (void)startLocate:(void (^)(NSString *result, BOOL success))callback
{
    GCDAsyncUdpSocket *udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:[DataManager shareDataManager] delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    if (![udpSocket bindToPort:61111 error:&error]) {
        NSLog(@"socket error: error binding %@", error.description);
        callback(nil, NO);
        return;
    }
    
    if (![udpSocket beginReceiving:&error]) {
        NSLog(@"socket error: error receiving: %@", error.description);
        
        return;
    }
    
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSLog(@"ip:%@", [GCDAsyncUdpSocket hostFromAddress:[sock localAddress]]);
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"upd messsage: %@", message);
    
    NSArray *results = [message componentsSeparatedByString:@","];
    
    LocateItem *item = [[LocateItem alloc] init];
    
    @try {
        CGFloat x = ((NSString *)results[1]).integerValue/3.125f;
        CGFloat y = ABS(((NSString *)results[2]).integerValue)/3.125f;
        item.pt = CGPointMake(x, y);
        item.isIn = ((NSString *)results[3]).boolValue;
        item.floorType = ((NSString *)results[4]).intValue;
        item.areaID = ((NSString *)results[5]).intValue;
        item.ip = results[6];
    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        [[NSNotificationCenter defaultCenter ]postNotificationName:@"DataManagerLocate" object:nil userInfo:@{@"locateItem":message}];
    }
}



@end
