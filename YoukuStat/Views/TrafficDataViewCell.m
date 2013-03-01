//
//  TrafficTableViewCell.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-11.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TrafficDataViewCell.h"
#import "SingletonYouku.h"
#import "TrafficTableViewCell2.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject_VvDatas.h"

@implementation TrafficDataViewCell

@synthesize datalist;
@synthesize tableView;
@synthesize _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //self.layer.cornerRadius = 10;
        //self.layer.masksToBounds = YES;
        
        UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 280, frame.size.height) style:UITableViewStylePlain] ;
        tableView1.backgroundColor = [UIColor whiteColor];
        tableView1.dataSource = self;
        tableView1.delegate = self;
        tableView1.separatorStyle = UITableViewCellAccessoryNone;
        tableView1.layer.cornerRadius = 10;
        tableView1.layer.masksToBounds = YES;
        tableView1.layer.borderWidth = 1;
        tableView1.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        tableView1.scrollEnabled = NO;
        self.tableView = tableView1;
        
        [self addSubview: tableView];
    }
    return self;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	TrafficTableViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[TrafficTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
	}
	NSLog(@"TrafficTableViewCell.indexPath: %d", indexPath.row);
    NSLog(@"TrafficTableViewCell.datalist.count: %d", [datalist count]);
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)] ;
    headerView.backgroundColor = [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:16];
    compLabel.textColor = [UIColor whiteColor];
    compLabel.text = @"2013年01月22日";
    compLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:compLabel];
        
    return headerView;
}



@end
