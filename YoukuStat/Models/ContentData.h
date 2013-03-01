//
//  NSObject+ContentData.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManage.h"

@protocol ContentDataDelegate;

@interface ContentData : NSObject<CacheManageDelegate>{
    NSObject <ContentDataDelegate> *delegate;
    int siteid;
    CacheManage *cacheManage;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *paramURl;

- (void) getContentData:(NSObject <ContentDataDelegate>*) contentDataView siteid:(int)flag;

- (void) getContentDataFromCache:(NSObject <ContentDataDelegate>*) contentDataView siteid:(int)flag;

@end

@protocol ContentDataDelegate

@optional
- (void) YoukuDataOK:(NSDictionary*)ret;
- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid;
- (void) TudouDataOK:(NSDictionary*)ret siteid:(int)siteid;

@end
