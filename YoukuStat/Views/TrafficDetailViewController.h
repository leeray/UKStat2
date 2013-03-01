//
//  TrafficDetailViewController.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-20.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficDetailDataView.h"

@interface TrafficDetailViewController : UIViewController <TrafficDetailDataViewDelegate>{
    TrafficDetailDataView *detailTable1;
}

@property (nonatomic, assign) int flag; //youku:1  tudou:2
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *type;
@end
