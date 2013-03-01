//
//  NSObject+PCLineChartViewComponent.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-24.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCLineChartViewComponent : NSObject
{
    NSString *title;
    NSArray *points;
    UIColor *colour;
	BOOL shouldLabelValues;
    NSString *labelFormat;
}
@property (nonatomic, assign) BOOL shouldLabelValues;
@property (nonatomic, retain) NSArray *points;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title, *labelFormat;
@end
