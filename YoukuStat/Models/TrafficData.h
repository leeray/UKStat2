//
//  NSObject+TrafficData.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManage.h"


@protocol TrafficDataDelegate;

@interface TrafficData : NSObject <CacheManageDelegate>{
    NSObject <TrafficDataDelegate> *delegate;
    int siteid;
    CacheManage *cacheManage;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *paramURl;

- (void) getPcMobileTrafficData:(NSObject <TrafficDataDelegate>*) trafficDataView siteid:(int)siteid;
- (void) getYoukuTrafficData:(NSObject <TrafficDataDelegate>*) trafficDataView siteid:(int)siteid;
- (void) getDetailTrafficData:(NSObject <TrafficDataDelegate>*) trafficDetailDataView siteid:(int)siteid;

- (void) getYoukuTrafficDataFromCache:(NSObject<TrafficDataDelegate> *)trafficDataDelegate siteid:(int)flag;
- (void) getPcMobileTrafficDataFromCache:(NSObject <TrafficDataDelegate>*) trafficDataView siteid:(int)siteid;
- (void) getDetailTrafficDataFromCache:(NSObject <TrafficDataDelegate>*) trafficDetailDataView siteid:(int)siteid;

@end

@protocol TrafficDataDelegate

@optional
- (void) YoukuDataOK:(NSDictionary*)ret;
- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid;
- (void) TudouDataOK:(NSDictionary*)ret siteid:(int)siteid;

@end
