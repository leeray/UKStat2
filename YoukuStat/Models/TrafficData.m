//
//  NSObject+TrafficData.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TrafficData.h"
#import "JSONKit.h"
#import "SingletonYouku.h"
#import "CheckNetwork.h"

@implementation TrafficData

@synthesize receivedData;
@synthesize paramURl;

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) getYoukuTrafficData:(NSObject <TrafficDataDelegate> *) trafficDataDelegate siteid:(int)flag{
    siteid = flag;
    delegate = trafficDataDelegate;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/YoukuDataSumIPHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
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
        NSLog(@"TrafficData connection failed.");
    }
    
}

- (void) getYoukuTrafficDataFromCache:(NSObject<TrafficDataDelegate> *)trafficDataDelegate siteid:(int)flag{
    siteid = flag;
    delegate = trafficDataDelegate;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/YoukuDataSumIPHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", siteid]];
    
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Traffic" fromURL:parm];
    
}

- (void) getPcMobileTrafficData:(NSObject <TrafficDataDelegate> *) trafficDataView siteid:(int)flag{
    delegate = trafficDataView;
    siteid = flag;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/YoukuDataPageHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", flag]];
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:parm]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data] ;
        
    } else {
        NSLog(@"TrafficData connection failed.");
    }
    
}

- (void) getPcMobileTrafficDataFromCache:(NSObject <TrafficDataDelegate>*) trafficDataView siteid:(int)flag{
    delegate = trafficDataView;
    siteid = flag;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/YoukuDataPageHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", flag]];
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Traffic" fromURL:parm];
}

- (void) getDetailTrafficData:(NSObject <TrafficDataDelegate> *) trafficDetailDataView siteid:(int)flag{
    delegate = trafficDetailDataView;
    siteid = flag;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/contentLineHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", flag]];
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:parm]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data] ;
        
    } else {
        NSLog(@"TrafficData connection failed.");
    }
    
}

- (void) getDetailTrafficDataFromCache:(NSObject <TrafficDataDelegate>*) trafficDetailDataView siteid:(int)flag{
    delegate = trafficDetailDataView;
    siteid = flag;
    NSMutableString *parm = [[NSMutableString alloc] init];
    [parm appendString:[NSString stringWithFormat:@"%@" , dataurl]];
    [parm appendString:@"/client/contentLineHandler.json?site_id="];
    [parm appendString:[NSString stringWithFormat:@"%d", flag]];
    paramURl = [NSString stringWithString:parm];
    NSLog(@"TrafficData url:%@", paramURl);
    
    CacheManage *newManager = [[CacheManage alloc] init];
    cacheManage = newManager;
    [cacheManage getData:self cacheFile:@"Traffic" fromURL:parm];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"TrafficData.didReceiveResponse.");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"TrafficData.didReceiveData.");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"TrafficData Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"TrafficData Succeeded! Received %d bytes of data",[receivedData length]);
    NSLog(@"TrafficData receivedData: %@", receivedData);
    NSString *receiveStr = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"TrafficData -----str---%@", receiveStr);
    NSLog(@"TrafficData from URL: %@", paramURl);
    
    [cacheManage setData:self cacheFile:@"Traffic" fromURL:paramURl receivedData:receivedData];
    
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
