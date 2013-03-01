//
//  HeadViewControl.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-2-1.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

@protocol HeadViewControlDelegate;

@interface HeadViewControl : UIView{
    NSArray *headerArray;
    HeadView *headView;
    NSMutableArray *buttons;
    
    NSObject <HeadViewControlDelegate> *delegate;
}
@property (nonatomic, retain) NSArray *headerArray;

- (id)initWithFrame:(CGRect)frame withHeaderArray:(NSArray *)tabnameArray delegate:(NSObject <HeadViewControlDelegate>*)delegate;
- (void)drawWallPaper;
- (void)ScrollViewChanage:(int)index;
@end

@protocol HeadViewControlDelegate

- (void) HeadTitleChange:(int)index;

@end
