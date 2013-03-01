//
//  ContentViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//
#define HORIZ_SWIPE_DRAG_MIN 12
#define VERT_SWIPE_DRAG_MAX 8

#import <QuartzCore/QuartzCore.h>
#import "ContentViewControl.h"
#import "SingletonYouku.h"
#import "NSObject_VvDatas.h"
#import "ContentDataViewCell2.h"
#import "CheckNetwork.h"

@implementation ContentViewControl
@synthesize flag;
@synthesize loadingView;
@synthesize activityIndicator;
@synthesize datalist;
@synthesize tudou_datalist;
@synthesize datalist_item;
@synthesize tudou_datalist_item;
@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initContentViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)contentViewDelegate{
    if ((self = [self initWithFrame:frame])){
        delegate = contentViewDelegate;
        
        [self showMainPage3];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //[self showMainPage];
}

- (void) showMainPage3{
    [self loadDataView];
    
    float width = self.frame.size.width;
    float height= self.frame.size.height;
    
    view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.contentSize = CGSizeMake(640, self.frame.size.height);
    view.pagingEnabled = YES;
    view.delegate = self;
    
    
    TableLabelView *tablelabel = [[TableLabelView alloc]initWithFrame:CGRectMake(5, 5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"剧集TOP"];
    UITableView *tableView_item = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, width-2*10, height/2-20) style:UITableViewStylePlain] ;
    tableView_item.backgroundColor = [UIColor whiteColor];
    tableView_item.dataSource = self;
    tableView_item.delegate = self;
    tableView_item.separatorStyle = UITableViewCellAccessoryNone;
    tableView_item.layer.cornerRadius = 10;
    tableView_item.layer.masksToBounds = YES;
    tableView_item.layer.borderWidth = 1;
    tableView_item.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_item.scrollEnabled = YES;
    tableView_item1 = tableView_item;
    
    [view addSubview: tableView_item1];
    [view addSubview: tablelabel];
    
    TableLabelView *tablelabel_r = [[TableLabelView alloc]initWithFrame:CGRectMake(width+5, 5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"剧集TOP"];
    UITableView *tableView_item_r = [[UITableView alloc] initWithFrame:CGRectMake(width+10, 10, width-2*10, height/2-20) style:UITableViewStylePlain] ;
    tableView_item_r.backgroundColor = [UIColor whiteColor];
    tableView_item_r.dataSource = self;
    tableView_item_r.delegate = self;
    tableView_item_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_item_r.layer.cornerRadius = 10;
    tableView_item_r.layer.masksToBounds = YES;
    tableView_item_r.layer.borderWidth = 1;
    tableView_item_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_item_r.scrollEnabled = YES;
    tableView_item2 = tableView_item_r;
    
    [view addSubview: tableView_item2];
    [view addSubview: tablelabel_r];
    
    
    TableLabelView *tablelabel_v = [[TableLabelView alloc]initWithFrame:CGRectMake(5, height/2-20+15, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"视频TOP"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, height/2-20+20, width-2*10, height/2-20) style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    tableView.layer.cornerRadius = 10;
    tableView.layer.masksToBounds = YES;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView.scrollEnabled = YES;
    tableView_video1 = tableView;
    
    [view addSubview: tableView_video1];
    [view addSubview: tablelabel_v];
    
    
    TableLabelView *tablelabel_v_r = [[TableLabelView alloc]initWithFrame:CGRectMake(width+5, height/2-20+15, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"视频TOP"];
    UITableView *tableView_r = [[UITableView alloc] initWithFrame:CGRectMake(width+10, height/2-20+20, width-2*10, height/2-20) style:UITableViewStylePlain] ;
    tableView_r.backgroundColor = [UIColor whiteColor];
    tableView_r.dataSource = self;
    tableView_r.delegate = self;
    tableView_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_r.layer.cornerRadius = 10;
    tableView_r.layer.masksToBounds = YES;
    tableView_r.layer.borderWidth = 1;
    tableView_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_r.scrollEnabled = YES;
    tableView_video2 = tableView_r;
    
    [view addSubview: tableView_video2];
    [view addSubview: tablelabel_v_r];

    if ([CheckNetwork isExistenceNetwork] == YES){
        ContentData *contentData_youku = [[ContentData alloc] init];
        [contentData_youku getContentData:self siteid:1];
        
        ContentData *contentData_tudou = [[ContentData alloc] init];
        [contentData_tudou getContentData:self siteid:2];
    }else{
        ContentData *contentData_youku = [[ContentData alloc] init];
        [contentData_youku getContentDataFromCache:self siteid:1];
        
        ContentData *contentData_tudou = [[ContentData alloc] init];
        [contentData_tudou getContentDataFromCache:self siteid:2];
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
    
    NSArray *outtsarray = [ret mutableArrayValueForKey:@"contentItemDatas"];
    for (int i = 0; i<outtsarray.count; i++){
        NSDictionary *ts=[outtsarray objectAtIndex:i];
        VvDatas *vvdata = [VvDatas alloc];
        vvdata.comp = [ts objectForKey:@"name"];
        vvdata.vv = [NSString stringWithFormat:@"%@",[ts objectForKey:@"VV"] ];
        vvdata.vvper = [NSString stringWithFormat:@"%.2f%%",[[ts objectForKey:@"ratio"] floatValue]];
        [a addObject:vvdata];
    }
    
    
    NSMutableArray *ina = [[NSMutableArray alloc]init];
    NSArray *intsarray = [ret mutableArrayValueForKey:@"contentVideoDatas"];
    for (int i = 0; i<intsarray.count; i++){
        NSDictionary *ts=[intsarray objectAtIndex:i];
        VvDatas *vvdata = [VvDatas alloc];
        vvdata.comp = [ts objectForKey:@"name"];
        vvdata.vv = [NSString stringWithFormat:@"%@",[ts objectForKey:@"VV"]];
        vvdata.vvper = [NSString stringWithFormat:@"%.2f%%",[[ts objectForKey:@"ratio"] floatValue]];
        [ina addObject:vvdata];
    }
    
    if (siteid == 1){
        datalist = a;
        datalist_item = ina;
    }else{
        tudou_datalist = a;
        tudou_datalist_item = ina;
    }
    
    if(datalist!=NULL && datalist_item!=NULL && tudou_datalist!=NULL && tudou_datalist_item!=NULL){
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
	if (tableView == tableView_item1) {
        return [datalist_item count];
    }else if (tableView == tableView_item2){
        return [tudou_datalist_item count];
    }else if (tableView == tableView_video1){
        return [datalist count];
    }else if (tableView == tableView_video2){
        return [tudou_datalist count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
    if (tableView1 == tableView_item1) {
        
        ContentDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ContentDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[datalist_item objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
        
    } else if (tableView1 == tableView_item2){
        ContentDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ContentDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[tudou_datalist_item objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    } else if (tableView1 == tableView_video1){
        ContentDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ContentDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
        
    } else if (tableView1 == tableView_video2){
        ContentDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            cell = [[ContentDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        }
        VvDatas *vvdata = (VvDatas*)[tudou_datalist objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }else{
        return nil;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    if (tableView == tableView_item1 || tableView == tableView_item2) {
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 20)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:14];
        compLabel.textColor = [UIColor blackColor];
        compLabel.text = @"剧集";
        [headerView addSubview:compLabel];
    }else{
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 20)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:14];
        compLabel.textColor = [UIColor blackColor];
        compLabel.text = @"视频";
        [headerView addSubview:compLabel];
    }
    
    
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 90, 20)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:14];
    vvLabel.textColor = [UIColor blackColor];
    vvLabel.text = @"VV";
    vvLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvLabel];
    
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 50, 20)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:14];
    vvperLabel.textColor = [UIColor blackColor];
    vvperLabel.text = @"占比";
    vvperLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvperLabel];
    
    
    return headerView;
}

@end
