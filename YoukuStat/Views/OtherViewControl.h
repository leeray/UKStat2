//
//  OtherViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelDataView.h"
#import "ChannelData.h"
#import "ScrollViewProtocol.h"

@protocol OtherViewControlDelegate;

@interface OtherViewControl : UIView <ChannelDataDelegate, UITableViewDataSource, UITableViewDelegate>{
//@interface OtherViewControl : UIView {

    NSObject <ScrollViewProtocol> *delegate;
    
    NSArray *datalist_youku;
    NSArray *datalist_tudou;
    UITableView *tableView_youku;
    UITableView *tableView_tudou;
    
    UIScrollView *view;
}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UITableView *tableView_youku;
@property (nonatomic, retain) NSArray *datalist_youku;
@property (nonatomic, retain) UITableView *tableView_tudou;
@property (nonatomic, retain) NSArray *datalist_tudou;
@property (nonatomic, retain) UIScrollView *view;

- (id)initChannelViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)channelViewDelegate;
@end

@protocol OtherViewControlDelegate

-(void) moveRigth;
-(void) moveLeft;

@end