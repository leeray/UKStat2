//
//  NSObject+ChannelData.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-22.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManage.h"

@protocol ChannelDataDelegate;

@interface  ChannelData : NSObject<CacheManageDelegate>{
    NSObject <ChannelDataDelegate> *delegate;
    int siteid;
    CacheManage *cacheManage;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *paramURl;

- (void) getChannelData:(NSObject <ChannelDataDelegate>*) channelDataView siteid:(int)flag;

- (void) getChannelDataFromCache:(NSObject <ChannelDataDelegate>*) channelDataView siteid:(int)flag;

@end

@protocol ChannelDataDelegate

@optional
- (void) YoukuDataOK:(NSDictionary*)ret;
- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid;
- (void) TudouDataOK:(NSDictionary*)ret siteid:(int)siteid;

@end
