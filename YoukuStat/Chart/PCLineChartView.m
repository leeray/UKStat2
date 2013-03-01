#define HORIZ_SWIPE_DRAG_MIN 12
#define VERT_SWIPE_DRAG_MAX 8

#import "PCLineChartView.h"
#import "PCLineChartViewComponent.h"
#import <QuartzCore/QuartzCore.h>

@interface Y_Point : NSObject
{
    float y1;
    float y2;
    float y3;
}
@end

@interface X_Point : NSObject
{
    float x1;
}
@end

@interface PCLineChartView () {
    NSMutableArray *point_y_array;
    NSMutableArray *point_x_array;
    NSMutableArray *x_point_array;
    NSMutableDictionary *x_y_point;
    int x_ypoint;
    int touch_x;
    
    //每条线文字上的按钮，点击可以影藏线。 其实就是重画一下
    NSMutableArray* _buttons;
    //定义每条线的状态， -1：隐藏   !=-1或者空， 就正藏
    NSMutableDictionary *_LineState;
    
    //浮动显示的view  和 label 列表
    NSMutableArray* _labels;
    NSMutableArray* _labelviews;
}
@end

@implementation PCLineChartView
@synthesize components;
@synthesize interval, minValue, maxValue;
@synthesize xLabels;
@synthesize yLabelFont, xLabelFont, valueLabelFont, legendFont;
@synthesize autoscaleYAxis, numYIntervals;
@synthesize numXIntervals;
@synthesize datalist;

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
		legendFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:12] ;
        _LineState = [NSMutableDictionary dictionary];
        
        allView = [[UIView alloc]init];
        allView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        allView.layer.cornerRadius = 10;
        allView.layer.masksToBounds = YES;
        outView.layer.borderWidth = 1;
        outView = [[UIView alloc]init];
        outView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        outView.layer.cornerRadius = 10;
        outView.layer.masksToBounds = YES;
        outView.layer.borderWidth = 1;
        dateView = [[UIView alloc]init];
        dateView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        dateView.layer.cornerRadius = 10;
        dateView.layer.masksToBounds = YES;
        dateView.layer.borderWidth = 1;
        inView = [[UIView alloc]init];
        inView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        inView.layer.cornerRadius = 10;
        inView.layer.masksToBounds = YES;
        inView.layer.borderWidth = 1;
		
    }
    return self;
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

- (void) drawRect:(CGRect)rect{
    _buttons = [NSMutableArray array];
    [self initWithNN:rect];
}

