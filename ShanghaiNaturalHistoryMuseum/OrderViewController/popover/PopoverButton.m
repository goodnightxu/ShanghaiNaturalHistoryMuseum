//
//  PopoverButton.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-8-27.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "PopoverButton.h"

@implementation PopoverButton {
    WEPopoverController *popover;
    NSArray *dataArray;
}

@synthesize delegate;
@synthesize selectedItem;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withData:(NSArray *)contentDataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArray=[NSArray arrayWithArray:contentDataArray];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"order_arrow.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"order_arrow_shadow.png"] forState:UIControlStateSelected];
        self.titleLabel.font=[UIFont fontWithName:LanTingHei size:20.0f];
        [self setTitleColor:[UIColor whiteColor] forState:
         UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        PopoverContentTableViewController *contentViewController = [[PopoverContentTableViewController alloc] initWithStyle:UITableViewStylePlain];
        contentViewController.delegate=self;
        contentViewController.dataArray=[NSArray arrayWithArray:dataArray];
        popover = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        popover.delegate=self;

    }
    return self;
}


-(void)clickBtn:(UIButton *)sender {
    if ([popover isPopoverVisible]) {
        [popover dismissPopoverAnimated:YES];
    } else {
        [popover presentPopoverFromRect:self.frame
                                 inView:self.superview
               permittedArrowDirections:UIPopoverArrowDirectionUp
                               animated:YES];
        popover.backgroundView.backgroundColor=[UIColor clearColor];//这句必须在上一句后面

    }
}


#pragma WEPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
//    popover=nil;//用popoverController没效果
}

#pragma PopoverContentTableViewControllerDelegate
-(void)didSelectContentForItem:(NSString *)item {
    [popover dismissPopoverAnimated:YES];

    selectedItem=item;
//    [self setTitle:item forState:UIControlStateNormal];
    
    if ([delegate respondsToSelector:@selector(didSelectPopoverButtonForItem:)]) {
        [delegate didSelectPopoverButtonForItem:item];
    }
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
