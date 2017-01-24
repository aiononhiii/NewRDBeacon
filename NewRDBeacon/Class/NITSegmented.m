//
//  NITSegmented.m
//  DashBoard
//
//  Created by totyu3 on 17/1/19.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NITSegmented.h"

@implementation NITSegmented

-(void)setSegmentedFont:(float)SegmentedFont{
    UIFont *font = [UIFont boldSystemFontOfSize:SegmentedFont];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}

@end
