//
//  SecondNavView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-24.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "NavView.h"

@implementation NavView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"SlidingTabsControl.drawRect()");
    // Set background gradient
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient, shadow_glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[3] = { 0.0f, 1.0f };
    CGFloat shadow_locations[3] = { 0.0f, 0.8f };
    CGFloat components[8] = { 1.0/255.0f, 1.0/255.0f, 0/255.0f, 1.0,
        81.0/255.0f, 135.0/255.0f, 193/255.0f, 0.8 };
    
    CGFloat shadow_components[8] = { 81.0/255.0f, 135.0/255.0f, 193/255.0f, 0.8,
        81.0/255.0f, 135.0/255.0f, 193/255.0f, 0.1 };
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    shadow_glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, shadow_components, shadow_locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    NSLog(@"topCenter{x:%2f, y:%2f}  midCenter{x:%2f, y:%2f}", topCenter.x, topCenter.y, midCenter.x, midCenter.y);
    
    //绘制渐变效果
    //CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    CGContextDrawLinearGradient(currentContext, glossGradient, CGPointMake(0.0, 40.0), CGPointMake(0.0, 0.0), 0);
    
    //底部阴影
    CGContextDrawLinearGradient(currentContext, shadow_glossGradient, CGPointMake(0.0, 40.0), CGPointMake(0.0, 43.0), 0);
    
    CGGradientRelease(glossGradient);
    CGGradientRelease(shadow_glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
}

@end
