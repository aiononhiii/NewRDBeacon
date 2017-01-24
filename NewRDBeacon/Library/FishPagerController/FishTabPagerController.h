//
//  FishTabPagerController.h
//  鱼大师
//
//  Created by totyu3 on 16/9/29.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "FishPagerController.h"

@class FishTabPagerController;

@protocol FishTabPagerControllerDelegate <FishPagerControllerDelegate>

@optional
// configre collectionview cell
- (void)pagerController:(FishTabPagerController *)pagerController configreCell:(UICollectionViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath;

// did select indexPath
- (void)pagerController:(FishTabPagerController *)pagerController didSelectAtIndexPath:(NSIndexPath *)indexPath;

// did scroll to page index
- (void)pagerController:(FishTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index;

// transition frome cell to cell with animated
- (void)pagerController:(FishTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell animated:(BOOL)animated;

// transition frome cell to cell with progress
- (void)pagerController:(FishTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell progress:(CGFloat)progress;

@end

typedef NS_ENUM(NSUInteger, TYPagerBarStyle) {
    TYPagerBarStyleNoneView,
    TYPagerBarStyleProgressView,
    TYPagerBarStyleProgressBounceView,
    TYPagerBarStyleProgressElasticView,
    TYPagerBarStyleCoverView
};

@interface FishTabPagerController : FishPagerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-property-synthesis"
@property (nonatomic, weak) id<FishTabPagerControllerDelegate> delegate;
#pragma clang diagnostic pop

// view ,don't change frame
@property (nonatomic, weak, readonly) UIView *pagerBarView; // pagerBarView height is contentTopEdging
@property (nonatomic, weak, readonly) UIImageView *pagerBarImageView;
@property (nonatomic, weak, readonly) UICollectionView *collectionViewBar;
@property (nonatomic, weak, readonly) UIView *progressView;

@property (nonatomic, assign) TYPagerBarStyle barStyle; // you can set or ovrride barStyle

@property (nonatomic, assign) CGFloat collectionLayoutEdging; // collectionLayout left right edging

// progress view
@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, assign) CGFloat progressWidth; //if>0 progress width is equal,else progress width is cell width
@property (nonatomic, assign) CGFloat progressEdging; // if < 0 width + edge ,if >0 width - edge
@property (nonatomic, assign) CGFloat progressBottomEdging; // if < 0 width + edge ,if >0 width - edge

// cell
@property (nonatomic, assign) CGFloat cellWidth; // if>0 cells width is equal,else if=0 cell will caculate all titles width
@property (nonatomic, assign) CGFloat cellSpacing; // cell space
@property (nonatomic, assign) CGFloat cellEdging;  // cell left right edge

//   animate duration
@property (nonatomic, assign) CGFloat animateDuration;

// text font
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *selectedTextFont;

// if you custom cell ,you must register cell
- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib;

@end