- (void) initWithNN:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    //文字颜色
    CGContextSetRGBFillColor(ctx, 0.2f, 0.2f, 0.2f, 1.0f);
    
    int n_div;
    int power;
    float scale_min, scale_max, div_height;
    //顶部高度
    top_margin = 30;
    //底部高度
    bottom_margin = 30;
    //x轴高度
	float x_label_height = 1;
	
    if (autoscaleYAxis) {
        scale_min = 0.0;
        power = floor(log10(maxValue/5));
        
        //y轴 1个单位大小
        float increment = maxValue / (5 * pow(10,power));
        
        increment = (increment <= 5) ? ceil(increment) : increment;
        //increment = (increment <= 5) ? ceil(increment) : 10;
        //NSLog(@"increment:%f", increment);
        increment = increment * pow(10,power);
        //NSLog(@"increment:%f", increment);
        scale_max = 5 * increment;
        //NSLog(@"scale_max:%f", scale_max);
        self.interval = scale_max / numYIntervals;
        //NSLog(@"interval:%f", interval);
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
        //NSString *formatString = [NSString stringWithFormat:@"%%.%if", (power < 0) ? -power : 0];
        NSString *text = simple_y_axis;

        [text drawInRect:textFrame
				withFont:yLabelFont
		   lineBreakMode:UILineBreakModeMiddleTruncation
			   alignment:UITextAlignmentRight];
		
		// These are "grid" lines
        if (y_axis == 0){
            //画x轴线
            CGContextSetLineWidth(ctx, 2);
            CGContextSetRGBStrokeColor(ctx, 1.0/255, 1.0/255, 1.0/255, 0.5);
            CGContextMoveToPoint(ctx, 40, y);
            CGContextAddLineToPoint(ctx, rect.size.width-5, y);
            CGContextAddLineToPoint(ctx, rect.size.width-5-5, y+5);
            x_ypoint = y;
        }else{
            CGContextSetLineWidth(ctx, 0.3);
            CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.4f);
            CGContextMoveToPoint(ctx, 40, y);
            CGContextAddLineToPoint(ctx, rect.size.width-10, y);
        }

        CGContextStrokePath(ctx);
    }
    
    //画y轴线
    int top_y = top_margin+div_height*numYIntervals;
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 1.0/255, 1.0/255, 1.0/255, 0.5);
    CGContextMoveToPoint(ctx, 40, top_y);
    CGContextAddLineToPoint(ctx, 40, top_margin-10);
    CGContextAddLineToPoint(ctx, 40-5, top_margin-10+10);
    CGContextStrokePath(ctx);
    
    ////这里画X轴上的文字
    CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.4f);
    float margin = 45;
    //float right_margin = 10;
    float div_width = (self.frame.size.width-50)/([self.xLabels count]-1);

    for (NSUInteger i=0; i<[self.xLabels count]; i++)
    {
        if (i % numXIntervals == 1 || numXIntervals==1) {
            int x = (int) (margin + div_width * i);
            NSString *x_label = [NSString stringWithFormat:@"%@", [self.xLabels objectAtIndex:i]];
    
            CGContextSetTextMatrix(ctx, CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, -1.0), 45*M_PI/180));
            CGContextSelectFont(ctx, "Helvetica", 7, kCGEncodingMacRoman);
            CGContextShowTextAtPoint(ctx, x-15, self.frame.size.height - x_label_height, [x_label UTF8String], strlen([x_label UTF8String]));
        };
        
    }
    
	CGColorRef shadowColor = [[UIColor lightGrayColor] CGColor];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,-1), 1, shadowColor);
	

    x_point_array = [NSMutableArray array];
    x_y_point = [NSMutableDictionary dictionary];
    
    //这个记录每条曲线的最后一点的坐标、标题信息 用来画最后的坐标标题在最后面
    NSMutableArray *legends = [NSMutableArray array];
    
    //圆圈大小
    float circle_diameter = 1;
    
    //圆圈线条宽度
    float circle_stroke_width = 0.8;
    
    //曲线宽度
    float line_width = 0.8;
	
    int lineIndex = 0;
    
    for (PCLineChartViewComponent *component in self.components)
    {
        //判断是否隐藏了线， 如果隐藏，就画下一条
        NSString *key = [NSString stringWithFormat:@"%d", lineIndex];
        id lineState = [_LineState objectForKey:key];
        if (lineState!=NULL){
            int state = [lineState intValue];
            if (state==-1) {
                lineIndex++;
                continue;
            }
        }
        lineIndex++;
        
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
                
                NSMutableArray *y_array = [x_y_point objectForKey:[NSString stringWithFormat:@"%d", x]];
                if (y_array == NULL){
                    y_array = [NSMutableArray array];
                }
                NSMutableDictionary *cur_info = [NSMutableDictionary dictionary];
                [cur_info setObject:component.colour forKey:@"colour"];
                [cur_info setObject:component.title forKey:@"title"];
                [cur_info setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
                [cur_info setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
                [cur_info setObject:[NSString stringWithFormat:@"%@",object ] forKey:@"y_value"];
                
                //[y_array addObject:[NSNumber numberWithFloat:y]];
                [y_array addObject:cur_info];
                [x_y_point setObject:y_array forKey:[NSString stringWithFormat:@"%d", x]];
                if ([x_point_array containsObject:[NSNumber numberWithFloat:x]] == NO) {
                    [x_point_array addObject:[NSNumber numberWithFloat:x]];
                }
                
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
	
    int x_linename_count = [self.components count];
    
    //int y_bottom = rect.size.height-15;
    int y_bottom = 5;
    int x_line_name = (self.frame.size.width - x_linename_count*70)/2;
    
    //CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextSetLineWidth(ctx, 0.1);
    shadowColor = [[UIColor clearColor] CGColor];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,-1), 1, shadowColor);

    lineIndex = 0;
    for (PCLineChartViewComponent *component in self.components)
    {
        UIColor *colour = [component colour];
		        
        //判断是否隐藏了线， 如果隐藏，就把颜色置黑
        NSString *key = [NSString stringWithFormat:@"%d", lineIndex];
        id lineState = [_LineState objectForKey:key];
        if (lineState!=NULL){
            int state = [lineState intValue];
            if (state==-1) {
                colour = [UIColor darkGrayColor];
            }
        }
        lineIndex++;
		
        
        CGContextSetFillColorWithColor(ctx, [colour CGColor]);


        NSString *title = [component title];

        UILabel *titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(x_line_name, y_bottom, 70, 25)];
        titlLabel.text = title;
        titlLabel.font = legendFont;
        titlLabel.textColor = colour;
        titlLabel.textAlignment = UITextAlignmentCenter;
        [titlLabel sendSubviewToBack:self];
        [self addSubview:titlLabel];
        
        UIButton *okBut = [[UIButton alloc]initWithFrame:CGRectMake(x_line_name, y_bottom, 70, 25)];
        [okBut addTarget:self action:@selector(hideLine:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:okBut];
        [self addSubview:okBut];
        
        x_line_name = x_line_name + 70;

    }
    
    if (touch_x != 0) {
        CGContextSetLineWidth(ctx, 0.2);
        float lengths[] = {6,2,6};
        CGContextSetLineDash(ctx, 0, lengths, 2);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextMoveToPoint(ctx, touch_x, 0+10);
        CGContextAddLineToPoint(ctx, touch_x, x_ypoint);
        CGContextStrokePath(ctx);
        
    }
    
        
}

