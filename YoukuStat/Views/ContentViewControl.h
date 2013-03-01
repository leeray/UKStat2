//
//  ContentViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentData.h"
#import "ScrollViewProtocol.h"
#import "TableLabelView.h"

@protocol ContentViewControlDelegate;

@interface ContentViewControl : UIView <ContentDataDelegate, UITableViewDataSource, UITableViewDelegate>{

    
    CGPoint startTouchPosition;
    NSString *dirString;
    
    NSObject <ScrollViewProtocol> *delegate;
    
    NSArray *datalist;
    NSArray *dudou_datalist;
    
    
    NSArray *datalist_item;
    NSArray *dudou_datalist_item;
    
    UITableView *tableView_video1;
    UITableView *tableView_item1;
    
    UITableView *tableView_video2;
    UITableView *tableView_item2;
    
    UIScrollView *view;
    
    UIView *loadingView;
    UIActivityIndicatorView *activityIndicator;
    
    TableLabelView *tableView_video1_label;
    TableLabelView *tableView_item1_label;
    TableLabelView *tableView_video2_label;
    TableLabelView *tableView_item2_label;
}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) NSArray *tudou_datalist;
@property (nonatomic, retain) NSArray *datalist_item;
@property (nonatomic, retain) NSArray *tudou_datalist_item;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIScrollView *view;


- (id)initContentViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)contentViewDelegate;

@end

@protocol ContentViewControlDelegate

-(void) moveRigth;
-(void) moveLeft;

@end
