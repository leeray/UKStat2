//
//  Singleton.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-9.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "SingletonYouku.h"


@implementation SingletonYouku

static SingletonYouku *_sharedInstance = nil;

@synthesize width;
@synthesize height;

@synthesize chart_x;
@synthesize chart_y;
@synthesize chart_width;
@synthesize chart_height;

@synthesize table_x;
@synthesize table_y;
@synthesize table_width;
@synthesize table_height;

@synthesize traffic_x;
@synthesize traffic_y;
@synthesize traffic_width;
@synthesize traffic_height;

@synthesize fromin_x;
@synthesize fromin_y;
@synthesize fromin_width;
@synthesize fromin_height;

@synthesize content_x;
@synthesize content_y;
@synthesize content_width;
@synthesize content_height;

+(SingletonYouku*)sharedInstance
{
    //dataurl = [[NSString alloc] initWithString:@"http://10.103.13.15:8888/"];
    if (!_sharedInstance) {
        //_sharedInstance = [NSAllocateObject([self class], 0, NULL) init];
    }
    return _sharedInstance;
}


+ (id)allocWithZone:(NSZone*)zone
{
    @synchronized(self){
        if(_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return _sharedInstance;
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}


@end
