//
//  SegmentModeControl.m
//  SlidingTabs
//
//  Created by 李 瑞 on 13-1-4.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import "SegmentControl.h"
#import "SingletonYouku.h"


@implementation SegmentControl

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame tabName:(NSArray<NSObject> *)modeName delegate:(NSObject<SegmentControlDelegate> *)SegmentControlDelegate{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    _delegate = SegmentControlDelegate;
    //self.frame = CGRectMake(0, 0, 320, 40);
    //self.backgroundColor = [UIColor clearColor];
    
    int segCount = [modeName count];
    _button = [[NSMutableArray alloc] initWithCapacity:segCount];
    
    NSLog(@"initWithtabName:%@   modeName.count:%d\n", [modeName objectAtIndex:0], segCount);
    
    UISegmentedControl *modeSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    modeSegment.segmentedControlStyle = UISegmentedControlStylePlain;
    modeSegment.tintColor = [UIColor clearColor];
    for (NSUInteger i = 0; i < segCount; i++){
        [modeSegment insertSegmentWithTitle:[modeName objectAtIndex:i] atIndex:i animated:YES];
    }
    modeSegment.selectedSegmentIndex = 0;
    [modeSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:modeSegment];

    return self;
}

-(void)segmentAction:(UISegmentedControl *)sender
{
    int selectId = [sender selectedSegmentIndex];
    [_delegate segmentValueChange:selectId];
}

@end
    
