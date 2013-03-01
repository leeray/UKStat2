//
//  TableLabelView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-19.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TableLabelView.h"
#import <QuartzCore/QuartzCore.h>
#import "Math.h"

//x_rect: x轴长度
//y_rect: y轴长度
//table_corner_size:包含的table角度的长度
//size_3d: 标签的立体感
//info: 显示的信息


@implementation TableLabelView
@synthesize x_rect;
@synthesize y_rect;
@synthesize table_corner_size;
@synthesize size_3d;
@synthesize showinfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame x_rect:(int)x_rect1 y_rect:(int)y_rect1 table_corner_size:(int)table_corner_size1 size_3d:(int)size_3d1 showInfo:(NSString *)info{
    x_rect = x_rect1;
    y_rect = y_rect1;
    table_corner_size = table_corner_size1;
    size_3d = size_3d1;
    showinfo = info;
    self = [self initWithFrame:frame];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawCorner_left];
    [self drawCorner_rigth];
    [self drawRectangle];
    
    //根据等腰三角形算出底边长度
    double length_label = (x_rect-table_corner_size) * sqrt(2-2*cos(90));
    NSLog(@"length_label:%2f", length_label);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-8, 15, length_label, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = showinfo;
    label.font = [UIFont fontWithName:@"ArialMT" size:14];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 2;
    label.layer.masksToBounds = YES;
    label.transform = CGAffineTransformMakeRotation(-0.8);
    
    [self addSubview:label];
    
}


- (void) drawCorner_left{
    //获得当前view的图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //制定了线的宽度
    CGContextSetLineWidth(context, 2.0);
    
    //使用画笔颜色
    //CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f].CGColor);
    
    //设置阴影
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    
    //???猜测：保存了上下文设置的状态???
    CGContextSaveGState(context);
    
    CGRect rrect = self.bounds;

    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    NSLog(@"TableLabelView  width:%f   height:%f", width, height);
    
    CGContextMoveToPoint(context, size_3d, y_rect);
    CGContextAddLineToPoint(context, 0, y_rect-size_3d);
    CGContextAddLineToPoint(context, size_3d, y_rect-size_3d*2);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

- (void) drawCorner_rigth{
    //获得当前view的图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //制定了线的宽度
    CGContextSetLineWidth(context, 2.0);
    //使用刚才创建好的颜色为上下文设置颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f].CGColor);
    //设置阴影
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    //???猜测：保存了上下文设置的状态???
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, x_rect-size_3d, 0);
    CGContextAddLineToPoint(context, x_rect-size_3d*2, size_3d);
    CGContextAddLineToPoint(context, x_rect, size_3d);
    
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

- (void) drawRectangle{
    //获得当前view的图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //制定了线的宽度
    CGContextSetLineWidth(context, 2.0);
    //使用刚才创建好的颜色为上下文设置颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:73/255.0f green:158/255.0f blue:247/255.0f alpha:1.0f].CGColor);
    //设置阴影
    //CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    //???猜测：保存了上下文设置的状态???
    CGContextSaveGState(context);
    

    CGContextMoveToPoint(context, 0, y_rect-size_3d);
    CGContextAddLineToPoint(context, 0, table_corner_size);
    CGContextAddLineToPoint(context, table_corner_size, 0);
    CGContextAddLineToPoint(context, x_rect-size_3d, 0);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

- (void) drawCorner_test{
    //获得当前view的图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //制定了线的宽度
    CGContextSetLineWidth(context, 1.0);
    //使用刚才创建好的颜色为上下文设置颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f].CGColor);
    //设置阴影
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    //???猜测：保存了上下文设置的状态???
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, x_rect-size_3d, 0);
    CGContextAddEllipseInRect(context, CGRectMake(10, 10, 10, 10));
    //CGContextAddLineToPoint(context, x_rect, size_3d);
    
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}


@end
