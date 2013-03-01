//
//  NSObject+ChannelData.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-22.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "ChannelData.h"
#import "SingletonYouku.h"
#import "JSONKit.h"

@implementation ChannelData
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


- (void) getChannelData:(NSObject <ChannelDataDelegate>*) channelDataView siteid:(int)flag;
{
    siteid = flag;
    delegate = channelDataView;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/channelViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"ChannelData url:%@", paramURl);
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
        NSLog(@"ChannelData connection failed.");
    }
}

- (void) getChannelDataFromCache:(NSObject <ChannelDataDelegate>*) channelDataView siteid:(int)flag{
    siteid = flag;
    delegate = channelDataView;
    
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/channelViewHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    NSLog(@"ChannelData request URL:%@", parm);
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"FrominData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Channel" fromURL:parm];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"ChannelData didReceiveResponse.");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"ChannelData didReceiveData.");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  
    // inform the user
    NSLog(@"ChannelData Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    //[_delegate notok];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"ChannelData Succeeded! Received %d bytes of data",[receivedData length]);
    NSLog(@"ChannelData receivedData: %@", receivedData);
    NSString *receiveStr = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"ChannelData -----str---%@", receiveStr);
    
    [cacheManage setData:self cacheFile:@"Channel" fromURL:paramURl receivedData:receivedData];
    
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
