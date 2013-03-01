//
//  OtherViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//
#define HORIZ_SWIPE_DRAG_MIN 12
#define VERT_SWIPE_DRAG_MAX 8

#import "OtherViewControl.h"
#import "SingletonYouku.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject_VvDatas.h"
#import "ChannelDataViewCell2.h"
#import "ChannelDataView.h"
#import "CheckNetwork.h"


@implementation OtherViewControl
@synthesize loadingView;
@synthesize flag;
@synthesize activityIndicator;
@synthesize datalist_youku;
@synthesize tableView_youku;
@synthesize datalist_tudou;
@synthesize tableView_tudou;
@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initChannelViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)channelViewDelegate{
    if ((self = [self initWithFrame:frame])){
        delegate = channelViewDelegate;
        
        [self showMainPage3];
    }
    return self;
}

- (void) showMainPage3{
    
    float width = self.frame.size.width;
    float height= self.frame.size.height;
    
    view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.contentSize = CGSizeMake(640, self.frame.size.height);
    view.pagingEnabled = YES;
    view.delegate = self;

    TableLabelView *tablelabel_youku = [[TableLabelView alloc]initWithFrame:CGRectMake(5, 5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"频道"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, width-20, height-20) style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    tableView.layer.cornerRadius = 10;
    tableView.layer.masksToBounds = YES;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView.scrollEnabled = YES;
    tableView_youku = tableView;
    
    [view addSubview: tableView_youku];
    [view addSubview: tablelabel_youku];
    
    TableLabelView *tablelabel_tudou = [[TableLabelView alloc]initWithFrame:CGRectMake(width+5, 5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"频道"];
    UITableView *tableView_r = [[UITableView alloc] initWithFrame:CGRectMake(width+10, 10, width-20, height-20) style:UITableViewStylePlain] ;
    tableView_r.backgroundColor = [UIColor whiteColor];
    tableView_r.dataSource = self;
    tableView_r.delegate = self;
    tableView_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_r.layer.cornerRadius = 10;
    tableView_r.layer.masksToBounds = YES;
    tableView_r.layer.borderWidth = 1;
    tableView_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_r.scrollEnabled = YES;
    tableView_tudou = tableView_r;
    
    [view addSubview: tableView_tudou];
    [view addSubview: tablelabel_tudou];
    
    [self loadDataView];
    
    if ([CheckNetwork isExistenceNetwork] == YES){
        ChannelData *channelData_youku = [[ChannelData alloc] init];
        [channelData_youku getChannelData:self siteid:1];
        
        ChannelData *channelData_tudou = [[ChannelData alloc] init];
        [channelData_tudou getChannelData:self siteid:2];
    }else{
        ChannelData *channelData_youku = [[ChannelData alloc] init];
        [channelData_youku getChannelDataFromCache:self siteid:1];
        
        ChannelData *channelData_tudou = [[ChannelData alloc] init];
        [channelData_tudou getChannelDataFromCache:self siteid:2];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    [delegate scrollViewChange:index];
}

- (void) YoukuDataOK:(NSDictionary*)ret siteid:(int)siteid{
    
    [self setAlpha:1];
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    for (NSDictionary *datatmp in ret){
        VvDatas *vvdata = [VvDatas alloc];
        
        vvdata.channel_name = [datatmp objectForKey:@"channel_name"];
        vvdata.vv = [NSString stringWithFormat:@"%@",[datatmp objectForKey:@"vv_sum"]];
        vvdata.all_ts_hour = [NSString stringWithFormat:@"%@",[datatmp objectForKey:@"all_ts_hour"]];
        vvdata.date = [NSString stringWithFormat:@"%@",[datatmp objectForKey:@"date_id"]];
        
        [a addObject:vvdata];
    }
    
    if (siteid == 1) {
        datalist_youku = a;
    }else{
        datalist_tudou = a;
    }
    
    if (datalist_tudou!=NULL && datalist_tudou!=NULL) {
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
    return 20;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 20)] ;
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 20)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:14];
    compLabel.textColor = [UIColor blackColor];
    compLabel.text = @"频道名";
    [headerView addSubview:compLabel];
    
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 90, 20)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:14];
    vvLabel.textColor = [UIColor blackColor];
    vvLabel.text = @"VV";
    vvLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvLabel];
    
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, 20)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:14];
    vvperLabel.textColor = [UIColor blackColor];
    vvperLabel.text = @"TS(小时)";
    vvperLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvperLabel];
    
    return headerView;
}

