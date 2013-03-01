//
//  CacheItem.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-30.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheItemDelegate;

@interface CacheItem : NSObject{

NSObject <CacheItemDelegate> *delegate;

//web地址
NSString *remoteURL;

//是否正在下载
BOOL                  isDownloading;

//NSMutableData对象
NSMutableData         *connectionData;

//NSURLConnection对象
NSURLConnection       *connection;

}

@property (nonatomic, retain) NSObject<CacheItemDelegate> *delegate;
@property (nonatomic, retain) NSString  *remoteURL;
@property (nonatomic, assign) BOOL      isDownloading;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, retain) NSURLConnection *connection;


- (BOOL) startDownloadingURL:(NSString *)paramRemoteURL;

- (NSData *) getData:(NSString *)paramURL;

@end

@protocol CacheItemDelegate
//下载成功执行该方法
- (void) cacheItemDelegateSucceeded:(CacheItem *)paramSender withRemoteURL:(NSURL *)paramRemoteURL
withAboutToBeReleasedData:(NSData *)paramAboutToBeReleasedData;

//下载失败执行该方法
- (void) cacheItemDelegateFailed:(CacheItem *)paramSender remoteURL:(NSURL *)paramRemoteURL withError:(NSError *)paramError;
@end
