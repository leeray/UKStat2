//
//  TrafficTableViewCell2.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-15.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficTableViewCell2 : UITableViewCell

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dig;
@property (copy, nonatomic) NSString *perweek;

@property (retain, nonatomic) UILabel *name_label;
@property (retain, nonatomic) UILabel *dig_label;
@property (retain, nonatomic) UILabel *perweek_label;
@property (retain, nonatomic) UILabel *label4;

@end
