//
//  InfoView.m
//  NSStringRetainCountTest
//
//  Created by Shaolie on 15/8/22.
//  Copyright (c) 2015年 LinShaoLie. All rights reserved.
//

#import "WechatView.h"

#define RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

UIColor *color = nil;


@implementation WechatView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //0. 填充背景
    //将当前context的颜色填充为bkColor
    [self.bkColor setFill];
    //填充颜色到当前的context上，大小为rect
    CGContextFillRect(context, rect);

    //阴影
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 6, [UIColor blackColor].CGColor);
    CGContextBeginTransparencyLayer(context, nil);

    //绘制的最小宽度
    CGFloat minWidth = MAX(160, rect.size.width);
    
    //定义绿色椭圆位置和大小
    CGFloat greenX = 10;
    CGFloat greenY = 10;
    CGFloat greenCircleWidth = minWidth/1.5;
    CGFloat greenCircleHeight = 21.0/24 * greenCircleWidth;
    CGFloat gcW = greenCircleWidth;
    CGFloat gcH = greenCircleHeight;
    
    //椭圆左边焦点
    CGFloat greenCircleFocusLeft = gcW/2-sqrt(pow(gcW/2, 2)-pow(gcH/2, 2));
    //椭圆右边焦点
    CGFloat greenCircleFocusRight = gcW/2+sqrt(pow(gcW/2, 2)-pow(gcH/2, 2));
    CGFloat gcFL = greenCircleFocusLeft;
    CGFloat gcFR = greenCircleFocusRight;
    
    //眼睛大小
    CGFloat eyesWidth1 = gcW/7.5;
    //1. 先画椭圆
    UIColor *greenColor = RGB(125, 225, 73, 1);
    [greenColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(greenX, greenY, greenCircleWidth, greenCircleHeight));

    //2. 画三角形
    //-4x = y          0.55x = y
    CGPoint points[] = {
        CGPointMake(gcFL-eyesWidth1, greenY + gcH + (gcFL-eyesWidth1)/12-10),
        CGPointMake(greenX+gcW/2+40, 1.2*(greenX+gcW/2) + greenY),
        CGPointMake(gcFL+10, 1.8*gcFL + greenY)};
    CGContextAddLines(context, points, 3);
    
    CGContextClosePath(context);
    //    CGContextFillPath(context);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, greenColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextEndTransparencyLayer(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 2, [UIColor blackColor].CGColor);

    //3. 画眼睛（圆）
    [RGB(45, 49, 32, 1) setFill];
    CGContextFillEllipseInRect(context, CGRectMake(greenX + gcFL, greenY+gcH/4, eyesWidth1, eyesWidth1));
    CGContextFillEllipseInRect(context, CGRectMake(greenX + gcFR-eyesWidth1, greenY+gcH/4, eyesWidth1, eyesWidth1));

    CGContextBeginTransparencyLayer(context, nil);
    //4. 画白色椭圆
    CGFloat wcX = greenX + gcW / 2;
    CGFloat wcY = greenY + gcH / 2;
    CGFloat wcW = gcW * 0.8;
    CGFloat wcH = gcH * 0.8;
    
    CGFloat whiteCircleFocusLeft = wcW/2-sqrt(pow(wcW/2, 2)-pow(wcH/2, 2));
    CGFloat whiteCircleFocusRight = wcW/2+sqrt(pow(wcW/2, 2)-pow(wcH/2, 2));
    CGFloat wcFL = whiteCircleFocusLeft;
    CGFloat wcFR = whiteCircleFocusRight;
    
    CGFloat eyesWidth2 = wcW/7.5;
    
    UIColor *whiteColor = RGB(251, 251, 251, 1);

    [whiteColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(wcX, wcY, wcW, wcH));
    
    
    //5. 画白色三角形
    CGPoint whiteTrianglePoints[] = {
        CGPointMake(wcFR+eyesWidth2/4+wcX, wcY + wcH + (wcFL-eyesWidth2/4)/4),
        CGPointMake(wcX+wcW/2, 0.9*(wcX+wcW/2)),
        CGPointMake(wcFR+eyesWidth2, 0.9*wcFR + wcY)};
    CGContextAddLines(context, whiteTrianglePoints, 3);
    CGContextClosePath(context);
//    CGContextFillPath(context);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //6. 画眼睛（圆）
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 2, [UIColor blackColor].CGColor);

    [RGB(60, 64, 49, 1) setFill];
    CGContextFillEllipseInRect(context, CGRectMake(wcX + wcFL, wcY + wcH/4, eyesWidth2, eyesWidth2));
    CGContextFillEllipseInRect(context, CGRectMake(wcX + wcFR - eyesWidth2, wcY + wcH/4, eyesWidth2, eyesWidth2));
    CGContextEndTransparencyLayer(context);
    
    
    
}

//- (void)prepareForInterfaceBuilder {
//    [super prepareForInterfaceBuilder];
//    
//    self.backgroundColor = self.bkColor;
//}


@end
