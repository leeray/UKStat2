//
//  NSObject+FrominData.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "FrominData.h"
#import "JSONKit.h"
#import "SingletonYouku.h"
#import "CheckNetwork.h"

@implementation FrominData
@synthesize receivedData;
@synthesize paramURl;

- (id) init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (void) getFrominData:(NSObject <FrominDataDelegate>*) frominDataView siteid:(int)flag;
{
    delegate = frominDataView;
    siteid = flag;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/sourceViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    NSLog(@"FrominData request URL:%@", parm);
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"FrominData url:%@", paramURl);
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:parm]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data];
        
    } else {
        NSLog(@"FrominData connection failed.");
    }
}

- (void) getFrominDataFromCache:(NSObject<FrominDataDelegate> *)frominDataView siteid:(int)flag{
    delegate = frominDataView;
    siteid = flag;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/sourceViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    NSLog(@"FrominData request URL:%@", parm);
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"FrominData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Fromin" fromURL:parm];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"FrominData didReceiveResponse.");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"FrominData didReceiveData.");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    // inform the user
    NSLog(@"FrominData Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    //[_delegate notok];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"FrominData Succeeded! Received %d bytes of data",[receivedData length]);
    NSLog(@"FrominData receivedData: %@", receivedData);
    NSString *receiveStr = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"FrominData -----str---%@", receiveStr);
    
    [cacheManage setData:self cacheFile:@"Fromin" fromURL:paramURl receivedData:receivedData];
    
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
