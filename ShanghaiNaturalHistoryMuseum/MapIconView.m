//
//  MapButton.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/1.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MapIconView.h"
#import "InfoItem.h"
#import "DataManager.h"

#define kIconWidth 42
#define kIconHeight 51

#define kThumbWidth 42
#define kThumbHeight 42

#define kThumbWidthOrigin 152
#define kThumbHeightOrigin 152

@interface MapIconView ()
{
    //Icon
    UIImageView *_iconView;
    UIImageView *_detailView;
    UIImageView *_thumb;
    UIImageView *_mask;
    
    //Title
    UILabel *_title;
    UILabel *_subTitle;
    
    //赞
    UIButton *_praiseBt;
    
    //
    UIButton *_closeBt;
    //导航到当前位置
    UIButton *_navBt;
    
    //Gesture
    //单击放大
    UITapGestureRecognizer *_zoomInGR;
    //单击显示详细信息
    UITapGestureRecognizer *_detailGR;
}

@end

@implementation MapIconView

@synthesize canEnglarge;
@synthesize isEnlarged;
@synthesize delegate;

- (id)initWithInfoItem:(InfoItem *)infoItem canEnglarge:(BOOL)flag
{
    self = [super init];
    if (self) {
        self.infoItem = infoItem;
        [self initializeUI:nil canEnglarge:flag];

    }
    
    return self;
}
- (id)initWithInfoItem:(InfoItem *)infoItem iconImageName:(NSString *)imageName canEnglarge:(BOOL)flag
{
    self = [super init];
    if (self) {
        self.infoItem = infoItem;
        [self initializeUI:imageName canEnglarge:flag];
        
    }
    
    return self;
}


- (void)initializeUI:(NSString *)imageName canEnglarge:(BOOL)flag
{
    canEnglarge=flag;
    isEnlarged=NO;
    
    CGRect frame = CGRectMake(self.infoItem.pt.x- kIconWidth * 0.5f, self.infoItem.pt.y- kIconHeight, kIconWidth, kIconHeight);
    self.frame = frame;
    
    //Bg
    NSString *_imageName;
    if (imageName) {
        _imageName=imageName;
    } else {
        switch (self.infoItem.type) {
            case InfoItemExhibit:
                _imageName = @"craftIcon.png";
                break;
            case InfoItemRemoteVideo:
                _imageName = @"remoteVideoIcon.png";
                break;
            case InfoItemSpecimen:
                _imageName = @"specimenIcon.png";
                break;
            case InfoItemGame:
                _imageName = @"gameTaskIcon.png";
                break;
            default:
                _imageName = @"craftIcon.png";
                break;
        }

    }
    
    _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
    _iconView.frame = self.bounds;
    [self addSubview:_iconView];
    
    _detailView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btBg.png"]];
    _detailView.frame = self.bounds;
    _detailView.alpha = 0.0f;
    [self addSubview:_detailView];
    
//    _thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tempImage.png"]];
//    _thumb.frame = CGRectMake(0, 0, kThumbWidth, kThumbHeight);
    _thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbWidth, kThumbHeight)];
    _thumb.layer.cornerRadius = kThumbWidth *0.5f;
    _thumb.clipsToBounds= YES;
    [DataManager loadPicWithPath:self.infoItem.iconPath inView:_iconView callback:^(UIImage *image, BOOL useCache, BOOL success) {
        if (success && image != nil) {
            _thumb.image = image;
        }else{
            _thumb.image = [UIImage imageNamed:@"tempImage.png"];
        }
        
    }];
    [_detailView addSubview:_thumb];
    
    _mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btBgMask.png"]];
    _mask.frame = self.bounds;
    [_detailView addSubview:_mask];
    
    //Label
    _title = [[UILabel alloc] initWithFrame:CGRectMake(-55, 51, kThumbWidthOrigin, 15)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = self.infoItem.title;
    _title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    _title.textColor = Color(102.0, 102.0, 102.0, 1.0);
    _title.alpha = 0.0f;
    [self addSubview:_title];
    
    _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(-55, 51+15, kThumbWidthOrigin, 12)];
    _subTitle.textAlignment = NSTextAlignmentCenter;
    _subTitle.text = self.infoItem.title;
    _subTitle.font = [UIFont fontWithName:@"Didot-Italic" size:12];
    _subTitle.textColor = Color(153.0, 153.0, 153.0, 1.0);
    _subTitle.alpha = 0.0f;
    [self addSubview:_subTitle];
    
    //赞
    _praiseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _praiseBt.layer.cornerRadius = 5;
    _praiseBt.backgroundColor = Color(255, 122, 132, 1.0);
    [_praiseBt setImage:[UIImage imageNamed:@"praiseIcon.png"] forState:UIControlStateNormal];
    [_praiseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _praiseBt.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:11];
    _praiseBt.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _praiseBt.alpha = 0.0f;
    NSString *praseString = [NSString stringWithFormat:@" %li人赞", (long)self.infoItem.praise.integerValue];
    [_praiseBt setTitle:praseString forState:UIControlStateNormal];
    
    [_praiseBt sizeToFit];
    [self addSubview:_praiseBt];
    
    //Close Button
    _closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBt setImage:[UIImage imageNamed:@"closeBt.png"] forState:UIControlStateNormal];
    [_closeBt sizeToFit];
    _closeBt.center = CGPointMake(137, 20);
    _closeBt.alpha = 0.0f;
    [_closeBt addTarget:self action:@selector(onCloseBt) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_closeBt];
    
    _navBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navBt setImage:[UIImage imageNamed:@"navBt.png"] forState:UIControlStateNormal];
    [_navBt sizeToFit];
    _navBt.center = CGPointMake(137+20, 20+30);
    _navBt.alpha= 0.0f;
    [_navBt addTarget:self action:@selector(onNavBt) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_navBt];
    
    
    
    //Gesture
    if (flag) {
        _zoomInGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onZoomInGR:)];
        [self addGestureRecognizer:_zoomInGR];
    }
    
    _detailGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailGR:)];
    
}

