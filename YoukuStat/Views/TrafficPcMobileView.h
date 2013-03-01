//
//  TrafficPcMobileView.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficData.h"

@protocol TrafficPcMobileViewDelegate;

@interface TrafficPcMobileView : UIView <UITableViewDataSource, UITableViewDelegate, TrafficDataDelegate> {
    //PcMobileTableControl *pcmobileTableControl;
    NSObject <TrafficPcMobileViewDelegate> *delegate;
    
    NSArray *datalist;
    UITableView *tableView;
    
    NSArray *pcdatalist;
    UITableView *pctableView;
    
    UIView *view;
    
    NSString *dateStr;
    
    UILabel *datestrLabel;
}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *pcdatalist;
@property (nonatomic, retain) UITableView *pctableView;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <TrafficPcMobileViewDelegate> *)pcmobileViewDelegate siteid:(int)siteflag;

@end

@protocol TrafficPcMobileViewDelegate

-(void) returnMain;
-(void) getDetailPage:(NSString*)type;

@end
