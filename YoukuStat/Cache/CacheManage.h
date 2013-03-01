//
//  CacheManage.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-30.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheManageDelegate;

@interface CacheManage : NSObject{

NSObject <CacheManageDelegate> *delegate;
NSMutableDictionary *cacheDictionary;
NSString *cacheDictionaryPath;
    
}

@property (nonatomic, retain) NSObject <CacheManageDelegate> *delegate;

-(void)getData:(NSObject <CacheManageDelegate> *)cacheManageDelegate cacheFile:(NSString *)fileName fromURL:(NSString *)paramURL;
-(void)setData:(NSObject <CacheManageDelegate> *)cacheManageDelegate cacheFile:(NSString *)fileName fromURL:(NSString *)paramURL receivedData:(NSData *)receivedData;

@end

@protocol CacheManageDelegate

-(void)cachedLoadSucceeded:(NSData *)cachedFileData paramURL:(NSString *)paramURLAsString;

-(void)cachedLoadFailed:(NSString *)paramURLAsString;

@end
