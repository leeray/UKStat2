//
//  FrominDataViewCell2.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-16.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "FrominDataViewCell2.h"

@implementation FrominDataViewCell2

@synthesize comp_label;
@synthesize vv_label;
@synthesize vvper_label;
@synthesize num_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        num_label = [[UILabel alloc]initWithFrame:CGRectMake(5, 1, 10, 30)];
        num_label.backgroundColor = [UIColor clearColor];
        num_label.font = [UIFont fontWithName:@"Arial" size:13.0];
        [self.contentView addSubview:num_label];
        
        comp_label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        comp_label.backgroundColor = [UIColor clearColor];
        comp_label.font = [UIFont fontWithName:@"Arial" size:13.0];
        [self.contentView addSubview:comp_label];
        
        vv_label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 90, 30)];
        vv_label.backgroundColor = [UIColor clearColor];
        vv_label.font = [UIFont fontWithName:@"Arial" size:13.0];
        vv_label.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:vv_label];
        
        vvper_label = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 50, 30)];
        vvper_label.backgroundColor = [UIColor clearColor];
        vvper_label.font = [UIFont fontWithName:@"Arial" size:12.0];
        vvper_label.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:vvper_label];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
