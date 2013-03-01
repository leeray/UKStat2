//
//  TableLabelView.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-19.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableLabelView : UIView

@property (nonatomic, assign) int x_rect;
@property (nonatomic, assign) int y_rect;
@property (nonatomic, assign) int table_corner_size;
@property (nonatomic, assign) int size_3d;
@property (nonatomic, assign) NSString *showinfo;

- (void) initLabelView;

- (id) initWithFrame:(CGRect)frame x_rect:(int)x_rect1 y_rect:(int)y_rect1 table_corner_size:(int)table_corner_size1 size_3d:(int)size_3d1 showInfo:(NSString *)info;

@end
