//
//  TestTouchView.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-24.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTouchView : UIView{
    NSMutableArray *components;
	NSMutableArray *xLabels;
	UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;
    float interval;
	float minValue;
	float maxValue;
    
    
    //touch操作变量
    CGPoint startTouchPosition;
    NSString *dirString;
    
    UIView *labelView;
    UILabel *allLabel;
    UILabel *inLabel;
    UILabel *outLabel;
    
    NSArray *datalist;
    
    // Use these to autoscale the y axis to 'nice' values.
    // If used, minValue is ignored (0) and interval computed internally
    BOOL autoscaleYAxis;
    NSUInteger numYIntervals;   // Use n*5 for best results
    
    
}

@property (nonatomic, assign) float interval;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, retain) NSMutableArray *components, *xLabels;
@property (nonatomic, retain) UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;
@property (nonatomic, assign) BOOL autoscaleYAxis;
@property (nonatomic, assign) NSUInteger numYIntervals;
@property (nonatomic, assign) NSUInteger numXIntervals;

- (void) initWithNN:(CGRect)rect;

@end
