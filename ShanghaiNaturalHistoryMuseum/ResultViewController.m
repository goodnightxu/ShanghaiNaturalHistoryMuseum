//
//  ResultViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/3.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "ResultViewController.h"
#import "ExhibitItem.h"
#import "DataManager.h"
#import "GlowLabel.h"



#pragma mark - Exhibit Button
//大button
#define kBigRaidus 165.0f
//小button
#define kLittlRaidus 123.0f

@interface ExhibitButton()
{
    
    CALayer *_iconLayer;
    CGFloat _radius;
    UIColor *_holeColor;
    
    UIFont *_nameFont;
    UIColor *_nameColor;
    
    UIFont *_latinFont;
    UIColor *_latinColor;
}

@end

@implementation ExhibitButton

- (id)initWithExhibit:(ExhibitItem *)exhibitItem
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.exhibitItem = exhibitItem;
        
        //Config
        //非远亲和近邻
        _radius = kBigRaidus*0.5;
        _holeColor = [UIColor whiteColor];
        _nameFont = [UIFont fontWithName:kFontHeitiLight size:24];
        _nameColor = kColorBlack1;
        _latinFont = [UIFont fontWithName:kFontDidotItalic size:12];
        _latinColor = kColorGary1;
        
        //近邻
        if (self.exhibitItem.relation == ExhibitRelationNeighbour) {
            _radius = kLittlRaidus*0.5;
            _holeColor =kColorNeighbour;
            _nameFont = [UIFont fontWithName:kFontHeitiLight size:15];
            _nameColor = kColorGary1;
        }
        
        //远亲
        if (self.exhibitItem.relation == ExhibitRelationDistant) {
            _radius = kLittlRaidus*0.5;
            _holeColor = kColorDistant;
            _nameFont = [UIFont fontWithName:kFontHeitiLight size:15];
            _nameColor= kColorBlack1;
        }
        
        //
        [self initializeUI];
        
    }
    
    return self;
}

- (void)initializeUI
{
    self.frame = CGRectMake(0, 0, _radius*2, _radius*2);
    
    self.iconBt = [[UIButton alloc] initWithFrame:self.bounds];
    self.iconBt.backgroundColor = [UIColor whiteColor];
    self.iconBt.layer.borderColor = _holeColor.CGColor;
    self.iconBt.layer.borderWidth = 4;
    self.iconBt.layer.cornerRadius = _radius;
    self.iconBt.clipsToBounds = YES;
    self.iconBt.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconBt];
    
    [self.iconBt setBackgroundImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    [self.iconBt setContentMode:UIViewContentModeCenter];

    //Name
    NSString *name = self.exhibitItem.name;
    NSString *latinName = nil;
    if (self.exhibitItem.relation == ExhibitRelationDistant) {
        name = [NSString stringWithFormat:@"%@%@", @"远亲", self.exhibitItem.name];
        latinName = self.exhibitItem.latinName;
    }
    
    if (self.exhibitItem.relation == ExhibitRelationNeighbour) {
        name = [NSString stringWithFormat:@"%@%@", @"近邻", self.exhibitItem.name];
        latinName = self.exhibitItem.latinName;
    }
    
    //
    GlowLabel *nameLabel = [[GlowLabel alloc] initWithFrame:CGRectMake(0, _radius*2 +8, _radius*2, 24)];
    nameLabel.text = name;
    nameLabel.font = _nameFont;
    nameLabel.textColor = _nameColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:nameLabel];

    GlowLabel *latinLabel = [[GlowLabel alloc] initWithFrame:CGRectMake(0, _radius*2 +8+24+2 , _radius*2, 12)];
    latinLabel.font = _latinFont;
    latinLabel.textColor = _latinColor;
    latinLabel.textAlignment = NSTextAlignmentCenter;
    latinLabel.text = self.exhibitItem.latinName;
    latinLabel.shadowColor = [UIColor whiteColor];
    [self addSubview:latinLabel];
    
}

#pragma mark - 加载按钮图片
- (void)showImage
{
    [DataManager loadPicWithPath:self.exhibitItem.iconPath inView:self callback:^(UIImage *image, BOOL useCaceh, BOOL success) {
        if (success) {
            
            [self.iconBt setImage:image forState:UIControlStateNormal];
            self.iconBt.imageView.alpha = 0.0f;
            [UIView animateWithDuration:1.0 animations:^{
                self.iconBt.imageView.alpha = 1.0f;
            }];
        }
    }];
}

