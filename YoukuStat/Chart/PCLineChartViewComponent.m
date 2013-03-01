//
//  NSObject+PCLineChartViewComponent.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-24.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "PCLineChartViewComponent.h"

@implementation PCLineChartViewComponent
@synthesize title, points, colour, shouldLabelValues, labelFormat;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.labelFormat = @"%.1f%%";
    }
    return self;
}

@end
