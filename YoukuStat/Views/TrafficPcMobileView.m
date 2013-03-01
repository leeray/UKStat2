//
//  TrafficPcMobileView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TrafficPcMobileView.h"
#import "NSObject_VvDatas.h"
#import "PcMobileTableCell.h"
#import "CheckNetwork.h"

@implementation TrafficPcMobileView
@synthesize flag;
@synthesize loadingView;
@synthesize activityIndicator;
@synthesize datalist;
@synthesize tableView;
@synthesize pcdatalist;
@synthesize pctableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <TrafficPcMobileViewDelegate> *)pcmobileViewDelegate siteid:(int)siteflag{
    delegate = pcmobileViewDelegate;
    self = [self initWithFrame:frame];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    flag = siteflag;
    [self loadDataView];
    [self loadTable];
    return self;
}

- (void) loadTable{
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [view setBackgroundColor:[UIColor clearColor]];

    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(5, (height-2*160)/3, width-10, 160) style:UITableViewStylePlain] ;
    tableView1.backgroundColor = [UIColor whiteColor];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.layer.cornerRadius = 10;
    tableView1.layer.masksToBounds = YES;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.layer.borderWidth = 1;
    tableView1.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView1.scrollEnabled = NO;
    self.pctableView = tableView1;
    [view addSubview: pctableView];
    
    UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(5, ((height-2*160)/3)*2+160, width-10, 160) style:UITableViewStylePlain] ;
    tableView2.backgroundColor = [UIColor whiteColor];
    tableView2.dataSource = self;
    tableView2.delegate = self;
    tableView2.layer.cornerRadius = 10;
    tableView2.layer.masksToBounds = YES;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.layer.borderWidth = 1;
    tableView2.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [tableView2 setUserInteractionEnabled:NO];
    self.tableView = tableView2;
    [view addSubview: tableView];
    
    if ([CheckNetwork isExistenceNetwork] == YES){
        TrafficData *tarfficData = [[TrafficData alloc] init];
        [tarfficData getPcMobileTrafficData:self siteid:flag];
    }else{
        TrafficData *tarfficData = [[TrafficData alloc] init];
        [tarfficData getPcMobileTrafficDataFromCache:self siteid:flag];
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
    NSLog(@"TrafficPcMobileView YoukuDataOk!");
    [self setAlpha:1];
    //[self drawDateLine];

    NSMutableArray *a = [[NSMutableArray alloc]init];
    NSDictionary *outtsarray = [ret objectForKey:@"mobileDatas"];
    NSArray *array1 = [outtsarray allKeys];
    for (int i = 0; i<array1.count; i++){
        VvDatas *vvdata = [VvDatas alloc];
        id key, value;
        key = [array1 objectAtIndex: i];
        value = [outtsarray objectForKey: key];
        
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
    datalist = a;
    
    NSMutableArray *b = [[NSMutableArray alloc]init];
    NSDictionary *pcarray = [ret objectForKey:@"trafficDatas"];
    
    VvDatas *vvdata = [VvDatas alloc];
    vvdata.name = @"VV";
    vvdata.digs = [pcarray objectForKey:@"VV"];
    vvdata.vvper = [NSString stringWithFormat:@"同比:%.2f%%", [[pcarray objectForKey:@"VV_rate"] floatValue]];
    [b addObject:vvdata];
    
    VvDatas *uvdata = [VvDatas alloc];
    uvdata.name = @"UV";
    uvdata.digs = [pcarray objectForKey:@"UV"];
    uvdata.vvper = [NSString stringWithFormat:@"同比:%.2f%%", [[pcarray objectForKey:@"UV_rate"] floatValue]];
    [b addObject:uvdata];
    
    VvDatas *tsdata = [VvDatas alloc];
    tsdata.name = @"TS";
    tsdata.digs = [pcarray objectForKey:@"TS"];
    tsdata.vvper = [NSString stringWithFormat:@"同比:%.2f%%", [[pcarray objectForKey:@"TS_rate"] floatValue]];
    [b addObject:tsdata];
    
    //pcmobileTableControl.pcdatatime = [pcarray objectForKey: @"date"];
    
    pcdatalist = b;
    
    if (pcdatalist!=NULL && datalist!=NULL) {
        datestrLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 300, 10)];
        datestrLabel.textAlignment = UITextAlignmentCenter;
        datestrLabel.textColor = [UIColor colorWithRed:1.0/255 green:1.0/255 blue:1.0/255 alpha: 0.8];
        datestrLabel.font = [UIFont fontWithName:@"Arial" size:8];
        datestrLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:datestrLabel];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyyMMdd"];
        NSDate  *date = [dateformatter dateFromString:dateStr];
        [dateformatter setDateFormat:@"yyyy年MM月dd日"];
        datestrLabel.text = [dateformatter stringFromDate:date];
        
        [self addSubview:view];
        [loadingView removeFromSuperview];
        [activityIndicator removeFromSuperview];
    }
}

