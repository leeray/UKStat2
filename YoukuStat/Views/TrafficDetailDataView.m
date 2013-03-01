//
//  TrafficDetailDataView.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-15.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TrafficDetailDataView.h"
#import "DetailTableControl.h"
#import "TrafficData.h"
#import "NSObject_VvDatas.h"
#import "DetailTableViewCell.h"
#import "CheckNetwork.h"

@implementation TrafficDetailDataView
@synthesize flag;
@synthesize loadingView;
@synthesize activityIndicator;
@synthesize showType;
@synthesize view;
@synthesize datalist;
@synthesize tableView;
@synthesize datatime1;
@synthesize mobileTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <TrafficDetailDataViewDelegate> *)detailDataviewDelegate siteid:(int)siteflag showType:(NSString*)type{
    delegate = detailDataviewDelegate;
    self = [self initWithFrame:frame];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    flag = siteflag;
    showType = type;
    [self loadDataView];
    [self loadTable];
    return self;
}

- (void) loadTable{
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    lineView = [[LineViewControl alloc] initWithFrame:CGRectMake(5, 5, width-10, 180)];
    lineView.showType = showType;
    [view addSubview:lineView];
    
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(5, 195, width-10, height-200) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor whiteColor];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.layer.cornerRadius = 10;
    tableView1.layer.masksToBounds = YES;
    tableView1.layer.borderWidth = 1;
    tableView1.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.tableView = tableView1;
    
    [view addSubview: tableView];
    
    
    if ([CheckNetwork isExistenceNetwork] == YES){
        TrafficData *tarfficData = [[TrafficData alloc] init];
        [tarfficData getDetailTrafficData:self siteid:flag];
    }else{
        TrafficData *tarfficData = [[TrafficData alloc] init];
        [tarfficData getDetailTrafficDataFromCache:self siteid:flag];
    }

}

- (void) loadDataView{
    [self setAlpha:0.8];
    
    CGFloat x = self.frame.size.width;
    CGFloat y = self.frame.size.height;
    
    NSLog(@"x:%f y:%f", x, y);
    
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(x/2-40, y/2-40, 80, 80)];
    loadingView.backgroundColor = [ [ UIColor alloc ] initWithRed:28/255 green:28/255 blue:28/255 alpha: 0.8];
    [loadingView setAlpha:0.8];
    loadingView.layer.cornerRadius = 10;
    loadingView.layer.masksToBounds = YES;
    [self addSubview:loadingView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x/2-25, y/2-25, 50, 50)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicator startAnimating];

    [self addSubview:activityIndicator];
    
}


- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid{
    NSLog(@"TrafficDetailDataView YoukuDataOk!");
    [self setAlpha:1];
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    for (NSDictionary *datatmp in ret){
        VvDatas *vvdata = [VvDatas alloc];
        
        vvdata.vv = [datatmp objectForKey:@"vv_sum"];
        vvdata.vv_in_sum = [datatmp objectForKey:@"in_vv_sum"];
        vvdata.vv_out_sum = [datatmp objectForKey:@"out_vv_sum"];
        vvdata.date = [datatmp objectForKey:@"date"];
        vvdata.in_ts_hour = [datatmp objectForKey:@"in_ts_hour"];
        vvdata.in_uv = [datatmp objectForKey:@"in_uv"];
        vvdata.out_ts_hour = [datatmp objectForKey:@"out_ts_hour"];
        vvdata.uv_sum = [datatmp objectForKey:@"uv_sum"];
        vvdata.all_ts_hour = [datatmp objectForKey:@"all_ts_hour"];
        vvdata.in_play_uv = [datatmp objectForKey:@"in_play_uv"];
        vvdata.out_play_uv = [datatmp objectForKey:@"out_play_uv"];
        
        [a addObject:vvdata];
    }
    
    datalist = a;
    
    if (datalist!=NULL) {
        [loadingView removeFromSuperview];
        [activityIndicator removeFromSuperview];
        lineView.datalist = a;
        [self addSubview:view];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datalist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	DetailTableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
	}
    
	NSLog(@"DetailTableControl.indexPath: %d", indexPath.row);
    NSLog(@"DetailTableControl.datalist.count: %d", [datalist count]);
    VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"%@", [vvdata date]];
    if ([showType isEqualToString:@"VV"]) {
        cell.label2.text = [NSString stringWithFormat:@"%@", [vvdata vv]];
        cell.label3.text = [NSString stringWithFormat:@"%@", [vvdata vv_in_sum]];
        cell.label4.text = [NSString stringWithFormat:@"%@", [vvdata vv_out_sum]];
    }else if([showType isEqualToString:@"UV"]){
        cell.label2.text = [NSString stringWithFormat:@"%@", [vvdata uv_sum]];
        cell.label3.text = [NSString stringWithFormat:@"%@", [vvdata in_play_uv]];
        cell.label4.text = [NSString stringWithFormat:@"%@", [vvdata out_play_uv]];
    }else{
        cell.label2.text = [NSString stringWithFormat:@"%@", [vvdata all_ts_hour]];
        cell.label3.text = [NSString stringWithFormat:@"%@", [vvdata out_ts_hour]];
        cell.label4.text = [NSString stringWithFormat:@"%@", [vvdata in_ts_hour]];
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) != 0) ? [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 0, 70, 20)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:12];
    compLabel.textColor = [UIColor whiteColor];
    compLabel.text = [NSString stringWithFormat:@"总%@", showType];
    compLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:compLabel];
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 0, 70, 20)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:12];
    vvLabel.textColor = [UIColor whiteColor];
    vvLabel.text = [NSString stringWithFormat:@"站内%@", showType];
    vvLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvLabel];
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(231, 0, 70, 20)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:12];
    vvperLabel.textColor = [UIColor whiteColor];
    vvperLabel.text = [NSString stringWithFormat:@"站外%@", showType];
    vvperLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvperLabel];
    
    
    return headerView;
}

@end
