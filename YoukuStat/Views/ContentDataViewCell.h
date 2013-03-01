//
//  ContentDataViewCell.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentDataViewCell : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSArray *datalist;
    UITableView *tableView;
    
    NSString *headerName;
}

@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *headerName;

@end
