//
//  HeadViewControl.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-2-1.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "HeadViewControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeadViewControl
@synthesize headerArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withHeaderArray:(NSArray *)tabnameArray delegate:(NSObject <HeadViewControlDelegate>*)headViewDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    headerArray = tabnameArray;
    delegate = headViewDelegate;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self initHeadView];
    return self;
}

- (void) initHeadView{
    
    int count = [headerArray count];
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    //上下空出5个像素
    float label_height = height - 2 * 5;
    
    buttons = [[NSMutableArray alloc] initWithCapacity:count];
    
    headView = [[HeadView alloc]initWithFrame:CGRectMake(-20, 0, width/2+40, height)];
    [self addSubview:headView];
    
    for (int i = 0; i < count; i++) {
        UILabel *tabTitle = [[UILabel alloc]initWithFrame:CGRectMake(width/2*i, 5, width/2, label_height)];
        tabTitle.text = [headerArray objectAtIndex:i];
        if (i == 0) {
            tabTitle.textColor = [UIColor whiteColor];
            tabTitle.tag = 0;
        }else{
            tabTitle.tag = 1;
        }
        tabTitle.backgroundColor = [UIColor clearColor];
        tabTitle.textAlignment = UITextAlignmentCenter;
        tabTitle.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:tabTitle];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width/2*i, 5, width/2, label_height)];
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        [self addSubview:button];
    }
}

-(void) drawRect:(CGRect)rect{
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(currentContext, [UIColor redColor].CGColor);
    
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    //右边白色好难看

    CGColorSpaceRef rgb_rigth = CGColorSpaceCreateDeviceRGB();
    CGFloat colors_right[] =
    {
        251.0/255.0f, 251.0/255.0f, 251/255.0f, 0.8,
        103.0/255.0f, 103.0/255.0f, 103/255.0f, 1.0,
    };
    CGGradientRef gradient_right = CGGradientCreateWithColorComponents(rgb_rigth, colors_right, NULL, sizeof(colors_right)/(sizeof(colors_right[0])*4));
    CGColorSpaceRelease(rgb_rigth);
    CGContextDrawLinearGradient(currentContext, gradient_right, CGPointMake(width, 0), CGPointMake(width,height), 0);
}

- (void)touchUpInsideAction:(UIButton*)button
{
    CGFloat segmentCount = [buttons count];
    CGFloat buttonWidth = (self.frame.size.width / 2) + 4 * 10.0;
    CGFloat buttonIndex = [buttons indexOfObject:button];
    CGFloat newPosition = (self.frame.size.width / 2) * buttonIndex  - 20.0;
    
    if (headView.frame.origin.x != newPosition){
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [headView setFrame:CGRectMake(newPosition, 0, self.frame.size.width/2+40, self.frame.size.height)];
        
        
        for (UILabel* temp in [self subviews]) {
            if ([temp isKindOfClass:[UILabel class]]) {
                if (temp.tag == 0) {
                    temp.textColor = [UIColor blackColor];
                    temp.tag = 1;
                }else if (temp.tag == 1){
                    temp.textColor = [UIColor whiteColor];
                    temp.tag = 0;
                }
            }
        }
        
        [UIView commitAnimations];
        
        [delegate HeadTitleChange:buttonIndex];
    }

}

- (void)ScrollViewChanage:(int)index
{
    CGFloat newPosition = (self.frame.size.width / 2) * index  - 20.0;
    
    if (headView.frame.origin.x != newPosition){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [headView setFrame:CGRectMake(newPosition, 0, self.frame.size.width/2+40, self.frame.size.height)];
        
        
        for (UILabel* temp in [self subviews]) {
            if ([temp isKindOfClass:[UILabel class]]) {
                if (temp.tag == 0) {
                    temp.textColor = [UIColor blackColor];
                    temp.tag = 1;
                }else if (temp.tag == 1){
                    temp.textColor = [UIColor whiteColor];
                    temp.tag = 0;
                }
            }
        }
        
        [UIView commitAnimations];
    }
    
}

@end
