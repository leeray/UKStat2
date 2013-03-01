//
//  NSObject+ContentData.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "ContentData.h"
#import "SingletonYouku.h"
#import "JSONKit.h"

@implementation ContentData
@synthesize paramURl;
@synthesize receivedData;

- (id) init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (void) getContentData:(NSObject <ContentDataDelegate>*) contentDataControl siteid:(int)flag;
{
    siteid = flag;
    delegate = contentDataControl;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/contentViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"ContentData url:%@", paramURl);
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:parm]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data] ;
        
    } else {
        NSLog(@"ContentData connection failed.");
    }
}

- (void) getContentDataFromCache:(NSObject <ContentDataDelegate>*) contentDataView siteid:(int)flag{
    siteid = flag;
    delegate = contentDataView;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/contentViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    NSLog(@"ContentData request URL:%@", parm);
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"FrominData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Content" fromURL:parm];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"ContentData didReceiveResponse.");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"ContentData didReceiveData.");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    // inform the user
    NSLog(@"ContentData Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    //[_delegate notok];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"ContentData Succeeded! Received %d bytes of data",[receivedData length]);
    NSLog(@"ContentData receivedData: %@", receivedData);
    NSString *receiveStr = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"ContentData -----str---%@", receiveStr);
    
    [cacheManage setData:self cacheFile:@"Content" fromURL:paramURl receivedData:receivedData];

    
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSDictionary *ret = [jd objectWithData: receivedData];
    
    [delegate YoukuDataOK:ret siteid:siteid];
}

- (void) cachedLoadFailed:(NSString *)paramURLAsString{
    NSLog(@"cachedLoadFailed");
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:paramURLAsString]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data];
    }
}

- (void) cachedLoadSucceeded:(NSData *)cachedFileData paramURL:(NSString *)paramURLAsString{
    NSLog(@"cachedLoadSucceeded");
    receivedData = [[NSMutableData alloc]initWithData:cachedFileData];
    
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSDictionary *ret = [jd objectWithData: receivedData];
    [delegate YoukuDataOK:ret siteid:siteid];
}

@end
