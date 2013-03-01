//
//  TrafficDetailViewController.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-20.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TrafficDetailViewController.h"
#import "TrafficDetailDataView.h"
#import <QuartzCore/QuartzCore.h>
#import "SecondNavView.h"

@interface TrafficDetailViewController ()

@end

@implementation TrafficDetailViewController
@synthesize selected;
@synthesize flag;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    detailTable1 = [[TrafficDetailDataView alloc] initWithFrame:CGRectMake(0, 0 , width, height-40) delegate:self siteid:flag showType:type];
    detailTable1.userInteractionEnabled = YES;
    [self.view addSubview:detailTable1];

}

- (void) viewDidUnload{
    [super viewDidUnload];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) returnMain{
    NSLog(@"TrafficDetailViewController returnMain.");
    [self.navigationController popViewControllerAnimated:YES];
}


@end