@end


#pragma mark - Info Button 

#define kIconWidth 40
#define kIconHeight 50

@interface InfoButton()
{
    CGFloat _radius;
}

@end

@implementation InfoButton
- (id) initWithType:(InfoButtonType )type exhibitItem:(ExhibitItem *)exhibitItem
{
    self = [super init];
    if (self) {
        self.exhibitItem = exhibitItem;
        self.type = type;
        
        [self initializeUI];
    }
    
    return self;
}

- (void)initializeUI
{
    //默认的更多信息的配置 褐色底、小图标
    _radius = kLittlRaidus * 0.5;
    UIColor *bgColor = Color(85, 71, 61, 1);
    NSString *titleString = @"更多信息";
    UIColor *titleColor = [UIColor whiteColor];
    CGPoint titlePt;
    //位置和大小
    if (self.type != InfoButtonMore) {
        _radius = kBigRaidus *0.5;
    }
    self.frame = CGRectMake(0, 0, _radius, _radius);
    CGPoint center = viewCenter(self.bounds);
    //
    if (self.type != InfoButtonMore) {
        //
        bgColor = [UIColor whiteColor];
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconWidth, kIconHeight)];
        [self addSubview:iconImageView];
        NSString *iconName;
        switch (self.type) {
            case InfoButtonStory:
                iconName = @"specimenIcon.png";
                titleString = @"背后故事";
                break;
            case InfoButtonLoacate:
                iconName = @"locateIcon.png";
                titleString = @"展品位置";
                break;
            case InfoButtonInfo:
                iconName = @"remoteVideoIcon.png";
                titleString = @"展品信息";
                break;
            default:
                break;
        }
        iconImageView.image = [UIImage imageNamed:iconName];
        
        iconImageView.center = CGPointMake(center.x, center.y - kIconHeight *0.5);

        
        //Title Color
        titleColor = Color(153, 153, 153, 1);
        //
        titlePt = CGPointMake(center.x, center.y+18+8);
    }else
    {
        titlePt = center;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, 18)];
    [self addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:kFontHeitiLight size:18];
    titleLabel.textColor = titleColor;
    titleLabel.center = titlePt;
    titleLabel.text = titleString;
    
    //背景
    CAShapeLayer *holeLayer = [CAShapeLayer layer];
    holeLayer.frame = self.bounds;
    holeLayer.fillColor = bgColor.CGColor;
    holeLayer.shouldRasterize = NO;
    UIBezierPath *holePath = [UIBezierPath bezierPathWithArcCenter:viewCenter(self.bounds) radius:_radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    holeLayer.path = holePath.CGPath;
    [self.layer insertSublayer:holeLayer atIndex:0];
}

@end

#pragma mark - Rusult View Controller

#define kRaidus 231.0f
@interface ResultViewController ()
{
    UIImageView *_ring;
    
    //Ring
    UIView *_animationRing;
    CAShapeLayer *_rightLayer;
    CAShapeLayer *_leftLayer;
    
    //
    InfoButton *_storyBt;
    InfoButton *_locateBt;
    InfoButton *_infoBt;
    InfoButton *_moreBt;
    //
    
    UIView *_moreView;
    UIWebView *_webView;
}

@end

@implementation ResultViewController

