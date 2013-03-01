//
//  SegmentModeControl.h
//  SlidingTabs
//
//  Created by 李 瑞 on 13-1-4.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentControl;

@protocol SegmentControlDelegate;

@interface SegmentControl : UIView{
    NSObject <SegmentControlDelegate> *_delegate;
    NSMutableArray* _button;
}

- (id)initWithFrame:(CGRect)frame tabName:(NSArray<NSObject> *)modeName delegate:(NSObject<SegmentControlDelegate> *)SegmentControlDelegate;

-(void)segmentAction:(id) sender;

@end

@protocol SegmentControlDelegate
- (void) segmentValueChange:(NSUInteger)tabIndex;
@end
