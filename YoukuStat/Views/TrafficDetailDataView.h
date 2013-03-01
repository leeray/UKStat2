//
//  TestViewController.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-7.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficData.h"
#import "LineViewControl.h"
#import "DetailTableControl.h"
#import "LineWebViewControl.h"

@protocol TrafficDetailDataViewDelegate;

@interface TrafficDetailDataView : UIView <TrafficDataDelegate, UITableViewDelegate,UITableViewDataSource>{
    LineViewControl *lineView;
    DetailTableControl *detailtableView;
    LineWebViewControl *lineWebview;
    
    NSObject <TrafficDetailDataViewDelegate> *delegate;
    
    NSArray *datalist;
    UITableView *tableView;
    UITableView *mobileTableView;
    NSString *datatime1;
    
    UIView *view;

}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *showType;

@property (nonatomic, retain) NSString *datatime1;
@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *mobileTableView;

@property (nonatomic, retain) UIView *view;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <TrafficDetailDataViewDelegate> *)detailDataviewDelegate siteid:(int)siteflag showType:(NSString*)type;

@end

@protocol TrafficDetailDataViewDelegate

-(void) returnMain;

@end
