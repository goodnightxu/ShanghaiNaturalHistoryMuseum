//
//  ShakeAndDeleteView.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-17.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShakeAndDeleteView;

@protocol ShakeAndDeleteViewDelegate <NSObject>

@optional
-(void)willDeleteView:(ShakeAndDeleteView *)shakeView;
-(void)didStartShake:(ShakeAndDeleteView *)shakeView;

@end

@interface ShakeAndDeleteView : UIView

@property(nonatomic,weak)id<ShakeAndDeleteViewDelegate>delegate;
@property(nonatomic,assign,readonly)BOOL isShaking;
@property(nonatomic,assign)BOOL canShake;//default=YES
@property(nonatomic,strong)UIButton *deleteButton;
-(void)startShake;
-(void)stopShake;

@end
