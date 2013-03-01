//
//  ChannelDataView.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-22.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableLabelView.h"
#import "ChannelDataViewCell.h"
#import "ChannelData.h"

@interface ChannelDataView : UIView<ChannelDataDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *datalist_youku;
    NSArray *datalist_tudou;
    UITableView *tableView_youku;
    UITableView *tableView_tudou;

}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UITableView *tableView_youku;
@property (nonatomic, retain) NSArray *datalist_youku;
@property (nonatomic, retain) UITableView *tableView_tudou;
@property (nonatomic, retain) NSArray *datalist_tudou;


@end