#pragma mark - Event
- (void)onZoomInGR:(UITapGestureRecognizer *)gr
{
    if (gr) {
        if ([delegate respondsToSelector:@selector(willEnglargeMapIconView:infoItem:)]) {
            [delegate willEnglargeMapIconView:self infoItem:self.infoItem];
        }
    }
    
    for (MapIconView *iconView in self.superview.subviews) {
        if ([iconView isKindOfClass:[MapIconView class]] && iconView!=self) {
            if (iconView.isEnlarged) {
                [iconView onCloseBt];
            }
        }
    }
    
    //Gesture
    [self removeGestureRecognizer:gr];
     _detailGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailGR:)];
    [self addGestureRecognizer:_detailGR];
    
    //
    [self.superview bringSubviewToFront:self];
    
    

    
    //显示大Icon
    [UIView animateWithDuration:0.20 animations:^{
        CGRect frame = CGRectMake(self.infoItem.pt.x- 152 * 0.5f, self.infoItem.pt.y - 191, 152, 191+50);
        self.frame = frame;
        CGRect iconFrame = CGRectMake(0, 0, 152.0, 191.0);
        _iconView.frame = iconFrame;
        _iconView.alpha = 0.5f;
        
        _detailView.frame = iconFrame;
        _detailView.alpha = 1.0f;
        
        _thumb.frame = CGRectMake(0, 0, kThumbWidthOrigin, kThumbHeightOrigin);
        _thumb.layer.cornerRadius = kThumbWidthOrigin *0.5f;
        
        _mask.frame = _detailView.bounds;
        
        //
        _title.frame = CGRectMake(0, 191+10, kThumbWidthOrigin, 15);
        _title.alpha = 1.0f;
        
        _subTitle.frame = CGRectMake(0, 191+10+ 15, kThumbWidthOrigin, 12);
        _subTitle.alpha = 1.0f;
        
        //
        _praiseBt.center = CGPointMake(kThumbWidthOrigin * 0.5, 191+10+15+15+12);
        _praiseBt.alpha = 1.0f;
        
    }completion:^(BOOL finished) {
        //
        [UIView animateWithDuration:0.15 animations:^{
            _closeBt.alpha = 1.0;
            _navBt.alpha = 1.0;
        }];
        isEnlarged=YES;
        
        if (self.alpha==0) {
            CGRect rect=self.frame;
            self.frame=CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, rect.size.height);
        }
       
    }];
}
- (void)onDetailGR:(UITapGestureRecognizer *)gr
{
    if ([delegate respondsToSelector:@selector(didTappedMapIconView:infoItem:)]) {
        [delegate didTappedMapIconView:self infoItem:self.infoItem];
    }
}

- (void)enlarge {
    if (!canEnglarge) {
        return;
    }
    if (isEnlarged) {
        return;
    }
    [self onZoomInGR:nil];
}

#pragma mark - Button
- (void)onCloseBt
{
    if (!isEnlarged) {
        return;
    }
    [UIView animateWithDuration:0.10 animations:^{
        _closeBt.alpha = 0.0f;
        _navBt.alpha = 0.0f;
        
    }completion:^(BOOL finished) {
        //
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = CGRectMake(self.infoItem.pt.x- kIconWidth * 0.5f, self.infoItem.pt.y - kIconHeight, kIconWidth, kIconHeight);
            self.frame = frame;
            _iconView.frame = self.bounds;
            _iconView.alpha = 1.0f;
            
            _detailView.frame = self.bounds;
            _detailView.alpha = 0.0f;
            
            _thumb.frame = CGRectMake(0, 0, kThumbWidth, kThumbHeight);
            _mask.frame = _detailView.bounds;
            
            _title.frame = CGRectMake(-55, 51, kThumbWidthOrigin, 15);
            _title.alpha = 0.0f;
            
            _subTitle.frame = CGRectMake(-55, 66, kThumbWidthOrigin, 12);
            _subTitle.alpha = 0.0f;
            
            _praiseBt.center = CGPointMake(kThumbWidth * 0.5, kThumbHeight);
            _praiseBt.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [self removeGestureRecognizer:_detailGR];
             _zoomInGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onZoomInGR:)];
            [self addGestureRecognizer:_zoomInGR];
            isEnlarged=NO;
        }];
    }];
}

- (void)onNavBt
{
    //TODO: 导航
    NSLog(@"导航至: %@", self.infoItem.title);
}

@end
