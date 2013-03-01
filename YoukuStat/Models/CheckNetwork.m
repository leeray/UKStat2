//
//  CheckNetwork.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-31.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"10.103.13.15"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
//	if (!isExistenceNetwork) {
//		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
//		[myalert show];
//	}
	return isExistenceNetwork;
}
@end
