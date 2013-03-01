//
//  TrafficTableViewCell.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-11.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrafficDataViewCellDelegate;

@interface TrafficDataViewCell : UIView<UITableViewDataSource, UITableViewDelegate>
{

    NSArray *datalist;
    UITableView *tableView;
    NSObject <TrafficDataViewCellDelegate> *_delegate;
}

@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSObject <TrafficDataViewCellDelegate> *_delegate;

@end

@protocol TrafficDataViewCellDelegate

- (void) trafficDataViewSelected:(int)selected selectTitle:(NSString*)title;

@end
