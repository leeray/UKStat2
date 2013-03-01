//
//  PcMobileTableControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "PcMobileTableControl.h"
#import <QuartzCore/QuartzCore.h>
#import "PcMobileTableCell.h"
#import "NSObject_VvDatas.h"
#import "TableLabelView.h"

@implementation PcMobileTableControl

@synthesize datalist;
@synthesize tableView;
@synthesize pcdatalist;
@synthesize pctableView;
@synthesize _delegate;
@synthesize datatime;
@synthesize pcdatatime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    [self loadTable:self.frame];
    
    return self;
}

- (void) loadTable:(CGRect)rect{

    int height = rect.size.height;
    
    CGFloat table1_y = (height - 160 - 160)/3;
    
    //TableLabelView *tablelabel1 = [[TableLabelView alloc]initWithFrame:CGRectMake(0, 0, 70, 70) x_rect:70 y_rect:70 table_corner_size:30 size_3d:5];
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(5, table1_y, 290, 160) style:UITableViewStylePlain] ;
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
    [self addSubview: pctableView];
    //[self addSubview:tablelabel1];
    
    UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(5, table1_y+160+table1_y, 290, 160) style:UITableViewStylePlain] ;
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
    [self addSubview: tableView];

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
        
        [_delegate pcMobileTableSelected:indexPath.row selectTitle:[vvdata name]];
    }else if(tableView1 == tableView){
        
    }
    
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    
    
    if(tableView1 == pctableView){
        
//        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 40)];
//        compLabel.backgroundColor = [UIColor clearColor];
//        compLabel.font = [UIFont fontWithName:@"ArialMT" size:16.0];
//        compLabel.textColor = [UIColor blackColor];
//        NSString *title = [NSString stringWithFormat:@"%@", pcdatatime];
//        compLabel.text = title;
//        [headerView addSubview:compLabel];
//        [compLabel release];
        
//        UILabel *rateLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 1, 50, 40)];
//        rateLable.backgroundColor = [UIColor clearColor];
//        rateLable.font = [UIFont fontWithName:@"ArialMT" size:16.0];
//        rateLable.textColor = [UIColor blackColor];
//        rateLable.text = @"同比";
//        [headerView addSubview:rateLable];
//        [rateLable release];
        
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
//        UILabel *compLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 40)];
//        compLabel.backgroundColor = [UIColor clearColor];
//        compLabel.font = [UIFont fontWithName:@"ArialMT" size:16.0];
//        compLabel.textColor = [UIColor blackColor];
//        NSString *title = [NSString stringWithFormat:@"%@", datatime];
//        compLabel.text = title;
//        [headerView addSubview:compLabel];
//        [compLabel release];
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