- (void)hideLine:(UIButton*)button{
    int buttonIndex = [_buttons indexOfObject:button];
    
    NSString *key = [NSString stringWithFormat:@"%d", buttonIndex];
    
    id lineState = [_LineState objectForKey:key];
    if (lineState!=NULL){
        int state = [lineState intValue];
        if (state==-1) {
            [_LineState setObject:[NSNumber numberWithInt:0] forKey:key];
        }else{
            [_LineState setObject:[NSNumber numberWithInt:-1] forKey:key];
        }
    }else{
        [_LineState setObject:[NSNumber numberWithInt:-1] forKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (datalist == NULL || datalist.count <=0){
        return;
    }
    
    if (x_point_array == NULL || [x_point_array count] == 0) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    if ([touch view] != self) {
        return;
    }
    
    startTouchPosition = [touch locationInView:self];

    float div_width=(self.frame.size.width-40)/([self.xLabels count]-1);

    float c_x = startTouchPosition.x;
    float c_y = startTouchPosition.y;
    
    _labels = [NSMutableArray array];
    _labelviews = [NSMutableArray array];
    
    if (c_x > 40 && c_x <= 300 && c_y < (self.frame.size.height) && c_y > top_margin){
        float x_label = c_x - 60;
        float y_label = c_y - 160;
        if (x_label < 0) {
            x_label = 0;
        }
        if (x_label >= 180){
            x_label = 180;
        }
        if (y_label < 0){
            y_label = 0;
        }
        
        int x_point = (c_x - 40)/div_width;
        if (x_point >= datalist.count){
            x_point = datalist.count;
        }
        
        
        //取得x坐标轴的值
        NSNumber *x_p = [x_point_array objectAtIndex:x_point];
        //通过x轴的值取得三个y周值
        NSMutableArray *y_array = [x_y_point objectForKey:[NSString stringWithFormat:@"%@", x_p]];
        //随便取个y轴值, 画条线, cao
        //float y_1 = [[y_array objectAtIndex:0] floatValue];
        //float y_2 = [[y_array objectAtIndex:1] floatValue];
        //float y_3 = [[y_array objectAtIndex:2] floatValue];
        
        for (int i = 0; i<[y_array count]; i++) {
            NSMutableDictionary *dic_point = [y_array objectAtIndex:i];
            float y_po = [[dic_point objectForKey:@"y"] floatValue];
            NSString *text = [NSString stringWithFormat:@"%@:%@",[dic_point objectForKey:@"title"], [dic_point objectForKey:@"y_value"] ];
            
            UIView *fudong_View = [[UIView alloc]initWithFrame:CGRectMake(x_label, y_po, 120, 20)];
            fudong_View.backgroundColor = [dic_point objectForKey:@"colour"];
            fudong_View.layer.cornerRadius = 5;
            fudong_View.layer.masksToBounds = YES;
            fudong_View.layer.borderWidth = 1;
            fudong_View.layer.borderColor = [(UIColor*)[dic_point objectForKey:@"colour"] CGColor];
            
            UILabel *fudong_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 120, 20.0)];
            fudong_label.backgroundColor = [UIColor clearColor];
            fudong_label.text = text;
            fudong_label.font = [UIFont fontWithName:@"Arial" size:11.0];
            fudong_label.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
            
            [fudong_View addSubview:fudong_label];
            
            [_labels addObject:fudong_label];
            [_labelviews addObject:fudong_View];
            

            [self addSubview:fudong_View];
            
        }
        //NSLog(@"划线  (x:%f   y:%f)  --->   (x:%f   y:%f)", [x_p floatValue], 0.0, [x_p floatValue], self.frame.size.height-50);
        
        touch_x = [x_p floatValue];
        [self setNeedsDisplay];

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (datalist == NULL || datalist.count <=0){
        return;
    }

    if (x_point_array == NULL || [x_point_array count] == 0) {
        return;
    }
    
    if (_labelviews == NULL || [_labelviews count] == 0) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    float c_x = currentTouchPosition.x;
    float c_y = currentTouchPosition.y;
    float div_width=(self.frame.size.width-40)/([self.xLabels count]-1);
    
    
    if (c_x > 40 && c_x <= 300 && c_y < (self.frame.size.height) && c_y > top_margin){
        float x_label = c_x - 60;
        float y_label = c_y - 160;
        if (x_label < 0) {
            x_label = 0;
        }
        if (x_label >= 180){
            x_label = 180;
        }
        if (y_label < 0){
            y_label = 0;
        }
        

        int x_point = (currentTouchPosition.x - 40)/div_width;
        if( x_point < 0){
            x_point = 0;
        }else if (x_point > datalist.count){
            x_point = datalist.count;
        }

        //取得x坐标轴的值
        NSNumber *x_p = [x_point_array objectAtIndex:x_point];
        //通过x轴的值取得三个y周值
        NSMutableArray *y_array = [x_y_point objectForKey:[NSString stringWithFormat:@"%@", x_p]];
        //随便取个y轴值, 画条线, cao
        //float y_1 = [[y_array objectAtIndex:0] floatValue];
        //float y_2 = [[y_array objectAtIndex:1] floatValue];
        //float y_3 = [[y_array objectAtIndex:2] floatValue];
        
        for (int i = 0; i<[y_array count]; i++) {
            NSMutableDictionary *dic_point = [y_array objectAtIndex:i];
            float y_po = [[dic_point objectForKey:@"y"] floatValue];
            NSString *text = [NSString stringWithFormat:@"%@:%@",[dic_point objectForKey:@"title"], [dic_point objectForKey:@"y_value"] ];
            
            

            UIView *old_view = [_labelviews objectAtIndex:i];
            old_view.frame = CGRectMake(x_label, y_po, 120, 20);
            UILabel *old_label = [_labels objectAtIndex:i];
            old_label.text = text;


        }

        //NSLog(@"划线  (x:%f   y:%f)  --->   (x:%f   y:%f)", [x_p floatValue], 0.0, [x_p floatValue], self.frame.size.height-50);
        
        touch_x = [x_p floatValue];
        [self setNeedsDisplay];
        
    } else {
        touch_x = 0;
        [self setNeedsDisplay];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    for (int i = 0; i<[_labelviews count]; i++){
        UIView *old_view = [_labelviews objectAtIndex:i];
        old_view.alpha = 1.0f;
        old_view.alpha = 0.0f;
    }
    for (int i = 0; i<[_labels count]; i++){
        UILabel *old_label = [_labels objectAtIndex:i];
        old_label.alpha = 1.0f;
        old_label.alpha = 0.0f;
    }
    
    touch_x = 0;
    [self setNeedsDisplay];
    [UIView commitAnimations];

}

@end
