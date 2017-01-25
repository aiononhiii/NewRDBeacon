//
//  BeaconCell.m
//  BeaconSample
//
//  Created by totyu1 on 2015/06/29.
//  Copyright (c) 2015年 totyu1. All rights reserved.
//

#import "BeaconCell.h"

@implementation BeaconCell
-(void)setBgview:(UIView *)bgview{
    _bgview = bgview;
    _bgview.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgview.layer.shadowOpacity = 0.3;
    _bgview.layer.shadowOffset = CGSizeMake(0,0);
}
@end
