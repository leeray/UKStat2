//
//  DetailTableViewCell.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-17.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell
@synthesize image;
@synthesize name;
@synthesize dec;
@synthesize loc;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(6, 1, 70, 30)];
        label1.font = [UIFont fontWithName:@"Arial" size:10.00];
        label1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label1];
        
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(81, 1, 70, 30)];
        label2.font = [UIFont fontWithName:@"Arial" size:10.00];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label2];
        
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(156, 1, 70, 30)];
        label3.font = [UIFont fontWithName:@"Arial" size:10.00];
        label3.backgroundColor = [UIColor clearColor];
        label3.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label3];
        
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(231, 1, 70, 30)];
        label4.font = [UIFont fontWithName:@"Arial" size:10.00];
        label4.backgroundColor = [UIColor clearColor];
        label4.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label4];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
