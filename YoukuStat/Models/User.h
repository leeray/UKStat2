//
//  User.h
//  stat
//
//  Created by 瑞 李 on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewControl.h"

@interface User : NSObject{
    LoginViewControl *_delegate;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userpassword;

@property (nonatomic, assign) NSMutableData *receivedData;

- (void) startLogin:(LoginViewControl*) loginViewControl;
- (void) loginOut;

@end
