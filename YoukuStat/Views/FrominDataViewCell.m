//
//  FrominDataViewCell.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "FrominDataViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FrominDataViewCell2.h"
#import "NSObject_VvDatas.h"

@implementation FrominDataViewCell

@synthesize datalist;
@synthesize tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 280, frame.size.height-5) style:UITableViewStylePlain] ;
        tableView1.backgroundColor = [UIColor whiteColor];
        tableView1.layer.cornerRadius = 10;
        tableView1.layer.masksToBounds = YES;
        tableView1.layer.borderWidth = 1;
        tableView1.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView1.dataSource = self;
        tableView1.delegate = self;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	FrominDataViewCell2 *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[FrominDataViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
	}
	NSLog(@"FrominDataViewCell.indexPath: %d", indexPath.row);
    NSLog(@"FrominDataViewCell.datalist.count: %d", [datalist count]);
    VvDatas *vvdata = (VvDatas*)[datalist objectAtIndex:indexPath.row];
    cell.num_label.text = [NSString stringWithFormat:@"%d", indexPath.row + 1 ];
    cell.comp_label.text = [vvdata comp];
    cell.vv_label.text = [vvdata vv];
    cell.vvper_label.text = [vvdata vvper];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	
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
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];

    UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 110, 40)];
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.font = [UIFont boldSystemFontOfSize:14];
    compLabel.textColor = [UIColor blackColor];
    compLabel.text = @"公司";
    [headerView addSubview:compLabel];

    
    UILabel *vvLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 100, 40)];
    vvLabel.backgroundColor = [UIColor clearColor];
    vvLabel.font = [UIFont boldSystemFontOfSize:14];
    vvLabel.textColor = [UIColor blackColor];
    vvLabel.text = @"VV";
    [headerView addSubview:vvLabel];

    
    UILabel *vvperLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 30, 40)];
    vvperLabel.backgroundColor = [UIColor clearColor];
    vvperLabel.font = [UIFont boldSystemFontOfSize:14];
    vvperLabel.textColor = [UIColor blackColor];
    vvperLabel.text = @"占比";
    [headerView addSubview:vvperLabel];

    
    return headerView;
}

- (void)reloadInputViews{
    
}

@end
