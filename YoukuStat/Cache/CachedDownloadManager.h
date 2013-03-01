//
//  CachedDownloadManager.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-30.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheItem.h"

@protocol CachedDownloadManagerDelegate;

@interface CachedDownloadManager : NSObject <CacheItemDelegate> {
    NSObject <CachedDownloadManagerDelegate>  *delegate;
    //记录缓存数据的字典
    NSMutableDictionary                *cacheDictionary;
    //缓存的路径
    NSString                           *cacheDictionaryPath;
}

@property (nonatomic, retain) NSObject <CachedDownloadManagerDelegate> *delegate;
@property (nonatomic, copy) NSMutableDictionary *cacheDictionary;
@property (nonatomic, retain) NSString *cacheDictionaryPath;


/* 保持缓存字典 */
- (BOOL) saveCacheDictionary;

/* 公有方法：下载 */
- (BOOL) download:(NSString *)paramURLAsString urlMustExpireInSeconds:(NSTimeInterval)paramURLMustExpireInSeconds updateExpiryDateIfInCache:(BOOL) paramUpdateExpiryDateIfInCache;

@end

@protocol CachedDownloadManagerDelegate
- (void)cachedDownloadManagerSucceeded:self remoteURL:(NSURL *)paramURLAsString localURL:(NSURL *)localURL aboutToBeReleasedData:(NSData *)cachedFileData isCachedData:(BOOL)iscacheddata;

- (void)cachedDownloadManagerFailed:self remoteURL:(NSURL *)paramRemoteURL localURL:(NSURL *)localURL withError:(NSError *)paramError;
@end

