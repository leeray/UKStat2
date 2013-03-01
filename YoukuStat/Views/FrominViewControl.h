//
//  FrominViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrominData.h"
#import "ScrollViewProtocol.h"

@protocol FrominViewControlDelegate;

@interface FrominViewControl : UIView <FrominDataDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    CGPoint startTouchPosition;
    NSString *dirString;
    
    NSObject <ScrollViewProtocol> *delegate;
    
    NSArray *datalist_tudou_zhannei;
    NSArray *datalist_tudou_zhanwai;
    NSArray *datalist_youku_zhannei;
    NSArray *datalist_youku_zhanwai;
    
    UITableView *tableView_tudou_zhannei;
    UITableView *tableView_youku_zhannei;
    UITableView *tableView_tudou_zhanwai;
    UITableView *tableView_youku_zhanwai;
    
    UIScrollView *view;
}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSArray *datalist_tudou_zhannei;
@property (nonatomic, retain) NSArray *datalist_youku_zhannei;
@property (nonatomic, retain) UITableView *tableView_tudou_zhannei;
@property (nonatomic, retain) UITableView *tableView_youku_zhannei;
@property (nonatomic, retain) NSArray *datalist_tudou_zhanwai;
@property (nonatomic, retain) NSArray *datalist_youku_zhanwai;
@property (nonatomic, retain) UITableView *tableView_tudou_zhanwai;
@property (nonatomic, retain) UITableView *tableView_youku_zhanwai;
@property (nonatomic, retain) UIScrollView *view;

- (id)initFrominViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)frominViewDelegate;

@end

@protocol FrominViewControlDelegate

-(void) moveRigth;
-(void) moveLeft;

@end