////手势操作
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    startTouchPosition = [touch locationInView:self];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = touches.anyObject;
//    CGPoint currentTouchPosition = [touch locationInView:self];
//    if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
//        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX) {
//        // Horizontal Swipe
//        if (startTouchPosition.x < currentTouchPosition.x) {
//            NSLog(@"from left");
//            dirString = @"left";
//        }else{
//            NSLog(@"from right");
//            dirString = @"right";
//        }
//    } else if (fabsf(startTouchPosition.y - currentTouchPosition.y) >=
//               HORIZ_SWIPE_DRAG_MIN &&
//               fabsf(startTouchPosition.x - currentTouchPosition.x) <=
//               VERT_SWIPE_DRAG_MAX){
//        // Vertical Swipe
//        if (startTouchPosition.y < currentTouchPosition.y) {
//            NSLog(@"from bottom");
//            dirString = @"bottom";}
//        else    {
//            NSLog(@"from top");
//            dirString = @"top";}
//    } else {
//        //dirString = @"";
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (dirString == @"right") {
//        NSLog(@"FrominViewControl event right . leftView.x:%f", leftView.frame.origin.x);
//        if (leftView.frame.origin.x >= 0 ){
//            [self youkuMoveTudou];
//            [delegate moveRigth];
//        }
//    }else if (dirString == @"left") {
//        NSLog(@"FrominViewControl event left . leftView.x:%f", leftView.frame.origin.x);
//        if (leftView.frame.origin.x < 0 ){
//            [self tudouMoveYouku];
//            [delegate moveLeft];
//        }
//    }
//}
//
//-(void)youkuMoveTudou{
//    NSLog(@"FrominViewControl.youkuMoveTudou()");
//    
//    leftView.frame = CGRectMake(0, 0, 320, self.frame.size.height);
//    rightView.frame = CGRectMake(320, 0, 320, self.frame.size.height);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5];
//    leftView.frame = CGRectMake(-320, 0, 320, self.frame.size.height);
//    rightView.frame = CGRectMake(0, 0, 320, self.frame.size.height);
//    
//    [UIView commitAnimations];
//}
//
//-(void)tudouMoveYouku{
//    NSLog(@"FrominViewControl.tudouMoveYouku");
//    
//    leftView.frame = CGRectMake(-320, 0, 320, self.frame.size.height);
//    rightView.frame = CGRectMake(0, 0, 320, self.frame.size.height);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5];
//    leftView.frame = CGRectMake(0, 0, 320, self.frame.size.height);
//    rightView.frame = CGRectMake(320, 0, 320, self.frame.size.height);
//    
//    [UIView commitAnimations];
//}
//
//- (void) changeModelView{
//    [UIView beginAnimations:@"animationID" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
//    [UIView commitAnimations];
//}

//- (void)drawRect:(CGRect)rect
//{
//    UIView *aboutMe = [[UIView alloc] initWithFrame:CGRectMake(20, 20, [SingletonYouku alloc].width - 40, [SingletonYouku alloc].height-40-40-40-20)];
//    aboutMe.backgroundColor = [UIColor whiteColor];
//    aboutMe.layer.cornerRadius = 10;
//    aboutMe.layer.masksToBounds = YES;
//    
//    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 260, 20)];
//    info.font = [UIFont fontWithName:@"Arial" size:10];
//    info.text = @"版本:1.0\n";
//    info.numberOfLines = 0;
//    [aboutMe addSubview:info];
//    [info release];
//    
//    UILabel *urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 80, 20)];
//    urlLabel.font = [UIFont fontWithName:@"Arial" size:10];
//    urlLabel.text = @"统计平台网页版:";
//    [aboutMe addSubview:urlLabel];
//    [urlLabel release];
//    
//    UIButton *url = [[UIButton alloc]initWithFrame:CGRectMake(100, 40, 140, 20)];
//    url.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
//    [url setTitle:@"http://10.10.151.15/" forState:UIControlStateNormal] ;
//    url.backgroundColor = [UIColor clearColor];
//    url.titleLabel.textColor = [UIColor darkGrayColor];
//    [url addTarget:self action:@selector(openUrl) forControlEvents:UIControlEventTouchUpInside];
//    [aboutMe addSubview:url];
//    [url release];
//    
//    [self addSubview:aboutMe];
//    [aboutMe release];
//}
//
//- (void)openUrl{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://10.10.151.15:8000/"]];
//}

@end
