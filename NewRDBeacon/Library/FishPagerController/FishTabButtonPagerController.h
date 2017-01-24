//
//  FishTabButtonPagerController.h
//  鱼大师
//
//  Created by totyu3 on 16/9/29.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "FishTabPagerController.h"
#import "FishTabTitleViewCell.h"

// register cell conforms to TYTabTitleViewCellProtocol

@interface FishTabButtonPagerController : FishTabPagerController<FishTabPagerControllerDelegate,FishPagerControllerDataSource>

// be carefull!!! the barStyle set style will reset progress propertys, set it (behind [super viewdidload]) or (in init) and set cell property that you want

// pagerBar color
@property (nonatomic, strong) UIColor *pagerBarColor;
@property (nonatomic, strong) UIColor *collectionViewBarColor;

// progress view
@property (nonatomic, assign) CGFloat progressRadius;
@property (nonatomic, strong) UIColor *progressColor;

// text color
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end
