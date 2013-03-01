//
//  TestTouchView.m
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-24.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "TestTouchView.h"
#import "PCLineChartView.h"
#import "PCLineChartViewComponent.h"

@implementation TestTouchView
@synthesize components;
@synthesize interval, minValue, maxValue;
@synthesize xLabels;
@synthesize yLabelFont, xLabelFont, valueLabelFont, legendFont;
@synthesize autoscaleYAxis, numYIntervals;
@synthesize numXIntervals;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        interval = 20;
		maxValue = 100;
		minValue = 0;
        numYIntervals = 5;
        numXIntervals = 1;
		yLabelFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:8] ;
		xLabelFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:8] ;
		valueLabelFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:8] ;
		legendFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:8] ;
		
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    
}

//得到简写的数字。 例如： 1000=1k
- (NSString *) getSimpleDigs:(int) digs{
    NSString *simple_digs;
    NSString *digsStr = [NSString stringWithFormat:@"%d", digs];
    int length_digs = [digsStr length];
    if (length_digs >= 4 && length_digs <= 6){
        int head = digs / 1000;
        simple_digs = [NSString stringWithFormat:@"%dK", head];
    }else if(length_digs >= 7 && length_digs <= 9){
        int head = digs / 1000000;
        simple_digs = [NSString stringWithFormat:@"%dM", head];
    }else if(length_digs >= 10 && length_digs <= 20){
        int head = digs / 1000000000;
        simple_digs = [NSString stringWithFormat:@"%dMB", head];
    }else {
        simple_digs = [NSString stringWithFormat:@"%d", digs];
    }
    return simple_digs;
}

