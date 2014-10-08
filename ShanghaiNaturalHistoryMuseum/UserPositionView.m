//
//  UserPositionView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/10/5.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "UserPositionView.h"

@interface UserPositionView()

{
    UIView *_ring;
}

@end

@implementation UserPositionView


- (id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 52, 52);
        [self initializeUI];
    }
    
    return self;
}

- (void)initializeUI
{
    _ring = [[UIView alloc] initWithFrame:self.bounds];
    _ring.layer.cornerRadius = _ring.bounds.size.width *0.5f;
    _ring.backgroundColor = Color(51, 51, 51, 0.1);
    _ring.clipsToBounds = YES;
    [self addSubview:_ring];
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        _ring.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:nil];
    
    
    UIImageView *spot = [[UIImageView alloc] initWithFrame:self.bounds];
    spot.image = [UIImage imageNamed:@"userPosition.png"];
    [self addSubview:spot];
}

@end
