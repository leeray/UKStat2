//
//  TrafficDataViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-11.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficData.h"
#import "TrafficDetailDataView.h"
#import "LineViewControl.h"
#import "ScrollViewProtocol.h"

@protocol TrafficViewControlDelegate;

@interface TrafficViewControl : UIView <TrafficDataDelegate, UITableViewDataSource, UITableViewDelegate>{
    
//    TrafficDataView *trafficDataView1;
//    TrafficDataView *trafficDataView2;
    
    TrafficDetailDataView *detailTable1;
    TrafficDetailDataView *detailTable2;
    
    UIView *leftView;
    UIView *rightView;
    
    UIView *tmpleftView;
    UIView *tmprightView;
    
    UIView *detailleftView;
    UIView *detailrightView;
    
    CGPoint startTouchPosition;
    NSString *dirString;
    
    NSObject <ScrollViewProtocol> *delegate;
    
    NSArray *datalist;
    NSArray *dudou_datalist;
    
    UITableView *tableView1;
    
    UITableView *tableView2;
    
    UIScrollView *view;
    
    NSString *dateStr;

}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) NSArray *tudou_datalist;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIScrollView *view;


- (id)initTrafficViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)trafficViewDelegate;

@end

@protocol TrafficViewControlDelegate

-(void) getTrafficDetail:(int) whichType  selectTitle:(NSString*)title;
-(void) getTrafficPcMobile:(int)whichType selectTitle:(NSString*)title;

-(void) moveRigth;
-(void) moveLeft;

@end
