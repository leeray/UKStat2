//
//  TrafficTableViewCell2.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-15.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TrafficTableViewCell2.h"

@implementation TrafficTableViewCell2
@synthesize image;
@synthesize name;
@synthesize dig;
@synthesize perweek;
@synthesize name_label;
@synthesize dig_label;
@synthesize perweek_label;
@synthesize label4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        
        name_label = [[UILabel alloc]initWithFrame:CGRectMake(40, 1, 70, 38)];
        name_label.font = [UIFont fontWithName:@"Arial" size:14.0];
        name_label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:name_label];

        
        dig_label = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, 100, 38)];
        dig_label.font = [UIFont fontWithName:@"Arial" size:14.0];
        dig_label.textAlignment = UITextAlignmentRight;
        dig_label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:dig_label];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
