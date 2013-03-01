//
//  CachedDownloadManager.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-30.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "CachedDownloadManager.h"

@implementation CachedDownloadManager
@synthesize delegate;
@synthesize cacheDictionary;
@synthesize cacheDictionaryPath;

/* 公有方法：下载 */
- (BOOL) download:(NSString *)paramURLAsString urlMustExpireInSeconds:(NSTimeInterval)paramURLMustExpireInSeconds updateExpiryDateIfInCache:(BOOL)paramUpdateExpiryDateIfInCache{
    
    BOOL result = NO;
    
    if (self.cacheDictionary == nil || [paramURLAsString length] == 0){
        return result;
    }
    
    paramURLAsString = [paramURLAsString lowercaseString];
    
    //根据url，从字典中获取缓存项的相关数据
    NSMutableDictionary *itemDictionary = [self.cacheDictionary objectForKey:paramURLAsString];
    
    /* 使用下面这些变量帮助我们理解缓存逻辑 */
    //文件是否已经被缓存
    BOOL    fileHasBeenCached = NO;
    //缓存是否过期
    BOOL    cachedFileHasExpired = NO;
    //缓存文件是否存在
    BOOL    cachedFileExists = NO;
    //缓存文件能否被加载
    BOOL    cachedFileDataCanBeLoaded = NO;
    //缓存文件数据
    NSData  *cachedFileData = nil;
    //缓存文件是否完全下载
    BOOL    cachedFileIsFullyDownloaded = NO;
    //缓存文件是否已经下载
    BOOL    cachedFileIsBeingDownloaded = NO;
    //过期时间
    NSDate    *expiryDate = nil;
    //下载结束时间
    NSDate    *downloadEndDate = nil;
    //下载开始时间
    NSDate    *downloadStartDate = nil;
    //本地缓存路径
    NSString  *localURL = nil;
    //有效时间
    NSNumber  *expiresInSeconds = nil;
    NSDate    *now = [NSDate date];
    
    if (itemDictionary != nil){
        fileHasBeenCached = YES;
    }
    //如果文件已经被缓存，则从缓存项相关数据中获取相关的值
    if (fileHasBeenCached == YES){
        
        expiryDate = [itemDictionary objectForKey:@"CachedKeyExpiryDate"];
        
        downloadEndDate = [itemDictionary objectForKey:@"CachedKeyDownloadEndDate"];
        
        downloadStartDate = [itemDictionary objectForKey:@"CachedKeyDownloadStartDate"];
        
        localURL = [itemDictionary objectForKey:@"CachedKeyLocalURL"];  
        
        expiresInSeconds = [itemDictionary objectForKey:@"CachedKeyExpiresInSeconds"];
        
        //如果下载开始和结束时间不为空，表示文件全部被下载
        if (downloadEndDate != nil && downloadStartDate != nil){
            cachedFileIsFullyDownloaded = YES;
        }
        
        /* 如果expiresInSeconds不为空，downloadEndDate为空，表示文件已经正在下载 */
        if (expiresInSeconds != nil &&  downloadEndDate == nil){
            cachedFileIsBeingDownloaded = YES;
        }
        
        /* 判断缓存是否过期 */
        if (expiryDate != nil && [now timeIntervalSinceDate:expiryDate] > 0.0){
            cachedFileHasExpired = YES;
        }
        
        if (cachedFileHasExpired == NO){
            /* 如果缓存文件没有过期，加载缓存文件，并且更新过期时间 */
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            
            if ([fileManager fileExistsAtPath:localURL] == YES){
                cachedFileExists = YES;
                cachedFileData = [NSData dataWithContentsOfFile:localURL];
                if (cachedFileData != nil){
                    cachedFileDataCanBeLoaded = YES;
                }
            }
            
            /* 更新缓存时间 */
            if (paramUpdateExpiryDateIfInCache == YES){
                
                NSDate *newExpiryDate = [NSDate dateWithTimeIntervalSinceNow: paramURLMustExpireInSeconds];
                
                NSLog(@"Updating the expiry date from %@ to %@.", expiryDate, newExpiryDate);
                
                [itemDictionary setObject:newExpiryDate forKey:@"CachedKeyExpiryDate"];
                
                NSNumber *expires = [NSNumber numberWithFloat:paramURLMustExpireInSeconds];
                
                [itemDictionary setObject:expires forKey:@"CachedKeyExpiresInSeconds"];
            }
            
        }
        
    }
    
    if (cachedFileIsBeingDownloaded == YES){
        NSLog(@"这个文件已经正在下载...");
        return(YES);
    }
    
    if (fileHasBeenCached == YES){
        
        if (cachedFileHasExpired == NO && cachedFileExists == YES && cachedFileDataCanBeLoaded == YES && [cachedFileData length] > 0 && cachedFileIsFullyDownloaded == YES){
            
            /* 如果文件有缓存而且没有过期 */
            NSLog(@"文件有缓存而且没有过期.");
            
            [delegate cachedDownloadManagerSucceeded:self remoteURL:[NSURL URLWithString:paramURLAsString] localURL:[NSURL URLWithString:localURL] aboutToBeReleasedData:cachedFileData isCachedData:YES];
            
            return(YES);
            
        } else {
            /* 如果文件没有被缓存，获取缓存失败 */
            NSLog(@"文件没有缓存.");
            [self.cacheDictionary removeObjectForKey:paramURLAsString];
            [self saveCacheDictionary];
        }
        
    }
    
    return result;
}

