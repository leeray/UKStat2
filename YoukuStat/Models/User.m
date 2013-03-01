//
//  User.m
//  stat
//
//  Created by 瑞 李 on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "JSONKit.h"

@implementation User
@synthesize username;
@synthesize userpassword;
@synthesize receivedData;


- (id) init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (void) startLogin:(LoginViewControl*) loginViewControl;
{
    _delegate = loginViewControl;
    NSMutableString *parm = [[NSMutableString alloc] init];
    NSLog(@"User.startLogin() deletgate:%@", _delegate);
    [parm appendString:@"http://stat.m.youku.com/client/userPamLogin?uname="];
    [parm appendString:username];
    [parm appendString:@"&pwd="];
    [parm appendString:userpassword];
    
    NSLog(@"request URL:%@", parm);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:parm]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    receivedData = [[NSMutableData alloc] init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [NSMutableData data];
        
    } else {
        NSLog(@"connection failed.");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse.");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData.");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [_delegate notok];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    NSLog(@"receivedData: %@", receivedData);
    NSString *receiveStr = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"-----str---%@", receiveStr);  
    //[receivedData se]
    
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSDictionary *ret = [jd objectWithData: receivedData];
    
    NSString *status = [ret objectForKey:@"status"];
    NSLog(@"status= %@", status);
    NSLog(@"User.connectionDidFinishLoading() deletgate:%@", _delegate);
    
    BOOL result = [status isEqualToString:@"success"];
    if (result){
        [_delegate ok];
    }else{
        [_delegate notok];
    }
}

- (void) loginOut
{

}

@end