- (void) initWithNN:(CGRect)rect{
    NSLog(@"TestTouchView.initWithNN(). width:%f height:%f", rect.size.width, rect.size.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    //文字颜色
    CGContextSetRGBFillColor(ctx, 0.2f, 0.2f, 0.2f, 1.0f);
    
    int n_div;
    int power;
    float scale_min, scale_max, div_height;
    //顶部高度
    float top_margin = 30;
    //底部高度
    float bottom_margin = 30;
    //x轴高度
	float x_label_height = 1;
	
    if (autoscaleYAxis) {
        scale_min = 0.0;
        power = floor(log10(maxValue/5));
        
        NSLog(@"power:%d", power);
        
        //y轴 1个单位大小
        float increment = maxValue / (5 * pow(10,power));
        
        NSLog(@"increment:%f", increment);
        
        increment = (increment <= 5) ? ceil(increment) : increment;
        //increment = (increment <= 5) ? ceil(increment) : 10;
        NSLog(@"increment:%f", increment);
        increment = increment * pow(10,power);
        NSLog(@"increment:%f", increment);
        scale_max = 5 * increment;
        NSLog(@"scale_max:%f", scale_max);
        self.interval = scale_max / numYIntervals;
        NSLog(@"interval:%f", interval);
    } else {
        scale_min = minValue;
        scale_max = maxValue; //y轴最大
    }
    
    //Y周每行相隔的大小
    n_div = (scale_max-scale_min)/self.interval + 1;
    
    div_height = (self.frame.size.height-top_margin-bottom_margin-x_label_height)/(n_div-1);
    
    //这里画X轴和Y轴。 包含Y轴上的文字
    for (int i=0; i<n_div; i++)
    {
        float y_axis = scale_max - i*self.interval;
        
        NSString *simple_y_axis = [self getSimpleDigs:y_axis];
		
        y_axis = [simple_y_axis doubleValue];
        
        int y = top_margin + div_height*i;
        CGRect textFrame = CGRectMake(0,y-8,35,20);
        NSString *formatString = [NSString stringWithFormat:@"%%.%if", (power < 0) ? -power : 0];
        NSString *text = simple_y_axis;
        //NSString *text = [NSString stringWithFormat:formatString, y_axis];
        NSLog(@"formatString:%@   y_axis:%f   text:%@   power:%d", formatString, y_axis, text, power);
        [text drawInRect:textFrame
				withFont:yLabelFont
		   lineBreakMode:UILineBreakModeMiddleTruncation
			   alignment:UITextAlignmentRight];
		
		// These are "grid" lines
        if (y_axis == 0){
            //画x轴线
            CGContextSetLineWidth(ctx, 1);
            CGContextSetRGBStrokeColor(ctx, 1.0/255, 1.0/255, 1.0/255, 0.5);
            CGContextMoveToPoint(ctx, 40, y);
            CGContextAddLineToPoint(ctx, rect.size.width-5, y);
            CGContextAddLineToPoint(ctx, rect.size.width-5-5, y+5);
        }else{
            CGContextSetLineWidth(ctx, 0.3);
            CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.4f);
            CGContextMoveToPoint(ctx, 40, y);
            CGContextAddLineToPoint(ctx, rect.size.width-10, y);
        }
        
        NSLog(@"self.frame.size.width:%f", self.frame.size.width);
        CGContextStrokePath(ctx);
    }
    
    //画y轴线
    int top_y = top_margin+div_height*numYIntervals;
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, 1.0/255, 1.0/255, 1.0/255, 0.5);
    CGContextMoveToPoint(ctx, 40, top_y);
    CGContextAddLineToPoint(ctx, 40, top_margin-10);
    CGContextAddLineToPoint(ctx, 40-5, top_margin-10+10);
    CGContextStrokePath(ctx);
    
    ////这里画X轴上的文字
    CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.4f);
    float margin = 45;
    float right_margin = 10;
    float div_width = (self.frame.size.width-50)/([self.xLabels count]-1);
    
    for (NSUInteger i=0; i<[self.xLabels count]; i++)
    {
        if (i % numXIntervals == 1 || numXIntervals==1) {
            int x = (int) (margin + div_width * i);
            NSString *x_label = [NSString stringWithFormat:@"%@", [self.xLabels objectAtIndex:i]];
            
            NSLog(@"x_label frame.x:%d   frame.y:%f  frame.width:%d   frame.height:%f", x-100, self.frame.size.height - x_label_height, 200, x_label_height);
            
            CGContextSetTextMatrix(ctx, CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, -1.0), 45*M_PI/180));
            CGContextSelectFont(ctx, "Helvetica", 7, kCGEncodingMacRoman);
            CGContextShowTextAtPoint(ctx, x-15, self.frame.size.height - x_label_height, [x_label UTF8String], strlen([x_label UTF8String]));
        };
        
    }
    
	CGColorRef shadowColor = [[UIColor lightGrayColor] CGColor];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,-1), 1, shadowColor);
	
    NSMutableArray *legends = [NSMutableArray array];
    
    //圆圈大小
    float circle_diameter = 1;
    
    //圆圈线条宽度
    float circle_stroke_width = 0.8;
    
    //曲线宽度
    float line_width = 0.8;
	
    for (PCLineChartViewComponent *component in self.components)
    {
        int last_x = 0;
        int last_y = 0;
        
        if (!component.colour)
        {
            component.colour = PCColorBlue;
        }
		
		for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
            id object = [component.points objectAtIndex:x_axis_index];
			
			
            if (object!=[NSNull null] && object)
            {
                float value = [object floatValue];
				
				CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
                CGContextSetLineWidth(ctx, circle_stroke_width);
                
                int x = margin + div_width*x_axis_index;
                int y = top_margin + (scale_max-value)/self.interval*div_height;
                
                CGRect circleRect = CGRectMake(x-circle_diameter/2, y-circle_diameter/2, circle_diameter,circle_diameter);
                CGContextStrokeEllipseInRect(ctx, circleRect);
                
				CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                
                if (last_x!=0 && last_y!=0)
                {
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (circle_diameter/2) / distance * (x-last_x);
                    float last_y1 = last_y + (circle_diameter/2) / distance * (y-last_y);
                    float x1 = x - (circle_diameter/2) / distance * (x-last_x);
                    float y1 = y - (circle_diameter/2) / distance * (y-last_y);
                    
                    CGContextSetLineWidth(ctx, line_width);
                    CGContextMoveToPoint(ctx, last_x1, last_y1);
                    CGContextAddLineToPoint(ctx, x1, y1);
                    CGContextStrokePath(ctx);
                }
                
				
                if (x_axis_index==[component.points count]-1)
                {
                    NSMutableDictionary *info = [NSMutableDictionary dictionary];
                    if (component.title)
                    {
                        [info setObject:component.title forKey:@"title"];
                    }
                    [info setObject:[NSNumber numberWithFloat:x+circle_diameter/2+15] forKey:@"x"];
                    [info setObject:[NSNumber numberWithFloat:y-10] forKey:@"y"];
					[info setObject:component.colour forKey:@"colour"];
                    [legends addObject:info];
				}
                
                last_x = x;
                last_y = y;
            }
            
        }
    }
	
    for (int i=0; i<[self.xLabels count]; i++)
    {
        int y_level = top_margin;
		
        for (int j=0; j<[components count]; j++)
        {
			NSArray *items = [[components objectAtIndex:j] points];
            id object = [items objectAtIndex:i];
            if (object!=[NSNull null] && object)
            {
                float value = [object floatValue];
                int x = margin + div_width*i;
                int y = top_margin + (scale_max-value)/self.interval*div_height;
                int y1 = y - circle_diameter/2 - valueLabelFont.pointSize;
                int y2 = y + circle_diameter/2;
                
				if ([[components objectAtIndex:j] shouldLabelValues]) {
					if (y1 > y_level)
					{
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-25,y1, 50,20);
						[perc_label drawInRect:textFrame
									  withFont:valueLabelFont
								 lineBreakMode:UILineBreakModeWordWrap
									 alignment:UITextAlignmentCenter];
						y_level = y1 + 20;
					}
					else if (y2 < y_level+20 && y2 < self.frame.size.height-top_margin-bottom_margin)
					{
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-25,y2, 50,20);
						[perc_label drawInRect:textFrame
									  withFont:valueLabelFont
								 lineBreakMode:UILineBreakModeWordWrap
									 alignment:UITextAlignmentCenter];
						y_level = y2 + 20;
					}
					else
					{
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-50,y-10, 50,20);
						[perc_label drawInRect:textFrame
									  withFont:valueLabelFont
								 lineBreakMode:UILineBreakModeWordWrap
									 alignment:UITextAlignmentCenter];
						y_level = y1 + 20;
					}
                }
                if (y+circle_diameter/2>y_level) y_level = y+circle_diameter/2;
            }
            
        }
    }
    
	NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"y" ascending:YES];
	[legends sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
	
    int x_linename_count = legends.count;
    
    int y_bottom = rect.size.height-15;
    int x_line_name = (self.frame.size.width - x_linename_count*margin)/2;
    
    //CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
    float y_level = 0;
    for (NSMutableDictionary *legend in legends)
    {
		UIColor *colour = [legend objectForKey:@"colour"];
		CGContextSetFillColorWithColor(ctx, [colour CGColor]);
		
        NSString *title = [legend objectForKey:@"title"];
        float x = [[legend objectForKey:@"x"] floatValue];
        float y = [[legend objectForKey:@"y"] floatValue];
        if (y<y_level)
        {
            y = y_level;
        }
        
        //CGRect textFrame = CGRectMake(x,y,margin,15);
        CGRect textFrame = CGRectMake(x_line_name,y_bottom,margin,15);
        [title drawInRect:textFrame withFont:legendFont];
        
        x_line_name = x_line_name + margin;
        y_level = y + 15;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint startTouchPosition = [touch locationInView:self];
    

    
    //float c_x = self.frame.size.width + startTouchPosition.x;
    //float c_y = self.frame.size.height + startTouchPosition.y;
    
    NSLog(@"TestTouchView touchBegan : real_curtent.x:%f   real_.y:%f", startTouchPosition.x, startTouchPosition.y);

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}

@end