- (void) drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0/255 green:1.0/255 blue:1.0/255 alpha: 0.3].CGColor);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextMoveToPoint(context, 5, 15);
    CGContextAddLineToPoint(context, 315, 15);
    CGContextDrawPath(context, kCGPathStroke);
}


//- (void) drawDateLine{
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    
//    CGGradientRef glossGradient;
//    CGColorSpaceRef rgbColorspace;
//    size_t num_locations = 2;
//    CGFloat locations[2] = { 0.0, 1.0 };
//    CGFloat components[12] = { 1.0/255.0f, 1.0/255.0f, 1/255.0f, 1.0,
//        1.0/255.0f, 1.0/255.0f, 1.0/255.0f, 1.0,
//    1.0/255.0f, 1.0/255.0f, 1/255.0f, 1.0,};
//    
//    rgbColorspace = CGColorSpaceCreateDeviceRGB();
//    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
//    
//    CGPoint topCenter = CGPointMake(0.0f, 10.0f);
//    CGPoint midCenter = CGPointMake(310.0f, 10.0f);
//
//    //绘制渐变效果
//    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
//    
//    CGGradientRelease(glossGradient);
//    CGColorSpaceRelease(rgbColorspace);
//    
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextSetAllowsAntialiasing(context, NO);
//    CGContextMoveToPoint(context, 5, 5);
//    CGContextAddLineToPoint(context, 310, 5);
//    CGContextDrawPath(context, kCGPathStroke);
//
//}

- (void) pcMobileTableSelected:(int)selected selectTitle:(NSString*)title{
    NSLog(@"TrafficPcMobileView pcMobileTableSelected:%d selectTitle:%@", selected, title);
    //[_delegate getDetailPage:title];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView1 numberOfRowsInSection:(NSInteger)section {
    if(tableView1 == tableView)
        return [datalist count];
    else if(tableView1 == pctableView)
        return [pcdatalist count];
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView1 heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
    PcMobileTableCell *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
    if(tableView1 == pctableView){
        if (cell == nil) {
            cell = [[PcMobileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[pcdatalist objectAtIndex:indexPath.row];
        cell.label1.text = [vvdata name];
        cell.label2.text = [NSString stringWithFormat:@"%@", [vvdata digs]];
        cell.label3.text = [NSString stringWithFormat:@"%@", [vvdata vvper]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(tableView1 == tableView){
        if (cell == nil) {
            cell = [[PcMobileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
        cell.label1.text = [vvdata name];
        cell.label2.text = [NSString stringWithFormat:@"%@", [vvdata digs]];
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) != 0) ? [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
}

- (NSIndexPath *)tableView:(UITableView *)tableView1 willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView1 == pctableView){
        
        VvDatas *vvdata = (VvDatas*)[pcdatalist objectAtIndex:indexPath.row];
        
        NSLog(@"PcMobileTableControl willSelectRowAtIndexPath:%@    indexPath.row:%d", [vvdata name], indexPath.row);
        
        [delegate getDetailPage:[vvdata name]];
    }else if(tableView1 == tableView){
        
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    
    
    if(tableView1 == pctableView){
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 40)] ;
        headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
        
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:16];
        compLabel.textColor = [UIColor whiteColor];
        compLabel.text = @"PC";
        compLabel.textAlignment = UITextAlignmentCenter;
        [headerView addSubview:compLabel];
        
        return headerView;
        
    }else if(tableView1 == tableView){

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
        headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
        
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:16];
        compLabel.textColor = [UIColor whiteColor];
        compLabel.text = @"MOBILE";
        compLabel.textAlignment = UITextAlignmentCenter;
        [headerView addSubview:compLabel];
        
        return headerView;
        
    }
    
    
    return headerView;
}

@end
