//
//  NITLabel.m
//  DashBoard
//
//  Created by totyu3 on 17/1/22.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NITLabel.h"

@implementation NITLabel
//竖排文字
- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}

@end
