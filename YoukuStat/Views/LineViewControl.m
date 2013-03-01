//
//  LineViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-7.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "LineViewControl.h"
#import <QuartzCore/QuartzCore.h>
#import "PCLineChartView.h"
#import "NSObject_VvDatas.h"
#import "TestTouchView.h"
#import "PCLineChartViewComponent.h"

@implementation LineViewControl
@synthesize datalist;
@synthesize showType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    [self initLineView:rect];
}

- (void) initLineView:(CGRect)rect{
    
    int width = CGRectGetWidth(rect);
    int height = CGRectGetHeight(rect);
    
    
    NSLog(@"LineViewControl.initLineView() x:%d   y:%d   width:%f   height:%f", width, height, [self bounds].size.width-20, [self bounds].size.height-20);
    //lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(width,height,[self bounds].size.width-10,[self bounds].size.height-20)];
    lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    
    lineChartView.datalist = datalist;
    [lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    lineChartView.minValue = 0;
    lineChartView.maxValue = 500000;
    lineChartView.autoscaleYAxis=YES;
    
    int y_large_point = 0;
    NSMutableString *tmp_vv_str;
    NSRange substr;
    NSString *search = @",";
    NSString *replace = @"";
    
    NSMutableArray *x_label_array = [[NSMutableArray alloc] init];
    NSMutableArray *vvArray = [[NSMutableArray alloc] init];
    NSMutableArray *invvArray = [[NSMutableArray alloc] init];
    NSMutableArray *outvvArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *components = [NSMutableArray array];
    NSMutableArray *showDatas = [NSMutableArray array];
    PCLineChartViewComponent *vvcomponent = [[PCLineChartViewComponent alloc] init];
    [vvcomponent setTitle:[NSString stringWithFormat:@"总%@", showType]];
    [vvcomponent setShouldLabelValues:NO];
    [vvcomponent setColour:PCColorYellow];
    PCLineChartViewComponent *invvcomponent = [[PCLineChartViewComponent alloc] init];
    [invvcomponent setTitle:[NSString stringWithFormat:@"站内%@", showType]];
    [invvcomponent setShouldLabelValues:NO];
    [invvcomponent setColour:PCColorGreen];
    PCLineChartViewComponent *outvvcomponent = [[PCLineChartViewComponent alloc] init];
    [outvvcomponent setTitle:[NSString stringWithFormat:@"站外%@", showType]];
    [outvvcomponent setShouldLabelValues:NO];
    [outvvcomponent setColour:PCColorBlue];
    for (int i = 0; i < datalist.count; i++) {
        
        VvDatas *vvData = (VvDatas*)[datalist objectAtIndex:i];
        ShowDataLabel *showData = [ShowDataLabel alloc];
        showData.date = vvData.date;
        showData.showType = showType;
        if ([showType isEqualToString:@"VV"]) {
            [vvArray addObject:[self replaceComma:[vvData vv]]];
            [invvArray addObject:[self replaceComma:[vvData vv_in_sum]]];
            [outvvArray addObject:[self replaceComma:[vvData vv_out_sum]]];
            showData.all_num = [vvData vv];
            showData.in_num = [vvData vv_in_sum];
            showData.out_num = [vvData vv_out_sum];
        }else if([showType isEqualToString:@"UV"]){
            [vvArray addObject:[self replaceComma:[vvData uv_sum]]];
            [invvArray addObject:[self replaceComma:[vvData in_play_uv]]];
            [outvvArray addObject:[self replaceComma:[vvData out_play_uv]]];
            showData.all_num = [vvData uv_sum];
            showData.in_num = [vvData in_play_uv];
            showData.out_num = [vvData out_play_uv];
        }else{
            [vvArray addObject:[self replaceComma:[vvData all_ts_hour]]];
            [invvArray addObject:[self replaceComma:[vvData in_ts_hour]]];
            [outvvArray addObject:[self replaceComma:[vvData out_ts_hour]]];
            showData.all_num = [vvData all_ts_hour];
            showData.in_num = [vvData in_ts_hour];
            showData.out_num = [vvData out_ts_hour];
        }
        [showDatas addObject:showData];
        [x_label_array addObject:[vvData date]];
    }
    [vvcomponent setPoints:vvArray];
    [invvcomponent setPoints:invvArray];
    [outvvcomponent setPoints:outvvArray];
    
    [components addObject:vvcomponent];
    [components addObject:invvcomponent];
    [components addObject:outvvcomponent];
    
    
    for (int i = 0; i<vvArray.count; i++){
        tmp_vv_str = [[NSMutableString alloc] initWithString:[vvArray objectAtIndex:i]];
        substr = [tmp_vv_str rangeOfString:search];
        while (substr.location != NSNotFound) {
            [tmp_vv_str replaceCharactersInRange:substr withString:replace];
            substr = [tmp_vv_str rangeOfString:search];
        }
        int temp_num = [tmp_vv_str intValue];
        
        if (temp_num > y_large_point){
            y_large_point = temp_num;
        }
    }
    
    int y_large = [self getY_large_point:y_large_point];
    NSLog(@"y_large:%d", y_large);
    lineChartView.maxValue = y_large;

    [lineChartView setComponents:components];
    [lineChartView setXLabels:x_label_array];
    
    
    lineChartView.datalist = showDatas;

    [self addSubview:lineChartView];
}

//替换逗号
- (NSString*) replaceComma:(NSString *)str{
    NSMutableString *tmp_vv_str;
    NSRange substr;
    NSString *search = @",";
    NSString *replace = @"";
    tmp_vv_str = [[NSMutableString alloc] initWithString:str];
    substr = [tmp_vv_str rangeOfString:search];
    while (substr.location != NSNotFound) {
        [tmp_vv_str replaceCharactersInRange:substr withString:replace];
        substr = [tmp_vv_str rangeOfString:search];
    }
    
    return tmp_vv_str;
}

- (int) getY_large_point:(int)large_y{
    NSString *tmp_a = [NSString stringWithFormat:@"%d", large_y];
    
    int tmp_len = [tmp_a length];
    
    NSString *head_a = [tmp_a substringToIndex:1];
    
    int head_num = [head_a intValue] + 1;
    
    NSMutableString *wei_str = [[NSMutableString alloc]init];
    for (int i = 1; i < tmp_len; i++){
        [wei_str appendString:@"0"];
    }
    
    NSString *result = [NSString stringWithFormat:@"%d%@", head_num, wei_str];
    
    return [result intValue];
}


@end
