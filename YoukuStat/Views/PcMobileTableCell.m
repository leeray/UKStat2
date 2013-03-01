//
//  PcMobileTableCell.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-21.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "PcMobileTableCell.h"

@implementation PcMobileTableCell
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
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
        label1.backgroundColor = [UIColor clearColor];
        //label1.text = name;
        [self.contentView addSubview:label1];
        
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 100, 40)];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label2];
        
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 80, 40)];
        label3.backgroundColor = [UIColor clearColor];
        label3.font = [UIFont fontWithName:@"Arial" size:12];
        label3.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label3];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
