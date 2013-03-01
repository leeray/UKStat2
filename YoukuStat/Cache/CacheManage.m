//
//  CacheManage.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-30.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "CacheManage.h"
#import "JSONKit.h"

@implementation CacheManage
@synthesize delegate;

-(void)getData:(NSObject <CacheManageDelegate> *)cacheManageDelegate cacheFile:(NSString *)cachefileName fromURL:(NSString *)paramURL{
    delegate = cacheManageDelegate;
    
    //缓存文件能否被加载
    BOOL    cachedFileDataCanBeLoaded = NO;
    //缓存文件数据
    NSDictionary  *cachedFileData = nil;
    //过期时间
    NSDate    *expiryDate = nil;
    //缓存时间
    NSDate    *downloadDate = nil;
    //url缓存的数据
    NSData    *receivedData = nil;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:now];
    NSString *filename = [NSString stringWithFormat:@"%@%@", cachefileName, locationString];
   
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *documentsDirectory =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString* path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,filename];
    NSLog(@"从缓存文件装载数据. %@", path);
    if ([fileManager fileExistsAtPath:path] == YES){
        cachedFileData = [NSDictionary dictionaryWithContentsOfFile:path];
        if (cachedFileData != nil){
            cachedFileDataCanBeLoaded = YES;
            NSLog(@"get cache %@", cachedFileData);
        }
    }
    
    if (cachedFileDataCanBeLoaded == YES) {
        //JSONDecoder *jd=[[JSONDecoder alloc] init];
        //NSDictionary *ret = [jd objectWithData: cachedFileData];
        
        NSDictionary *urlData = [cachedFileData objectForKey:paramURL];
        
//        downloadDate = [urlData objectForKey:@"DownloadDate"];
//        expiryDate = [urlData objectForKey:@"expiryDate"];
        receivedData = [urlData objectForKey:@"receivedData"];
        
        [delegate cachedLoadSucceeded:receivedData paramURL:paramURL];
        
    }else{
        [delegate cachedLoadFailed:paramURL];
    }
}

-(void)setData:(NSObject <CacheManageDelegate> *)cacheManageDelegate cacheFile:(NSString *)cachefileName fromURL:(NSString *)paramURL receivedData:(NSData *)receivedData{
    delegate = cacheManageDelegate;
    
    NSMutableDictionary *cachedFileData_old = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *cachedFileData = [[NSMutableDictionary alloc] init];
    
    
    BOOL    cachedFileDataCanBeLoaded = NO;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:now];
    NSString *filename = [NSString stringWithFormat:@"%@%@", cachefileName, locationString];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *documentsDirectory =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString* path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,filename];
    if ([fileManager fileExistsAtPath:path] == YES){
        cachedFileData_old = [NSDictionary dictionaryWithContentsOfFile:path];
        if (cachedFileData_old != nil){
            cachedFileDataCanBeLoaded = YES;
        }
    }
    
    if (cachedFileDataCanBeLoaded == YES) {
        //cachedFileData = [cachedFileData_old copy];
        cachedFileData = [[NSMutableDictionary alloc]initWithDictionary:cachedFileData_old];
    }
    
    NSLog(@"URL:%@    cachedFileData:%@", paramURL, cachedFileData);
    
    NSMutableDictionary *urlData = [[NSMutableDictionary alloc] init];
//    [urlData setObject:@"" forKey:@"DownloadDate"];
//    [urlData setObject:@"" forKey:@"expiryDate"];
    [urlData setObject:receivedData forKey:@"receivedData"];
    [cachedFileData setObject:urlData forKey:paramURL];
    
    if ([cachedFileData writeToFile:path atomically:YES] == YES){
        NSLog(@"缓存文件到磁盘成功. %@", path);
        NSLog(@"set cache %@", cachedFileData);
    } else{
        NSLog(@"缓存文件到磁盘失败. %@", path);
    }
}


//删除历史文件
-(void) removeOldCachefile:(NSString *)cachefileName days:(int)days{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *documentsDirectory =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString *path = [[NSString alloc]init];
    //NSString *filename = [[NSString alloc]init];
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval =24*60*60*1; //1:天数
    NSDate *date1 = [now initWithTimeIntervalSinceNow:+interval];
    //[dateFormattersetDateFormat:@"yyyy-MM-dd"];
    //pLabDate.text  = [NSStringstringWithFormat:@"%@",[dateFormatter stringFromDate:date1]];
    
    for (int i=1; i<=days; i++){
        interval =24*60*60*i;
        date1 = [now initWithTimeIntervalSinceNow:+interval];
        cachefileName = [NSString stringWithFormat:@"%@%@", cachefileName, date1];
        path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,cachefileName];
        
        if ([fileManager fileExistsAtPath:path] == YES) {
            NSError *theError = nil;
            [fileManager removeItemAtPath:path error:&theError];
        }
    }
}

@end
