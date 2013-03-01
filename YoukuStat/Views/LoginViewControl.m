//
//  LoginViewControl.m
//  SlidingTabs
//
//  Created by 李 瑞 on 13-1-5.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "LoginViewControl.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewControl

@synthesize loadingView1;
@synthesize loadingView2;
@synthesize loadingLabel;
@synthesize activityIndicator;
@synthesize width;
@synthesize height;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (id) initWithdelegate:(NSObject <LoginViewControlDelegate>*) loginViewControlDelegate{
    _delegate = loginViewControlDelegate;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    
    width = CGRectGetWidth(rect);
    height = CGRectGetHeight(rect);
    
    
    touchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [touchView setAlpha:1.0];
    
    logoImage = [[UILabel alloc]initWithFrame:CGRectMake((width-62)/3, height/3 - 80, 125, 43)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stat_logo.png"]];
    [logoImage setBackgroundColor:color];
    
    usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake((width-200)/2, height/3+10.0, 50, 30)];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.text = @"用户名";
    usernameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    usernameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:35];
    usernameLabel.shadowOffset = CGSizeMake(0, -1.0);
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = UITextAlignmentRight;
    
    
    userpassLabel = [[UILabel alloc]initWithFrame:CGRectMake((width-200)/2, height/3+50.0, 50, 30)];
    userpassLabel.backgroundColor = [UIColor clearColor];
    userpassLabel.text = @"密码";
    userpassLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    userpassLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:35];
    userpassLabel.shadowOffset = CGSizeMake(0, -1.0);
    userpassLabel.textColor = [UIColor whiteColor];
    userpassLabel.textAlignment = UITextAlignmentRight;
    
    
    usernameText = [[UITextField alloc]initWithFrame:CGRectMake((width-200)/2+55, height/3+10.0, 150, 30)];
    usernameText.backgroundColor = [UIColor whiteColor];
    usernameText.borderStyle = UITextBorderStyleRoundedRect;
    usernameText.textColor = [UIColor darkGrayColor];
    usernameText.textAlignment = UITextAlignmentLeft;
    usernameText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    usernameText.autocapitalizationType = NO;
    usernameText.keyboardType = UIReturnKeySend;


    userpassText = [[UITextField alloc]initWithFrame:CGRectMake((width-200)/2+55, height/3+50.0, 150, 30)];
    userpassText.backgroundColor = [UIColor whiteColor];
    userpassText.borderStyle = UITextBorderStyleRoundedRect;
    userpassText.textColor = [UIColor darkGrayColor];
    userpassText.secureTextEntry = YES;
    userpassText.clearsOnBeginEditing = YES;
    userpassText.textAlignment = UITextAlignmentLeft;
    userpassText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    //userpassText.keyboardType = UIReturnKeyYahoo;
    //userpassText.keyboardType = UIReturnKeyNext;
    //userpassText.enablesReturnKeyAutomatically = YES;
    [touchView addSubview:logoImage];
    
    
    [self addSubview:touchView];
    [touchView addSubview:logoImage];
    
    [touchView addSubview:usernameLabel];
    [touchView addSubview:userpassLabel];
    
    [touchView addSubview:usernameText];
    [touchView addSubview:userpassText];
    
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake((width-200)/2, height/3*2 + 20, 200, 40)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [touchView addSubview:loginButton];
    
}

-(void) loginButtonClicked {
    NSLog(@"loginButtonClicked");
    
    [self loadDataView];
    
    NSString *username = usernameText.text;
    NSString *userpass = userpassText.text;
    
    if(!username || !userpass){
        username = @"xxx";
        userpass = @"yyy";
    }
    NSLog(@"username:%@   userpassword:%@", username, userpass);
    
    User *user = [[User alloc]init];
    user.username = username;
    user.userpassword = userpass;
    [user startLogin:self];
    
}

- (void) loadDataView{
    [self setAlpha:0.8];
    loadingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    loadingView1.backgroundColor = [ [ UIColor alloc ] initWithRed:28/255 green:28/255 blue:28/255 alpha: 0.8];
    [loadingView1 setAlpha:0.8];
    loadingView1.layer.cornerRadius = 10;
    loadingView1.layer.masksToBounds = YES;
    [loadingView1 setCenter:self.center];
    [self addSubview:loadingView1];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [indicator startAnimating];
    [indicator setCenter:self.center];
    
    [self addSubview:indicator];
}

- (UIActivityIndicatorView *)makeActivityIndicator;
{
    //UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(16, 0, 30, 30)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [indicator startAnimating];
    
    return indicator;
}

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    
    label.font = [UIFont systemFontOfSize:10.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = labelText;
    
    return label;
}

- (UIView *)makeBorderView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 60) ];
    [view setAlpha:0.0];
    view.backgroundColor = [UIColor whiteColor];
    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    return view;
}

- (void)setupBackground;
{
    [touchView setAlpha:0.8];
    touchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [usernameText resignFirstResponder];
    [userpassText resignFirstResponder];
}

-(void) ok{
    NSLog(@"okokok!!!");
    [touchView setAlpha:1.0];
    [loadingView1 removeFromSuperview ];
    [_delegate loginSuccess:self];
}

-(void)notok{
    NSLog(@"notok!!!");
    [touchView setAlpha:1.0];
    [loadingView1 removeFromSuperview ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    [_delegate loginSuccess:self];
}

@end
