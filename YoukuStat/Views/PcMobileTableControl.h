//
//  PcMobileTableControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PcMobileTableControlDelegate;

@interface PcMobileTableControl : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSArray *datalist;
    UITableView *tableView;
    
    NSArray *pcdatalist;
    UITableView *pctableView;
    
    NSObject <PcMobileTableControlDelegate> *_delegate;
    
    NSString *datatime;
    NSString *pcdatatime;
}

@property (nonatomic, retain) NSString *datatime;
@property (nonatomic, retain) NSString *pcdatatime;
@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *pcdatalist;
@property (nonatomic, retain) UITableView *pctableView;

@property (nonatomic, retain) NSObject <PcMobileTableControlDelegate> *_delegate;

@end

@protocol PcMobileTableControlDelegate

- (void) pcMobileTableSelected:(int)selected selectTitle:(NSString*)title;

@end
