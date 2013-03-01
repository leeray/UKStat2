//
//  PcMobileTableCell.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PcMobileTableCell : UITableViewCell
@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dec;
@property (copy, nonatomic) NSString *loc;

@property (retain, nonatomic) UILabel *label1;
@property (retain, nonatomic) UILabel *label2;
@property (retain, nonatomic) UILabel *label3;
@property (retain, nonatomic) UILabel *label4;

@end
