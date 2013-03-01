//
//  ControlMainViewController.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-26.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "ControlMainViewController.h"
#import "TrafficPcMobileViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControlMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"shade.png"];
    self.view.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    modeArray = [@"流量 来源 内容 其他" componentsSeparatedByString:@" "];
    tabnameArray = [[NSArray alloc]init];
    tabnameArray = @[@"Youku", @"Tudou"];
    
    headViewControl = [[HeadViewControl alloc]initWithFrame:CGRectMake(0, 0, 200, 40) withHeaderArray:tabnameArray delegate:self];
    self.navigationItem.titleView = headViewControl;
    

    //UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"asdfsadf" image:[UIImage imageNamed:@"WWAN5.png"] tag:1];
    //self.navigationItem.leftBarButtonItem = [self editButtonItem];
    
//    titlesegmentedControl = [[UISegmentedControl alloc]initWithItems:tabnameArray];
//    titlesegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    titlesegmentedControl.momentary = NO;
//    //self.navigationItem.titleView = titlesegmentedControl;
//    titlesegmentedControl.selectedSegmentIndex = 0;
//    [titlesegmentedControl addTarget:self action:@selector(_segmentTabNameChanged:) forControlEvents:UIControlEventValueChanged];

    
    width = [[UIScreen mainScreen] bounds].size.width;
    float height1 = self.view.frame.size.height;
    height = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"width:%2f  height:%2f bounds.heigth:%2f", width, height, height1);
    
    //生成模块分割 流量 来源 内容 其他
    segmentControl = [[SegmentControl alloc]initWithFrame:CGRectMake(0, height-40-20-40, width, 40) tabName:modeArray delegate:self];
    [self.view addSubview:segmentControl];
    
   
    trafficViewControl = [[TrafficViewControl alloc]initTrafficViewWithFrame:CGRectMake(0, 0, width, height-40-20-40) delegate:self];
    [self.view addSubview:trafficViewControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) segmentValueChange:(NSUInteger)tabIndex{
    
    for (UIView* temp in [self.view subviews]) {
        if ([temp isKindOfClass:[TrafficViewControl class]]) {
            [temp removeFromSuperview];
        }
        if ([temp isKindOfClass:[FrominViewControl class]]){
            [temp removeFromSuperview];
        }
        if ([temp isKindOfClass:[ContentViewControl class]]){
            [temp removeFromSuperview];
        }
        if ([temp isKindOfClass:[OtherViewControl class]]){
            [temp removeFromSuperview];
        }
    }
    titlesegmentedControl.selectedSegmentIndex = 0;
    if (tabIndex == 0) {
        trafficViewControl = [[TrafficViewControl alloc]initTrafficViewWithFrame:CGRectMake(0, 0, width, height-40-20-40) delegate:self];
        [self.view addSubview:trafficViewControl];
    }
    if (tabIndex == 1) {
        frominViewControl = [[FrominViewControl alloc]initFrominViewWithFrame:CGRectMake(0, 0, width, height-40-20-40) delegate:self];
        [self.view addSubview:frominViewControl];
    }
    if (tabIndex == 2) {
        contentViewControl = [[ContentViewControl alloc] initContentViewWithFrame:CGRectMake(0, 0, width, height-40-20-40) delegate:self];
        [self.view addSubview:contentViewControl];
    }
    if (tabIndex ==3) {
        otherinViewControl = [[OtherViewControl alloc]initChannelViewWithFrame:CGRectMake(0, 0, width, height-40-20-40) delegate:self];
        [self.view addSubview:otherinViewControl];
    }
}

- (void) _segmentTabNameChanged:(id)segmentChanged{
    UISegmentedControl *control = (UISegmentedControl *) segmentChanged;
    NSLog(@"ControlMainViewController _segmentTabNameChanged:%d", control.selectedSegmentIndex);
    
    for (UIView* temp in [self.view subviews]) {
        CGPoint position = CGPointMake(320*control.selectedSegmentIndex, 0);
        if ([temp isKindOfClass:[TrafficViewControl class]]) {
            [trafficViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[FrominViewControl class]]){
            [frominViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[ContentViewControl class]]){
            [contentViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[OtherViewControl class]]){
            [otherinViewControl.view setContentOffset:position animated:YES];
        }
    }
}

- (void)getDetailInfo:(int)whichType selectTitle:(NSString *)title{
    
}

- (void)getPcMobileInfo:(int)whichType selectTitle:(NSString *)title{
    TrafficPcMobileViewController *trafficPcMobileController = [[TrafficPcMobileViewController alloc]init];
    trafficPcMobileController.flag = whichType;
    trafficPcMobileController.title = [tabnameArray objectAtIndex:whichType-1];
    [self.navigationController pushViewController:trafficPcMobileController animated:YES];
}

-(void) getTrafficDetail:(int) whichType  selectTitle:(NSString*)title{
    
}

-(void) getTrafficPcMobile:(int)whichType selectTitle:(NSString*)title{
    
}

-(void) moveRigth{
    
}

-(void) moveLeft{
    
}

-(void) scrollViewChange:(int)index{
    titlesegmentedControl.selectedSegmentIndex = index;
    [headViewControl ScrollViewChanage:index];
}

- (void) HeadTitleChange:(int)index{
    for (UIView* temp in [self.view subviews]) {
        CGPoint position = CGPointMake(320*index, 0);
        if ([temp isKindOfClass:[TrafficViewControl class]]) {
            [trafficViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[FrominViewControl class]]){
            [frominViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[ContentViewControl class]]){
            [contentViewControl.view setContentOffset:position animated:YES];
        }
        if ([temp isKindOfClass:[OtherViewControl class]]){
            [otherinViewControl.view setContentOffset:position animated:YES];
        }
    }
}

@end
