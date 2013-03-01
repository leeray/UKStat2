//
//  TrafficPcMobileViewController.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TrafficPcMobileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TrafficDetailViewController.h"


@implementation TrafficPcMobileViewController

@synthesize selected;
@synthesize flag;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"shade.png"];
    self.view.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    
    trafficPcMobileview = [[TrafficPcMobileView alloc] initWithFrame:CGRectMake(0, 0, width, height-40) delegate:self siteid:flag];
    [self.view addSubview:trafficPcMobileview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) returnMain{
    NSLog(@"TrafficPcMobileViewController returnMain.");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getDetailPage:(NSString*)type1{
    NSLog(@"TrafficPcMobileViewController getDetailPage");
    TrafficDetailViewController *trafficDetailController = [[TrafficDetailViewController alloc]init];
    trafficDetailController.selected = selected;
    trafficDetailController.flag = flag;
    trafficDetailController.type = type1;
    
    [self.navigationController pushViewController:trafficDetailController animated:YES];
}



@end
