//
//  PopoverButton.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-27.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WEPopoverController.h>
#import "PopoverContentTableViewController.h"

@protocol PopoverButtonDelegate <NSObject>

-(void)didSelectPopoverButtonForItem:(NSString *)item;

@end


@interface PopoverButton : UIButton<PopoverContentTableViewControllerDelegate,WEPopoverControllerDelegate>

@property(nonatomic,weak)id<PopoverButtonDelegate>delegate;
@property(nonatomic,copy)NSString *selectedItem;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withData:(NSArray *)dataArray;

@end
