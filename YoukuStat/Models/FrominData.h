//
//  NSObject+FrominData.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManage.h"

@protocol FrominDataDelegate;

@interface FrominData : NSObject <CacheManageDelegate>{
    NSObject <FrominDataDelegate> *delegate;
    int siteid;
    CacheManage *cacheManage;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *paramURl;

- (void) getFrominData:(NSObject <FrominDataDelegate>*) frominDataView siteid:(int)flag;

- (void) getFrominDataFromCache:(NSObject<FrominDataDelegate> *)trafficDataDelegate siteid:(int)flag;

@end

@protocol FrominDataDelegate

@optional
- (void) YoukuDataOK:(NSDictionary*)ret;
- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid;
- (void) TudouDataOK:(NSDictionary*)ret siteid:(int)siteid;

@end
