//
//  LineViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-7.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"

@interface LineViewControl : UIView{
    NSArray *datalist;
    PCLineChartView *lineChartView;
}

@property (nonatomic, retain) NSArray *datalist;
@property (nonatomic, retain) NSString *showType;

@end
