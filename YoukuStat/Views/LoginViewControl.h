//
//  LoginViewControl.h
//  SlidingTabs
//
//  Created by 李 瑞 on 13-1-5.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControlDelegate;

@interface LoginViewControl : UIView{
    UILabel *logoImage;
    
    UILabel *usernameLabel;
    UILabel *userpassLabel;
    
    UITextField *usernameText;
    UITextField *userpassText;
    
    UIButton *loginButton;
    
    UIView *touchView;
    UIView *loadingView;
    
    NSObject <LoginViewControlDelegate> *_delegate;
    
    

}

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, retain) UIView *loadingView1;
@property (nonatomic, retain) UIView *loadingView2;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


- (id) initWithdelegate:(NSObject <LoginViewControlDelegate>*) loginViewControlDelegate;

-(void) ok;
-(void) notok;

@end

@protocol LoginViewControlDelegate

@optional
- (void) loginSuccess:(LoginViewControl*)loginViewControl ;

@end