- (id)initWihtExhibitItem:(ExhibitItem *)exhibitItem relationItems:(NSArray *)relationItems
{
    self  = [super init];
    if (self) {
        self.exhibitItem = exhibitItem;
        self.exhibitItem.relation = -1;
        self.relationItems = relationItems;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    if (_ring == nil) {
        [self initializeUI];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initializeUI
{
    //ring
    _ring = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ring.png"]];
    [_ring sizeToFit];
    _ring.center = self.view.center;
    [self.view addSubview:_ring];
    
    //动画显示的环
    _animationRing = [[UIView alloc] initWithFrame:_ring.frame];
    _animationRing.alpha = 0;
    [self.view addSubview:_animationRing];

     
    //远亲、近邻Button
    //间隔角度
    CGFloat angle = 360.0f / self.relationItems.count;
    //动画时间
    CGFloat aniDur = 0.75;
    //单个button动画间隔
    CGFloat delay = aniDur/self.relationItems.count;
    
    //动画 button逐个从中间滑倒外圈
    for (NSInteger index = 0; index < self.relationItems.count; index++) {
        ExhibitItem *item = self.relationItems[index];
        ExhibitButton *exhibitBt = [[ExhibitButton alloc] initWithExhibit:item];
        exhibitBt.center = self.view.center;
        [exhibitBt.iconBt addTarget:self action:@selector(onExhibitBt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exhibitBt];
        
        
        [UIView animateWithDuration:0.25 delay:delay*index options:UIViewAnimationOptionCurveLinear animations:^{
            CGFloat x = cosf((angle*index - 90.0)* M_PI/180.0f) * kRaidus;
            CGFloat y = sinf((angle*index - 90.0)* M_PI/180.0f) * kRaidus;
            exhibitBt.center = CGPointMake(self.view.center.x + x, self.view.center.y + y);
            exhibitBt.originPt = exhibitBt.center;
        } completion:nil];
    }
    
    
    //主Button
    //等远亲、近邻显示完了，再动画出现主Button
    ExhibitButton *exhibitBt =  [[ExhibitButton alloc] initWithExhibit:self.exhibitItem];
    [self.view addSubview:exhibitBt];
    exhibitBt.center = self.view.center;
    exhibitBt.originPt = exhibitBt.center;
    exhibitBt.alpha = 0.0f;
    [exhibitBt.iconBt addTarget:self action:@selector(onExhibitBt:) forControlEvents:UIControlEventTouchUpInside];
    [exhibitBt showImage];
    
    [UIView animateWithDuration:0.25 delay:delay*self.relationItems.count options:UIViewAnimationOptionCurveLinear animations:^{
        exhibitBt.alpha = 1.0f;
    }completion:^(BOOL finished) {
       
    }];
    //加载图片
    [self performSelector:@selector(onLoadIcon) withObject:nil afterDelay:aniDur+0.25];
}

#pragma mark 动画
//button 全部从中间移动到指定位置后，远亲、近邻加载图片
- (void)onLoadIcon
{
    for (ExhibitButton *exhibitBt in self.view.subviews) {
        if ([exhibitBt isKindOfClass:[ExhibitButton class]]) {
            if (exhibitBt.exhibitItem.relation == ExhibitRelationDistant || exhibitBt.exhibitItem.relation == ExhibitRelationNeighbour ) {
                [exhibitBt showImage];
            }
        }
    }
}

#pragma mark - Button
- (void)onExhibitBt:(UIButton *)selectedBt
{
    ExhibitButton *exhibitBt = (ExhibitButton *)selectedBt.superview;
    
    if (!selectedBt.selected) {
        selectedBt.selected = YES;
        //除自身外所有Bt 隐藏
        for (ExhibitButton *exhibitBt in self.view.subviews) {
            if (exhibitBt != selectedBt.superview && [exhibitBt isKindOfClass:[ExhibitButton class]]) {
                [UIView animateWithDuration:0.25 animations:^{
                    exhibitBt.alpha = 0.0;
                }];
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            _ring.alpha = 0.0f;
        }];
        
        
        //被点击的bt移动到中间
        CGFloat aniDur = 0.5f;
                [self exhibitBtToTop:exhibitBt aniDur:aniDur complete:^{
            [self showAnimationRingWithExhibitItem:exhibitBt.exhibitItem];
            //显示背后故事，展品位置，展品信息，跟多信息
            [self showInfoBtWithExhibitItem:exhibitBt aniDur:aniDur];
        }];

    }else{
        [self hideInfoBt];
        
        
        [self exhibitBtGoback:exhibitBt aniDur:0.25 delay:0.25 complete:^{
            for (ExhibitButton *exhibitBt in self.view.subviews) {
                if (exhibitBt != selectedBt.superview && [exhibitBt isKindOfClass:[ExhibitButton class]]) {
                    [UIView animateWithDuration:0.25 animations:^{
                        exhibitBt.alpha = 1.0;
                    }];
                }
                
                [UIView animateWithDuration:0.25 animations:^{
                    _ring.alpha = 1.0f;
                }];
            }
            
            selectedBt.selected = NO;
        }];
    }
    
}


#pragma mark 选择的按钮移动到顶部
- (void)exhibitBtToTop:(ExhibitButton *)exhibitButton aniDur:(CGFloat)aniDur complete:(void (^)())complete
{
    [UIView animateWithDuration:aniDur animations:^{
        CGFloat x = cosf( -90.0 * M_PI/180.0f) * kRaidus;
        CGFloat y = sinf( -90.0 * M_PI/180.0f) * kRaidus;
        exhibitButton.center = CGPointMake(self.view.center.x + x, self.view.center.y + y);
    }completion:^(BOOL finished) {
        complete();
    }];
}


#pragma mark 选择的按钮退回到起始位置
- (void)exhibitBtGoback:(ExhibitButton *)exhibitButton aniDur:(CGFloat)aniDur delay:(CGFloat)delay complete:(void (^)())complete
{
    [UIView animateWithDuration:aniDur delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        exhibitButton.center = exhibitButton.originPt;
    }completion:^(BOOL finished) {
        complete();
    }];
}


#pragma mark 逐个显示InfoBt
- (void)showInfoBtWithExhibitItem:(ExhibitButton *)selectedBt aniDur:(CGFloat)aniDur
{
    if (_storyBt == nil) {
        _storyBt = [[InfoButton alloc] initWithType:InfoButtonStory exhibitItem:selectedBt.exhibitItem];
        CGFloat x = cosf( 180 * M_PI/180.0f) * kRaidus;
        CGFloat y = sinf( 180 * M_PI/180.0f) * kRaidus;
        _storyBt.center = CGPointMake(self.view.center.x+x, self.view.center.y+y);
        _storyBt.alpha = 0.0f;
        [_storyBt addTarget:self action:@selector(onStoryBt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_storyBt];
        
        [UIView animateWithDuration:0.25 delay:aniDur * 0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            _storyBt.alpha = 1.0f;
        } completion:nil];
    }
    
    if (_locateBt == nil) {
        //Loacte
        _locateBt = [[InfoButton alloc] initWithType:InfoButtonLoacate exhibitItem:selectedBt.exhibitItem];
        _locateBt.center = self.view.center;
        _locateBt.alpha = 0.0f;
        [_locateBt addTarget:self action:@selector(onLocateBt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_locateBt];
        
        [UIView animateWithDuration:0.25 delay:aniDur + 0.25 options:UIViewAnimationOptionCurveLinear animations:^{
            _locateBt.alpha = 1.0f;
        } completion:nil];
    }
    
    if (_infoBt == nil) {
        //Info
        _infoBt = [[InfoButton alloc] initWithType:InfoButtonInfo exhibitItem:selectedBt.exhibitItem];
        CGFloat x = cosf( 0 * M_PI/180.0f) * kRaidus;
        CGFloat y = sinf( 0 * M_PI/180.0f) * kRaidus;
        _infoBt.center = CGPointMake(self.view.center.x+x, self.view.center.y+y);
        _infoBt.alpha = 0.0f;
        [self.view addSubview:_infoBt];
        [UIView animateWithDuration:0.25 delay:aniDur * 0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            _infoBt.alpha = 1.0f;
        } completion:nil];
    }
    
    if (_moreBt == nil) {
        //More
        _moreBt = [[InfoButton alloc] initWithType:InfoButtonMore exhibitItem:selectedBt.exhibitItem];
        CGFloat x = cosf( 90 * M_PI/180.0f) * kRaidus;
        CGFloat y = sinf( 90 * M_PI/180.0f) * kRaidus;
        _moreBt.center = CGPointMake(self.view.center.x+x, self.view.center.y+y);
        _moreBt.alpha = 0.0f;
        [_moreBt addTarget:self action:@selector(onMoreBt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_moreBt];
        [UIView animateWithDuration:0.25 delay:aniDur options:UIViewAnimationOptionCurveLinear animations:^{
            _moreBt.alpha = 1.0f;
        } completion:nil];
    }
}

#pragma mark 隐藏InfoBt 和 animationRing
- (void)hideInfoBt
{
    [UIView animateWithDuration:0.25 animations:^{
        _animationRing.alpha = 0.0f;
        
        _storyBt.alpha = 0.0f;
        _locateBt.alpha = 0.0f;
        _infoBt.alpha = 0.0f;
        _moreBt.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [_storyBt removeFromSuperview];
        _storyBt = nil;
        
        [_locateBt removeFromSuperview];
        _locateBt = nil;
        
        [_infoBt removeFromSuperview];
        _infoBt = nil;
        
        [_moreBt removeFromSuperview];
        _moreBt = nil;
        
    }];
}


#pragma mark animationRing 打开动画
- (void)showAnimationRingWithExhibitItem:(ExhibitItem *)exhibitItem
{
    _animationRing.alpha = 1.0f;
    CGFloat lineWidth = 2;
    
    UIColor *lineColor = [UIColor whiteColor];
    
    if (exhibitItem.relation == ExhibitRelationDistant) {
        lineColor = kColorDistant;
    }
    if (exhibitItem.relation == ExhibitRelationNeighbour) {
        lineColor = kColorNeighbour;
    }
    
    if (_rightLayer == nil) {
        _rightLayer= [CAShapeLayer layer];
        [_animationRing.layer addSublayer:_rightLayer];
        
        _leftLayer = [CAShapeLayer layer];
        [_animationRing.layer addSublayer:_leftLayer];
    }
    _leftLayer.frame = _animationRing.bounds;
    _rightLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLayer.lineWidth = lineWidth;
    _rightLayer.strokeColor = lineColor.CGColor;
    _rightLayer.shouldRasterize = YES;
    
    _leftLayer.frame = _animationRing.bounds;
    _leftLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLayer.lineWidth = lineWidth;
    _leftLayer.strokeColor = lineColor.CGColor;
    _leftLayer.shouldRasterize = YES;

    
    UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:viewCenter(_animationRing.bounds) radius:kRaidus- _rightLayer.lineWidth *0.5 startAngle:-90.0f/180.0f*M_PI endAngle:90.0f/180.0f*M_PI clockwise:YES];
    _rightLayer.path = rightPath.CGPath;
    
    UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:viewCenter(_animationRing.bounds) radius:kRaidus- _rightLayer.lineWidth *0.5 startAngle:-90.0f/180.0f*M_PI endAngle:90.0f/180.0f*M_PI clockwise:NO];
    _leftLayer.path= leftPath.CGPath;
    
    CABasicAnimation *pathAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAni.duration = 0.75;
    pathAni.fromValue =@0.0;
    pathAni.toValue= @1.0;
    
    [_rightLayer addAnimation:pathAni forKey:nil];
    [_leftLayer addAnimation:pathAni forKey:nil];
}


#pragma mark - Button
- (void)onMoreBt:(UIButton *)bt
{
    if (_moreView.superview == nil) {
        _moreView = [[UIView alloc] initWithFrame:self.view.bounds];
        _moreView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        [self.view addSubview:_moreView];
        //webview
        _webView = [[UIWebView alloc] initWithFrame:_moreView.bounds];
        [_moreView addSubview:_webView];
        //backButton
        UIButton *backBt = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 42, 42)];
        [backBt setImage:[UIImage imageNamed:@"learnbook_info_back.png"] forState:UIControlStateNormal];
        [backBt addTarget:self action:@selector(onWebBack:) forControlEvents:UIControlEventTouchUpInside];
        [_moreView addSubview:backBt];

        
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        NSString *urlString = [NSString stringWithFormat:@"http://www.baidu.com/s?dsp=ipad&wd=%@", self.exhibitItem.name];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }];
}

- (void)onStoryBt:(UIButton *)bt
{
    
    if (self.onStoryBt != nil) {
        __weak ResultViewController *weakSelf = self;
        [DataManager loadExhibitDetailWithExhibit:self.exhibitItem callback:^(ExhibitItem *exhibitItem, BOOL success) {
            if (success) {
                weakSelf.onStoryBt(exhibitItem);
            }
        }];
    }
}

- (void)onLocateBt:(ExhibitButton *)bt
{
    if (self.onLocateBt != nil) {
        __weak ResultViewController *weakSelf = self;
        [DataManager loadExhibitPositionWithExhibit:bt.exhibitItem callback:^(InfoItem *infoItem, BOOL success) {
            if (success)
            {
                weakSelf.onLocateBt(infoItem);
            }
        }];
    }
}

- (void)onWebBack:(UIButton *)bt
{
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    }completion:^(BOOL finished) {
        [_moreView removeFromSuperview];
    }];
}




@end
