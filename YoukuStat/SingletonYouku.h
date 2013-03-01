//
//  SingletonYouku.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-9.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *dataurl = @"http://10.103.13.15:8888";

@interface SingletonYouku : NSObject{
    //屏幕长宽
    CGFloat width;
    CGFloat height;
    
    //屏幕上图表的坐标
    CGFloat chart_x;
    CGFloat chart_y;
    CGFloat chart_width;
    CGFloat chart_height;
    
    CGFloat table_x;
    CGFloat table_y;
    CGFloat table_width;
    CGFloat table_height;
    
    CGFloat traffic_x;
    CGFloat traffic_y;
    CGFloat traffic_width;
    CGFloat traffic_height;
    
    CGFloat fromin_x;
    CGFloat fromin_y;
    CGFloat fromin_width;
    CGFloat fromin_height;
    
    CGFloat content_x;
    CGFloat content_y;
    CGFloat content_width;
    CGFloat content_height;
    
}

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGFloat chart_x;
@property (nonatomic,assign) CGFloat chart_y;
@property (nonatomic,assign) CGFloat chart_width;
@property (nonatomic,assign) CGFloat chart_height;

@property (nonatomic,assign) CGFloat table_x;
@property (nonatomic,assign) CGFloat table_y;
@property (nonatomic,assign) CGFloat table_width;
@property (nonatomic,assign) CGFloat table_height;

@property (nonatomic,assign) CGFloat traffic_x;
@property (nonatomic,assign) CGFloat traffic_y;
@property (nonatomic,assign) CGFloat traffic_width;
@property (nonatomic,assign) CGFloat traffic_height;

@property (nonatomic,assign) CGFloat fromin_x;
@property (nonatomic,assign) CGFloat fromin_y;
@property (nonatomic,assign) CGFloat fromin_width;
@property (nonatomic,assign) CGFloat fromin_height;

@property (nonatomic,assign) CGFloat content_x;
@property (nonatomic,assign) CGFloat content_y;
@property (nonatomic,assign) CGFloat content_width;
@property (nonatomic,assign) CGFloat content_height;

@end
