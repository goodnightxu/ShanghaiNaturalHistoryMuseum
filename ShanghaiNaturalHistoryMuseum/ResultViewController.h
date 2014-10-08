//
//  ResultViewController.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/3.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExhibitItem;
@class InfoItem;

#pragma mark - Exhibit Button
///展品按钮
@interface ExhibitButton:UIView

@property (nonatomic, strong) ExhibitItem *exhibitItem;
@property (nonatomic, assign) CGPoint originPt;
@property (nonatomic, strong) UIButton *iconBt;

@end;


#pragma mark - InfoButton
typedef enum {
    InfoButtonStory,
    InfoButtonLoacate,
    InfoButtonInfo,
    InfoButtonMore,
}InfoButtonType;

/**消息按钮
 @breif 背后故事、展品位置、信息、更多
 */
@interface InfoButton : UIButton

@property (nonatomic, strong) ExhibitItem *exhibitItem;
@property (nonatomic, assign) InfoButtonType type;

@end


#pragma mark - Result View Controller
@interface ResultViewController : UIViewController

@property (nonatomic, strong) ExhibitItem *exhibitItem;
@property (nonatomic, strong) NSArray *relationItems;

///Events
@property (nonatomic, strong) void (^onStoryBt)(ExhibitItem *exhibitItem);
@property (nonatomic, strong) void (^onLocateBt)(InfoItem *infoItem);

- (id)initWihtExhibitItem:(ExhibitItem *)exhibitItem relationItems:(NSArray *)relationItems;

@end