//下载成功执行该方法
- (void) cacheItemDelegateSucceeded:(CacheItem *)paramSender withRemoteURL:(NSURL *)paramRemoteURL withAboutToBeReleasedData:(NSData *)paramAboutToBeReleasedData{
    
    //从缓存字典中获取该缓存项的相关数据
    NSMutableDictionary *dictionary = [self.cacheDictionary objectForKey:[paramRemoteURL absoluteString]];
    //取当前时间
    NSDate *now = [NSDate date];
    //获取有效时间
    NSNumber *expiresInSeconds = [dictionary objectForKey:@"CachedKeyExpiresInSeconds"];
    //转换成NSTimeInterval
    NSTimeInterval expirySeconds = [expiresInSeconds floatValue];
    //修改字典中缓存项的下载结束时间
    [dictionary setObject:[NSDate date] forKey:@"CachedKeyDownloadEndDate"];
    //修改字典中缓存项的缓存过期时间
    [dictionary setObject:[now dateByAddingTimeInterval:expirySeconds] forKey:@"CachedKeyExpiryDate"];
    //保存缓存字典
    [self saveCacheDictionary];
    
    NSString *localURL = [dictionary objectForKey:@"CachedKeyLocalURL"];
    
    /* 将下载的数据保持到磁盘 */
    if ([paramAboutToBeReleasedData writeToFile:localURL atomically:YES] == YES){
        NSLog(@"缓存文件到磁盘成功.");
    } else{
        NSLog(@"缓存文件到磁盘失败.");
    }
    //执行缓存管理的委托方法
    [delegate cachedDownloadManagerSucceeded:self remoteURL:paramRemoteURL localURL:[NSURL URLWithString:localURL] aboutToBeReleasedData:paramAboutToBeReleasedData isCachedData:NO];
    
    
}

//下载失败执行该方法
- (void) cacheItemDelegateFailed:(CacheItem *)paramSender remoteURL:(NSURL *)paramRemoteURL withError:(NSError *)paramError{
    
    /* 从缓存字典中移除缓存项，并发送一个委托 */
    
    if (delegate != nil){
        
        NSMutableDictionary *dictionary =
        [self.cacheDictionary objectForKey:[paramRemoteURL absoluteString]];
        
        NSString *localURL = [dictionary objectForKey:@"CachedKeyLocalURL"];
        
        [delegate cachedDownloadManagerFailed:self remoteURL:paramRemoteURL localURL:[NSURL URLWithString:localURL] withError:paramError];
    }
    
    [self.cacheDictionary removeObjectForKey:[paramRemoteURL absoluteString]];
    
}

- (BOOL) saveCacheDictionary{
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:YES];
    //生产缓存字典的路径
    cacheDictionaryPath = [documentsDirectory stringByAppendingString:@"CachedDownloads.dic"];
    //创建一个NSFileManager实例
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //判断是否存在缓存字典的数据
    if ([fileManager fileExistsAtPath:self.cacheDictionaryPath] == YES){
        NSLog(@"self.cacheDictionaryPath");
        //加载缓存字典中的数据
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.cacheDictionaryPath];
        
        cacheDictionary = [dictionary mutableCopy];
        
        //移除没有下载完成的缓存数据
        [self removeCorruptedCachedItems];
        
    } else {
        //创建一个新的缓存字典
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        cacheDictionary = [dictionary mutableCopy];
        
    }
    
    return YES;
}

- (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)a{
    return nil;
}

- (void) removeCorruptedCachedItems{
    
}

@end
