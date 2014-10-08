//
//  LineMatchAnswer.h
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-30.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineMatchAnswer : UIView

- (id)initWithFrame:(CGRect )frame title:(NSString *)title;

-(void)setRight;
-(void)setWrong;
-(void)animate;

@end
