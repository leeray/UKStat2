//
//  TableHeaderStyleView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-29.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import "TableHeaderStyleView.h"

@implementation TableHeaderStyleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) juchiFooter{
    //获得当前view的图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //制定了线的宽度
    CGContextSetLineWidth(context, 1.0);
    
    //使用画笔颜色
    //CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:73/255.0f green:132/255.0f blue:196/255.0f alpha:1.0f].CGColor);
    
    //设置阴影
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    
    CGContextSaveGState(context);
    
    CGRect rrect = self.bounds;
    
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    NSLog(@"TableLabelView  width:%f   height:%f", width, height);
    
//    CGContextMoveToPoint(context, size_3d, y_rect);
//    CGContextAddLineToPoint(context, 0, y_rect-size_3d);
//    CGContextAddLineToPoint(context, size_3d, y_rect-size_3d*2);
//    CGContextDrawPath(context, kCGPathFill);
//    CGContextRestoreGState(context);
}

@end
