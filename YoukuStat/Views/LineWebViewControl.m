//
//  LineWebViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-19.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "LineWebViewControl.h"

@implementation LineWebViewControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    //self.view = contentView;
    
    //webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //webView.delegate = self;
    
    //[self.view addSubview:webView];
    
    //indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    
    //[indicatorView setCenter:self.center];
    
    //[indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    //[self addSubview:indicatorView];
    
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"report" ofType:@"html" inDirectory:@"ichart"]];
    NSURL *url = [NSURL fileURLWithPath:@"http://10.103.13.15:8888/static/test/report.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self loadRequest:request];

}


@end
