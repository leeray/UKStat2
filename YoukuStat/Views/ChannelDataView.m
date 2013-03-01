//
//  ChannelDataView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-22.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "ChannelDataView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject_VvDatas.h"
#import "ChannelDataViewCell.h"
#import "ChannelData.h"
#import "ChannelDataViewCell2.h"

@implementation ChannelDataView
@synthesize loadingView;
@synthesize flag;
@synthesize activityIndicator;
@synthesize datalist_youku;
@synthesize tableView_youku;
@synthesize datalist_tudou;
@synthesize tableView_tudou;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    [self showMainPage3];
    
    return self;
}

//- (id)initChannelViewWithFrame:(CGRect)frame delegate:(NSObject <OtherViewControlDelegate>*)channelViewDelegate{
//    if ((self = [self initWithFrame:frame])){
//        delegate = channelViewDelegate;
//        
//        [self showMainPage3];
//    }
//    return self;
//}


- (void) showMainPage3{
    ChannelData *channelData_youku = [[ChannelData alloc] init];
    [channelData_youku getChannelData:self siteid:1];
    
    ChannelData *channelData_tudou = [[ChannelData alloc] init];
    [channelData_tudou getChannelData:self siteid:2];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 340) style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    tableView.layer.cornerRadius = 10;
    tableView.layer.masksToBounds = YES;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView.scrollEnabled = NO;
    tableView_youku = tableView;
    
    UITableView *tableView_r = [[UITableView alloc] initWithFrame:CGRectMake(330, 10, 300, 340) style:UITableViewStylePlain] ;
    tableView_r.backgroundColor = [UIColor whiteColor];
    tableView_r.dataSource = self;
    tableView_r.delegate = self;
    tableView_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_r.layer.cornerRadius = 10;
    tableView_r.layer.masksToBounds = YES;
    tableView_r.layer.borderWidth = 1;
    tableView_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_r.scrollEnabled = NO;
    tableView_tudou = tableView_r;
    
    
    
    [self loadDataView];
}

- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid{
    
    [self setAlpha:1];
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    for (NSDictionary *datatmp in ret){
        VvDatas *vvdata = [VvDatas alloc];
        
        vvdata.channel_name = [datatmp objectForKey:@"channel_name"];
        vvdata.vv = [NSString stringWithFormat:@"%d",[[datatmp objectForKey:@"vv_sum"] intValue]];
        vvdata.all_ts_hour = [NSString stringWithFormat:@"%@",[datatmp objectForKey:@"all_ts_hour"]];
        vvdata.date = [NSString stringWithFormat:@"%@",[datatmp objectForKey:@"date_id"]];
        
        [a addObject:vvdata];
    }
    
    if (siteid == 1) {
        datalist_youku = a;
    }else{
        datalist_tudou = a;
    }
    
    [self addSubview: tableView_youku];
    [self addSubview: tableView_tudou];
    
    [loadingView removeFromSuperview];
    [activityIndicator removeFromSuperview];
}

- (void) loadDataView{
    [self setAlpha:0.8];
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.backgroundColor = [ [ UIColor alloc ] initWithRed:28/255 green:28/255 blue:28/255 alpha: 0.8];
    [loadingView setAlpha:0.8];
    loadingView.layer.cornerRadius = 10;
    loadingView.layer.masksToBounds = YES;
    [loadingView setCenter:self.center];
    [self addSubview:loadingView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40, 50, 50)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicator startAnimating];
    [activityIndicator setCenter:self.center];
    
    [self addSubview:activityIndicator];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tableView_youku) {
        return [datalist_youku count];
    }else{
        return [datalist_tudou count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
    if (tableView1 == tableView_youku) {
        ChannelDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ChannelDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_youku objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata channel_name];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata all_ts_hour];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }else{
        ChannelDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ChannelDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_tudou objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata channel_name];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata all_ts_hour];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) != 0) ? [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)] ;
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:14];
    compLabel.textColor = [UIColor blackColor];
    compLabel.text = @"频道";
    [headerView addSubview:compLabel];
    
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:14];
    vvLabel.textColor = [UIColor blackColor];
    vvLabel.text = @"VV";
    [headerView addSubview:vvLabel];
    
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, 40)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:14];
    vvperLabel.textColor = [UIColor blackColor];
    vvperLabel.text = @"TS(小时)";
    [headerView addSubview:vvperLabel];
    
    return headerView;
}

@end
