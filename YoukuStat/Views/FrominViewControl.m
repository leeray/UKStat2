//
//  FrominViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//
#define HORIZ_SWIPE_DRAG_MIN 12
#define VERT_SWIPE_DRAG_MAX 8

#import "FrominViewControl.h"
#import "SingletonYouku.h"
#import "NSObject_VvDatas.h"
#import "FrominDataViewCell2.h"
#import <QuartzCore/QuartzCore.h>
#import "TableLabelView.h"
#import "CheckNetwork.h"


@implementation FrominViewControl
@synthesize flag;
@synthesize loadingView;
@synthesize activityIndicator;
@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initFrominViewWithFrame:(CGRect)frame delegate:(NSObject <ScrollViewProtocol>*)frominViewDelegate{
    if ((self = [self initWithFrame:frame])){
        delegate = frominViewDelegate;
        
        [self showMainPage3];
    }
    return self;
}

- (void) showMainPage3{
    [self loadDataView];
    
    float width = self.frame.size.width;
    float height= self.frame.size.height;
    
    view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.contentSize = CGSizeMake(640, self.frame.size.height);
    view.pagingEnabled = YES;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.delegate = self;
    
    float clear_height = (height - 2 * 170) / 3;
    
    //优酷-上
    TableLabelView *tablelabel_item = [[TableLabelView alloc]initWithFrame:CGRectMake(5, clear_height-5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"站内转化"];
    
    UITableView *tableView_item = [[UITableView alloc] initWithFrame:CGRectMake(10, clear_height, width-2*10, 170) style:UITableViewStylePlain] ;
    tableView_item.backgroundColor = [UIColor whiteColor];
    tableView_item.dataSource = self;
    tableView_item.delegate = self;
    tableView_item.separatorStyle = UITableViewCellAccessoryNone;
    tableView_item.layer.cornerRadius = 10;
    tableView_item.layer.masksToBounds = YES;
    tableView_item.layer.borderWidth = 1;
    tableView_item.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_item.scrollEnabled = NO;
    tableView_youku_zhannei = tableView_item;
    
    [view addSubview: tableView_youku_zhannei];
    [view addSubview: tablelabel_item];
    
    
    //土豆-上
    TableLabelView *tablelabel_item_r = [[TableLabelView alloc]initWithFrame:CGRectMake(width+5, clear_height-5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"站内转化"];
    
    UITableView *tableView_item_r = [[UITableView alloc] initWithFrame:CGRectMake(width+10, clear_height, width-2*10, 170) style:UITableViewStylePlain] ;
    tableView_item_r.backgroundColor = [UIColor whiteColor];
    tableView_item_r.dataSource = self;
    tableView_item_r.delegate = self;
    tableView_item_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_item_r.layer.cornerRadius = 10;
    tableView_item_r.layer.masksToBounds = YES;
    tableView_item_r.layer.borderWidth = 1;
    tableView_item_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_item_r.scrollEnabled = NO;
    tableView_tudou_zhannei = tableView_item_r;
    
    [view addSubview: tableView_tudou_zhannei];
    [view addSubview: tablelabel_item_r];
    
    
    //优酷-下
    TableLabelView *tablelabel = [[TableLabelView alloc]initWithFrame:CGRectMake(5, 2*clear_height+170-5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"站外来源"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 2*clear_height+170, width-2*10, 170) style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    tableView.layer.cornerRadius = 10;
    tableView.layer.masksToBounds = YES;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView.scrollEnabled = NO;
    tableView_youku_zhanwai = tableView;
    
    [view addSubview: tableView_youku_zhanwai];
    [view addSubview: tablelabel];
    
    
    //土豆-下
    TableLabelView *tablelabel_r = [[TableLabelView alloc]initWithFrame:CGRectMake(width+5, 2*clear_height+170-5, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5 showInfo:@"站外来源"];
    
    UITableView *tableView_r = [[UITableView alloc] initWithFrame:CGRectMake(width+10, 2*clear_height+170, width-2*10, 170) style:UITableViewStylePlain] ;
    tableView_r.backgroundColor = [UIColor whiteColor];
    tableView_r.dataSource = self;
    tableView_r.delegate = self;
    tableView_r.separatorStyle = UITableViewCellAccessoryNone;
    tableView_r.layer.cornerRadius = 10;
    tableView_r.layer.masksToBounds = YES;
    tableView_r.layer.borderWidth = 1;
    tableView_r.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    tableView_r.scrollEnabled = NO;
    tableView_tudou_zhanwai = tableView_r;
    
    [view addSubview: tableView_tudou_zhanwai];
    [view addSubview: tablelabel_r];
    
    
    
    if ([CheckNetwork isExistenceNetwork] == YES){
        FrominData *frominData_youku = [[FrominData alloc] init];
        [frominData_youku getFrominData:self siteid:1];
        
        FrominData *frominData_tudou = [[FrominData alloc] init];
        [frominData_tudou getFrominData:self siteid:2];
    }else{
        FrominData *frominData_youku = [[FrominData alloc] init];
        [frominData_youku getFrominDataFromCache:self siteid:1];
        
        FrominData *frominData_tudou = [[FrominData alloc] init];
        [frominData_tudou getFrominDataFromCache:self siteid:2];
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
    
    NSArray *outtsarray = [ret mutableArrayValueForKey:@"out_ts_hour"];
    for (int i = 0; i<outtsarray.count; i++){
        NSDictionary *ts=[outtsarray objectAtIndex:i];
        VvDatas *vvdata = [VvDatas alloc];
        vvdata.comp = [ts objectForKey:@"Company"];
        vvdata.vv = [NSString stringWithFormat:@"%@",[ts objectForKey:@"VV"]];
        vvdata.vvper = [NSString stringWithFormat:@"%@%%",[ts objectForKey:@"ratio"]];
        [a addObject:vvdata];
        
    }

    NSMutableArray *ina = [[NSMutableArray alloc]init];
    NSArray *intsarray = [ret mutableArrayValueForKey:@"in_ts_hour"];
    for (int i = 0; i<intsarray.count; i++){
        NSDictionary *ts=[intsarray objectAtIndex:i];
        VvDatas *vvdata = [VvDatas alloc];
        vvdata.comp = [ts objectForKey:@"Company"];
        vvdata.vv = [NSString stringWithFormat:@"%@",[ts objectForKey:@"VV"]];
        vvdata.vvper = [NSString stringWithFormat:@"%@%%",[ts objectForKey:@"ratio"]];
        [ina addObject:vvdata];
        
    }
    
    if (siteid == 1) {
        datalist_youku_zhannei = ina;
        datalist_youku_zhanwai = a;
    }else{
        datalist_tudou_zhannei = ina;
        datalist_tudou_zhanwai = a;
    }
    
    if (datalist_youku_zhannei!=NULL && datalist_youku_zhanwai!=NULL && datalist_tudou_zhannei!=NULL && datalist_tudou_zhanwai!=NULL){
        [self addSubview:view];
        [loadingView removeFromSuperview];
        [activityIndicator removeFromSuperview];
    }

}

- (void) YoukuDataError{
    
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
	if (tableView_youku_zhannei == tableView){
        return [datalist_youku_zhannei count];
    }else if (tableView_youku_zhanwai == tableView){
        return [datalist_youku_zhanwai count];
    }else if (tableView_tudou_zhannei == tableView){
        return [datalist_tudou_zhannei count];
    }else if (tableView_tudou_zhanwai == tableView){
        return [datalist_tudou_zhanwai count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
    if (tableView_youku_zhannei == tableView){
        FrominDataViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[FrominDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_youku_zhannei objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }else if (tableView_youku_zhanwai == tableView){
        FrominDataViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[FrominDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_youku_zhanwai objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }else if (tableView_tudou_zhannei == tableView){
        FrominDataViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[FrominDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_tudou_zhannei objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }else if (tableView_tudou_zhanwai == tableView){
        FrominDataViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[FrominDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        VvDatas *vvdata = (VvDatas*)[datalist_tudou_zhanwai objectAtIndex:indexPath.row];
        cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
        cell.comp_label.text = [vvdata comp];
        cell.vv_label.text = [vvdata vv];
        cell.vvper_label.text = [vvdata vvper];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        return cell;
    }
    
	return nil;
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
    headerView.backgroundColor = [UIColor colorWithRed:53/255.0f green:91/255.0f blue:179/255.0f alpha:1.0f];
    
    if (tableView_youku_zhannei == tableView || tableView == tableView_tudou_zhannei){
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 70, 20)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:14];
        compLabel.textColor = [UIColor whiteColor];
        compLabel.text = @"页面";
        [headerView addSubview:compLabel];
    }else{
        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 70, 20)];
        compLabel.backgroundColor = [UIColor clearColor];
        compLabel.font = [UIFont boldSystemFontOfSize:14];
        compLabel.textColor = [UIColor whiteColor];
        compLabel.text = @"公司";
        [headerView addSubview:compLabel];
    }
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 90, 20)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:14];
    vvLabel.textColor = [UIColor whiteColor];
    vvLabel.text = @"VV";
    vvLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvLabel];
    
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 20)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:14];
    vvperLabel.textColor = [UIColor whiteColor];
    vvperLabel.text = @"占比";
    vvperLabel.textAlignment = UITextAlignmentRight;
    [headerView addSubview:vvperLabel];
    
    
    return headerView;
}


@end
