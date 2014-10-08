//
//  DetailTextView.m
//  
//
//  Created by Mac Pro on 4/27/12.
//  Copyright (c) 2012 Dawn. All rights reserved.
//

#import "DetailTextView.h"
#import <CoreText/CoreText.h>

@implementation DetailTextView

@synthesize showShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        showShadow=@"NO";
        resultAttributedString = [[NSMutableAttributedString alloc]init];
    }
    return self;
}
-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color{
    self.font=font;
    
    self.text = text;
    int len = [text length];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:text];
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)color.CGColor range:NSMakeRange(0, len)];
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize,NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont2 range:NSMakeRange(0, len)];
    CFRelease(ctFont2);
    resultAttributedString = mutaString;
}
-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor{
    NSMutableArray *rangeArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [keyWordArray count]; i++) {
        NSString *keyString = [keyWordArray objectAtIndex:i];
        NSRange range = [self.text rangeOfString:keyString];
        NSValue *value = [NSValue valueWithRange:range];
        if (range.length > 0) {
            [rangeArray addObject:value];
        }
    }
    for (NSValue *value in rangeArray) {
        NSRange keyRange = [value rangeValue];
        [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:keyRange];
        CTFontRef ctFont1 = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize,NULL);
        [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont1 range:keyRange];
        CFRelease(ctFont1);
        
    }

}

-(void)setKeyWordTextString:(NSString *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor{
    NSMutableArray *rangeArray = [[NSMutableArray alloc]init];
    NSRange range = [self.text rangeOfString:keyWordArray];
    NSValue *value = [NSValue valueWithRange:range];
    if (range.length > 0) {
        [rangeArray addObject:value];
    }
    for (NSValue *value in rangeArray) {
        NSRange keyRange = [value rangeValue];
        [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:keyRange];
        CTFontRef ctFont1 = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize,NULL);
        [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont1 range:keyRange];
        CFRelease(ctFont1);
        
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.text !=nil) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, 0.0, 0.0);//move
//        CGContextScaleCTM(context, 1.0, -1.0);
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)resultAttributedString);
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));//const CGAffineTransform *m
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );//CFDictionaryRef frameAttributes
//        CGContextTranslateCTM(context, 0, -self.bounds.size.height);
//        CGContextSetTextPosition(context, 0, 0);
//        CTFrameDraw(frame, context);
//        CGContextRestoreGState(context);
//        CGPathRelease(pathRef);
//        CFRelease(framesetter);
//        UIGraphicsPushContext(context);
//
        
        
        
        
        if ([showShadow isEqualToString:@"YES"]) {
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            
            CGMutablePathRef path1 = CGPathCreateMutable();
            CGPathAddRect(path1, NULL, CGRectMake(0, -1, self.bounds.size.width, self.bounds.size.height));
            
            
            int len = [self.text length];
            UIColor *blackcolor=[UIColor blackColor];
            NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:self.text];
            [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                               value:(id)blackcolor.CGColor
                               range:NSMakeRange(0, len)];
            CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize,NULL);
            [mutaString addAttribute:(NSString *)(kCTFontAttributeName)
                               value:(__bridge id)ctFont2
                               range:NSMakeRange(0, len)];
            CFRelease(ctFont2);
            
            
            CTFramesetterRef framesetter1 = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mutaString);
            
            CTFrameRef frame1=CTFramesetterCreateFrame(framesetter1,
                                                       CFRangeMake(0, 0), path1, NULL);
            
            CGContextSetTextMatrix(context1, CGAffineTransformIdentity);
            CGContextTranslateCTM(context1, 0, self.bounds.size.height);
            CGContextScaleCTM(context1, 1.0, -1.0);
            
            CTFrameDraw(frame1, context1);
            
            CFRelease(frame1);
            CFRelease(path1);
            CFRelease(framesetter1);
        }
        
        
        
        
        
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //第一步：设置drawing text的bound，ios中只能是矩形
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds );
        
        //第二步：NSAttributedString是nsstring的衍生类，可用于格式化文本
        //1、不格式化属性
        //NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello core text world!"];
        //2、使用MarkupParser格式化属性
        //MarkupParser *mParser=[[MarkupParser alloc] init];
        //NSAttributedString *attString=[mParser attrStringFromMarkup:@"Hello <font color=\"red\">core text <font color=\"blue\">world!"];
        
        //第三步：核心部分(声明CTFramesetter，然后创建一个或多个呈现text的frame,CTTypesetter自动生成，用于处理font),
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)resultAttributedString);
        
        //CTFrame(text的总范围)-CTLine(表示一行)-CTRun(表示一行中相同格式的一块)
        //注意：我不用创建CTRun,core text在已有的NSAttributedString的属性的基础上为我创建
        CTFrameRef frame =CTFramesetterCreateFrame(framesetter,
                                                   CFRangeMake(0, 0), path, NULL);
      
        //第步:UIKit drawing、core text drawing都是y翻坐标系，需要转换
        if ([showShadow isEqualToString:@"NO"]) {
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
        }
       
        
        //第步：绘制
        CTFrameDraw(frame, context);
        
        //第步：释放
        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
        
        
        
        


    }

}


@end
