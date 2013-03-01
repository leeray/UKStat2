//
//  NSObject_VvDatas.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-14.
//  Copyright (c) 2013年 PHH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VvDatas : NSObject {
    NSString *name;
    NSString *digs;
    NSString *perweek;
    bool isParents;
    NSString *comp;
    NSString *vv;
    NSString *vvper;
    
    NSString *vv_in_sum;
    NSString *vv_out_sum;
    
    NSString *date;
    
    NSString *in_ts_hour;
    NSString *out_ts_hour;
    
    NSString *in_uv;
    NSString *uv_sum;
    
    NSString *all_ts_hour;
    
    NSString *in_play_uv;
    NSString *out_play_uv;
    
    NSString *channel_name;
}


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *digs;
@property (nonatomic, copy) NSString *perweek;
@property (nonatomic, assign) bool isParents;
@property (nonatomic, copy) NSString *comp;
@property (nonatomic, copy) NSString *vv;
@property (nonatomic, copy) NSString *vvper;
@property (nonatomic, copy) NSString *vv_in_sum;
@property (nonatomic, copy) NSString *vv_out_sum;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *in_ts_hour;
@property (nonatomic, copy) NSString *out_ts_hour;
@property (nonatomic, copy) NSString *in_uv;
@property (nonatomic, copy) NSString *uv_sum;
@property (nonatomic, copy) NSString *all_ts_hour;
@property (nonatomic, copy) NSString *in_play_uv;
@property (nonatomic, copy) NSString *out_play_uv;

@property (nonatomic, copy) NSString *channel_name;

@end

@interface ShowDataLabel : NSObject{
    NSString *date;
    NSString *showType;
    NSString *all_num;
    NSString *in_num;
    NSString *out_num;
}
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *all_num;
@property (nonatomic, copy) NSString *in_num;
@property (nonatomic, copy) NSString *out_num;

@end
