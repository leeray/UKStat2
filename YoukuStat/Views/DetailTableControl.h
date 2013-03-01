//
//  DetailDataControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableControl : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSArray *datalist;
    UITableView *tableView;
    UITableView *mobileTableView;
    NSString *datatime1;
}

@property (nonatomic, retain) NSString *datatime1;
@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *mobileTableView;
@property (nonatomic, retain) NSString *showType;

@end
