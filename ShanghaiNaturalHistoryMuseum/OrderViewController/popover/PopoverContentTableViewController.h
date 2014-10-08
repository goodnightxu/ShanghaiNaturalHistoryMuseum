//
//  PopoverContentTableViewController.h
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-26.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopoverContentTableViewControllerDelegate <NSObject>

-(void)didSelectContentForItem:(NSString *)item;

@end



@interface PopoverContentTableViewController : UITableViewController

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,weak)id<PopoverContentTableViewControllerDelegate>delegate;

@end

