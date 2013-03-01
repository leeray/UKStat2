//
//  HeadView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-27.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "HeadView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(currentContext, [UIColor redColor].CGColor);
    
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float greid = 10.0;
    
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, width, 0);
    CGContextAddLineToPoint(currentContext, width-2*greid, height);
    CGContextAddLineToPoint(currentContext, 0+2*greid, height);
    CGContextAddLineToPoint(currentContext, 0, 0);
    CGContextSaveGState(currentContext);
    CGContextClip(currentContext);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        81.0/255.0f, 135.0/255.0f, 193/255.0f, 0.8,
        1.0/255.0f, 1.0/255.0f, 0/255.0f, 1.0
        
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(currentContext, gradient, CGPointMake(width/2+greid, 0), CGPointMake(width/2+greid,height), 0);
    CGContextRestoreGState(currentContext);
    
}


@end
