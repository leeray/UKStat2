//
//  FrominDataViewCell.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrominDataViewCell : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSArray *datalist;
    UITableView *tableView;
}

@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) UITableView *tableView;

@end
