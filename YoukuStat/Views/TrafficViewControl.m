//
//  TrafficDataViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-11.
//  Copyright (c) 2013年 PHH. All rights reserved.
//
#define HORIZ_SWIPE_DRAG_MIN 12
#define VERT_SWIPE_DRAG_MAX 8

#import "TrafficViewControl.h"
#import "SingletonYouku.h"
#import "TrafficDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TrafficTableViewCell2.h"
#import "CheckNetwork.h"

@implementation TrafficViewControl
@synthesize flag;
@synthesize loadingView;
@synthesize activityIndicator;
@synthesize datalist;
@synthesize tudou_datalist;
@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (id)initTrafficViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)trafficDelegate{
    if ((self = [self initWithFrame:frame])){
        delegate = trafficDelegate;
        
        [self showMainPage3];
    }
    return self;
}


- (void) showMainPage3{

    float width = self.frame.size.width;
    float height= self.frame.size.height;
    
    view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.contentSize = CGSizeMake(640, height);
    view.pagingEnabled = YES;
    view.delegate = self;
    
    
    UITapGestureRecognizer *tap_youku = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchYoukuTable)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, height/2-160/2, width-10, 160) style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    tableView.layer.cornerRadius = 10;
    tableView.layer.masksToBounds = YES;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView.scrollEnabled = NO;
    [tableView addGestureRecognizer:tap_youku];
    tableView1 = tableView;
    
    [view addSubview: tableView1];
    
    
    UITapGestureRecognizer *tap_tudou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTudouTable)];
    UITableView *tableView_r = [[UITableView alloc] initWithFrame:CGRectMake(width+5, height/2-160/2, width-10, 160) style:UITableViewStylePlain] ;
    tableView_r.backgroundColor = [UIColor whiteColor];
    tableView_r.dataSource = self;
    tableView_r.delegate = self;
    tableView_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_r.layer.cornerRadius = 10;
    tableView_r.layer.masksToBounds = YES;
    tableView_r.layer.borderWidth = 1;
    tableView_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_r.scrollEnabled = NO;
    [tableView_r addGestureRecognizer:tap_tudou];
    tableView2 = tableView_r;
    
    [view addSubview: tableView2];
    
    [self loadDataView];
    

    
    if ([CheckNetwork isExistenceNetwork] == YES){
        TrafficData *tarfficData_youku = [[TrafficData alloc] init];
        [tarfficData_youku getYoukuTrafficData:self siteid:1];
        
        TrafficData *tarfficData_tudou = [[TrafficData alloc] init];
        [tarfficData_tudou getYoukuTrafficData:self siteid:2];
    }else{
        TrafficData *tarfficData_youku = [[TrafficData alloc] init];
        [tarfficData_youku getYoukuTrafficDataFromCache:self siteid:1];
        
        TrafficData *tarfficData_tudou = [[TrafficData alloc] init];
        [tarfficData_tudou getYoukuTrafficDataFromCache:self siteid:2];
    }

}

- (void) touchYoukuTable{
    NSLog(@"touchYoukuTable");
    [delegate getPcMobileInfo:1 selectTitle:@""];
}

- (void) touchTudouTable{
    NSLog(@"touchTudouTable");
    [delegate getPcMobileInfo:2 selectTitle:@""];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    [delegate scrollViewChange:index];
}

- (void) showDetail:(int)whichType{
    
    detailleftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
    detailrightView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, self.frame.size.height)];
    
    SingletonYouku *s1 = [SingletonYouku alloc];
    s1.width = [[UIScreen mainScreen] bounds].size.width;
    s1.height = [[UIScreen mainScreen] bounds].size.height;
    
    s1.traffic_x = 5;
    s1.traffic_y = 0;
    s1.traffic_width = 310;
    s1.traffic_height = self.frame.size.height;
    
    //detailTable1 = [[TrafficDetailDataView alloc] initWithFrame:CGRectMake(5, s1.traffic_y, 310, s1.traffic_height) delegate:self];
    //[detailleftView addSubview:detailTable1];

    
    //detailTable2 = [[TrafficDetailDataView alloc] initWithFrame:CGRectMake(5, s1.traffic_y, 310, s1.traffic_height) delegate:self];
    //[detailrightView addSubview:detailTable2];

   
}

-(void) returnMain{
    NSLog(@"TrafficViewControl.returnMain().");
    
   
    [detailleftView removeFromSuperview];
    [detailrightView removeFromSuperview];
    
    [tmpleftView removeFromSuperview];
    [tmprightView removeFromSuperview];
    
    [leftView setAlpha:1.0];
    [rightView setAlpha:1.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	if(tableView == tableView1){
        TrafficTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[TrafficTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
        cell.name_label.text = [vvdata name];
        cell.dig_label.text = [NSString stringWithFormat:@"%@", [vvdata digs]];
        cell.perweek_label.text = [vvdata perweek];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        if (indexPath.row==1) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        return cell;
    }else{
        TrafficTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[TrafficTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[tudou_datalist objectAtIndex:indexPath.row];
        cell.name_label.text = [vvdata name];
        cell.dig_label.text = [NSString stringWithFormat:@"%@", [vvdata digs]];
        cell.perweek_label.text = [vvdata perweek];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        if (indexPath.row==1) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //UIColor *color = ((indexPath.row % 2) != 0) ? [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] : [UIColor clearColor];
    //cell.backgroundColor = color;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"TrafficDataViewCell willSelectRowAtIndexPath:%d", indexPath.row);
    //VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
    //[_delegate trafficDataViewSelected:indexPath.row selectTitle:[vvdata name]];
	return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMdd"];
    NSDate  *date = [dateformatter dateFromString:dateStr];
    [dateformatter setDateFormat:@"yyyy年MM月dd日"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)] ;
    headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:16];
    compLabel.textColor = [UIColor whiteColor];
    compLabel.text = [dateformatter stringFromDate:date];
    compLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:compLabel];
    
    return headerView;
}


- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid{
    NSLog(@"YoukuDataOk! siteid:%d",siteid);
    [self setAlpha:1];
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    NSArray *outtsarray = [ret allKeys];
    for (int i = 0; i<outtsarray.count; i++){
        VvDatas *vvdata = [VvDatas alloc];
        id key, value;
        key = [outtsarray objectAtIndex: i];
        value = [ret objectForKey: key];
        
        if( [@"date" isEqualToString: key] ){
            dateStr = value;
            continue;
        }
        NSLog(@"key: %@,value: %@",key,value);
        vvdata.name = key;
        vvdata.digs = value;
        vvdata.perweek = @"";
        [a addObject:vvdata];
    }
    
    if(siteid == 1){
        datalist = a;
    }else{
        tudou_datalist = a;
    }
    
    if (datalist!=NULL && tudou_datalist!=NULL) {
        [self addSubview:view];
        
        [loadingView removeFromSuperview];
        [activityIndicator removeFromSuperview];
    }
    
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




@end
