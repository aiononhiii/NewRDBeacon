//
//  NITRefreshSet.m
//  Mimamori
//
//  Created by totyu3 on 16/8/17.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NITRefreshInit.h"

@implementation NITRefreshInit
+(MJRefreshNormalHeader *)MJRefreshNormalHeaderInit:(MJRefreshNormalHeader *)header{
    
    if (header) {
        
        // 设置文字
        //プルで更新する
        [header setTitle:@"プルで更新する" forState:MJRefreshStateIdle];
        //放して更新する
        [header setTitle:@"放して更新する" forState:MJRefreshStatePulling];
        //更新中...
        [header setTitle:@"更新中..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置颜色
        header.stateLabel.textColor = NITColor(166, 166, 166);
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 马上进入刷新状态
//        [header beginRefreshing];
        
    }
    
    return header;
}
@end
