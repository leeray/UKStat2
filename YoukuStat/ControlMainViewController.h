//
//  ControlMainViewController.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-26.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentControl.h"
#import "HeadView.h"
#import "TrafficViewControl.h"
#import "ContentViewControl.h"
#import "FrominViewControl.h"
#import "OtherViewControl.h"
#import "HeadViewControl.h"

@interface ControlMainViewController : UIViewController <SegmentControlDelegate, TrafficViewControlDelegate, ContentViewControlDelegate, FrominViewControlDelegate, OtherViewControlDelegate, ScrollViewProtocol, HeadViewControlDelegate>{
    NSArray *modeArray;
    NSArray *tabnameArray;
    
    UISegmentedControl *titlesegmentedControl;
    SegmentControl *segmentControl;
    HeadView *headView;
    HeadViewControl *headViewControl;
    
    TrafficViewControl *trafficViewControl;
    ContentViewControl *contentViewControl;
    FrominViewControl *frominViewControl;
    OtherViewControl *otherinViewControl;
    
    float width;
    float height;
}

@end
