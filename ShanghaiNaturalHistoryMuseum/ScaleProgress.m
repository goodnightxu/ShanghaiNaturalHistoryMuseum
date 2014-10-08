//
//  ScaleView.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/29.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "ScaleProgress.h"

@interface ScaleProgress()
{
    CALayer *_maskLayer;
    CGFloat _scaleHeight;
    
    //放大缩小按钮
    UIButton *_zoomInBt;
    UIButton *_zoomOutBt;
}

@end

@implementation ScaleProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //
        //背景
        UIImageView *scaleBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleBarBg.png"]];
        scaleBg.frame = self.bounds;
        [self addSubview:scaleBg];
        
        //Track
        UIImage *progressImage = [UIImage imageNamed:@"scaleBarProgress.png"];
        CGSize scaleSize = progressImage.size;
        UIView *scaleProgress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scaleSize.width, scaleSize.height-2.0f)];
        scaleProgress.center = CGPointMake(frame.size.width * 0.5 -2, frame.size.height * 0.5 -2);
        scaleProgress.layer.contents = (__bridge id)([UIImage imageNamed:@"scaleBarProgress.png"].CGImage);
        [scaleProgress sizeToFit];
        //Track mask
        _maskLayer = [CALayer layer];
        _maskLayer.contents = (__bridge id)([UIImage imageNamed:@"scaleProgressMask.png"].CGImage);
        _maskLayer.frame = scaleProgress.bounds;
        scaleProgress.layer.mask = _maskLayer;
        _scaleHeight = scaleSize.height;

        self.progress = 0.0f;
        [self addSubview:scaleProgress];
        
        //放大按钮
        _zoomInBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomInBt setImage:[UIImage imageNamed:@"zoomInBt.png"] forState:UIControlStateNormal];
        _zoomInBt.frame = CGRectMake(0, 0, 44, 44);
        _zoomInBt.center =  CGPointMake(frame.size.width * 0.5 - 2, 25);
        [_zoomInBt addTarget:self action:@selector(onZoomInBt) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zoomInBt];
        
        //缩小
        _zoomOutBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomOutBt setImage:[UIImage imageNamed:@"zoomOutBt.png"] forState:UIControlStateNormal];
        _zoomOutBt.frame = CGRectMake(0, 0, 44, 44);
        _zoomOutBt.center =  CGPointMake(frame.size.width * 0.5 - 2, 180);
        [_zoomOutBt addTarget:self action:@selector(onZoomOutBt) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zoomOutBt];

    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _zoomInBt.enabled = YES;
    _zoomOutBt.enabled = YES;
    if (progress >=1.0) {
        progress = 1.0;
        _zoomInBt.enabled = NO;
    }
    
    if (progress <= 0.0f) {
        progress = 0.0f;
        _zoomOutBt.enabled = NO;
    }
    
    _progress = progress;
    CGFloat offsetY = (_scaleHeight - 4.0f) * (1.0 - progress);
    _maskLayer.transform = CATransform3DMakeTranslation(0, offsetY, 0);
}

#pragma mark - Button
#pragma mark 放大
- (void)onZoomInBt
{
    if (self.onZoomIn != nil) {
        self.onZoomIn();
    }
}

#pragma mark 缩小
- (void)onZoomOutBt
{
    if (self.onZoomOut != nil) {
        self.onZoomOut();
    }
}

@end
