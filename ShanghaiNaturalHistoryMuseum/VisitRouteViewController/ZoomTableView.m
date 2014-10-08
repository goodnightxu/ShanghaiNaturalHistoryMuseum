//
//  ZoomTableView.m
//  SHNaturalMuseum
//
//  Created by Michael Lu on 14-9-9.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ZoomTableView.h"

@implementation ZoomTableView

@synthesize cellZoomXScaleFactor = _xZoomFactor;
@synthesize cellZoomYScaleFactor = _yZoomFactor;
@synthesize cellZoomAnimationDuration = _animationDuration;
@synthesize cellZoomInitialAlpha = _initialAlpha;



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && currentMaxDisplayedCell == 0) || indexPath.section > currentMaxDisplayedSection){ //first item in a new section, reset the max row count
        currentMaxDisplayedCell = -1; //-1 because the check for currentMaxDisplayedCell has to be > rather than >= (otherwise the last cell is ALWAYS animated), so we need to set this to -1 otherwise the first cell in a section is never animated.
    }
    
    if (indexPath.section >= currentMaxDisplayedSection && indexPath.row > currentMaxDisplayedCell){ //this check makes cells only animate the first time you view them (as you're scrolling down) and stops them re-animating as you scroll back up, or scroll past them for a second time.
        
        //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
        
        float dur;

        if (self.showsVerticalScrollIndicator==NO) {
            dur=self.cellZoomAnimationDuration.floatValue*(indexPath.row/4.0+1);
        } else {
            dur=self.cellZoomAnimationDuration.floatValue;
        }
        
        cell.contentView.alpha = self.cellZoomInitialAlpha.floatValue;
        
        CGAffineTransform transformScale = CGAffineTransformMakeScale(self.cellZoomXScaleFactor.floatValue, self.cellZoomYScaleFactor.floatValue);
        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset.floatValue, self.cellZoomYOffset.floatValue);
        
        cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        
        [self bringSubviewToFront:cell.contentView];
        [UIView animateWithDuration:dur
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.contentView.alpha = 1;
                             //clear the transform
                             cell.contentView.transform = CGAffineTransformIdentity;
                         } completion:nil];
        
        
        currentMaxDisplayedCell = indexPath.row;
        currentMaxDisplayedSection = indexPath.section;
    }
}

-(void)resetViewedCells{
    currentMaxDisplayedSection = 0;
    currentMaxDisplayedCell = 0;
}

#pragma -mark Setters for four customisable variables
-(void)setCellZoomXScaleFactor:(NSNumber *)xZoomFactor{
    _xZoomFactor = xZoomFactor;
}
-(void)setCellZoomYScaleFactor:(NSNumber *)yZoomFactor{
    _yZoomFactor = yZoomFactor;
}
-(void)setCellZoomAnimationDuration:(NSNumber *)animationDuration{
    _animationDuration = animationDuration;
}
-(void)setCellZoomInitialAlpha:(NSNumber *)initialAlpha{
    _initialAlpha = initialAlpha;
}

#pragma -mark Getters for four customisable variable. Provide default if not set.
-(NSNumber *)cellZoomXScaleFactor{
    if (_xZoomFactor == nil){
        _xZoomFactor = [NSNumber numberWithFloat:2.25];
    }
    return _xZoomFactor;
}
-(NSNumber *)cellZoomYScaleFactor{
    if (_yZoomFactor == nil){
        _yZoomFactor = [NSNumber numberWithFloat:2.25];
    }
    return _yZoomFactor;
}
-(NSNumber *)cellZoomXOffset{
    if (_cellZoomXOffset == nil){
        _cellZoomXOffset = [NSNumber numberWithFloat:0];
    }
    return _cellZoomXOffset;
}
-(NSNumber *)cellZoomYOffset{
    if (_cellZoomYOffset == nil){
        _cellZoomYOffset = [NSNumber numberWithFloat:20.0];
    }
    return _cellZoomYOffset;
}
-(NSNumber *)cellZoomAnimationDuration{
    if (_animationDuration == nil){
        _animationDuration = [NSNumber numberWithFloat:1.0f];
    }
    return _animationDuration;
}
-(NSNumber *)cellZoomInitialAlpha{
    if (_initialAlpha == nil){
        _initialAlpha = [NSNumber numberWithFloat:0.0f];
    }
    return _initialAlpha;
}

@end
