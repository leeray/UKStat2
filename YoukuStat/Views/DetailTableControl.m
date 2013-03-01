//
//  DetailDataControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "DetailTableControl.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailTableViewCell.h"
#import "NSObject_VvDatas.h"

@implementation DetailTableControl

@synthesize datatime1;
@synthesize datalist;
@synthesize tableView;
@synthesize mobileTableView;
@synthesize showType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, rect.size.height -5) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor whiteColor];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.layer.cornerRadius = 10;
    tableView1.layer.masksToBounds = YES;
    tableView1.layer.borderWidth = 1;
    tableView1.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.tableView = tableView1;
    
    [self addSubview: tableView];
    
//    UITableView *mobileTableView1 = [[[UITableView alloc] initWithFrame:CGRectMake(5, rect.size.height/2+5, 280, rect.size.height/2) style:UITableViewStylePlain] autorelease];
//    mobileTableView1.backgroundColor = [UIColor whiteColor];
//    mobileTableView1.dataSource = self;
//    mobileTableView1.delegate = self;
//    self.mobileTableView = mobileTableView1;
//    
//    [self addSubview: mobileTableView1];
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
    return 40;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 0, 70, 40)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:12];
    compLabel.textColor = [UIColor whiteColor];
    compLabel.text = [NSString stringWithFormat:@"总%@", showType];
    [headerView addSubview:compLabel];
    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 0, 70, 40)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:12];
    vvLabel.textColor = [UIColor whiteColor];
    vvLabel.text = [NSString stringWithFormat:@"站内%@", showType];
    [headerView addSubview:vvLabel];
    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(231, 0, 70, 40)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:12];
    vvperLabel.textColor = [UIColor whiteColor];
    vvperLabel.text = [NSString stringWithFormat:@"站外%@", showType];
    [headerView addSubview:vvperLabel];

    
    return headerView;
}


@end
