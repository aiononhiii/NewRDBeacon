//
//  FishTabButtonPagerController.m
//  鱼大师
//
//  Created by totyu3 on 16/9/29.
//  Copyright © 2016年 LGF. All rights reserved.
//
#define fishcolor NITColor(20,221,140)

#import "FishTabButtonPagerController.h"

@interface FishTabButtonPagerController ()
@property (nonatomic, assign) CGFloat selectFontScale;
@end

#define kUnderLineViewHeight 3

@implementation FishTabButtonPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureTabButtonPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configureTabButtonPropertys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.delegate) {
        self.delegate = self;
    }
    
    if (!self.dataSource) {
        self.dataSource = self;
    }
    _selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    
    [self configureSubViews];
}

- (void)configureSubViews
{
    // progress
    self.progressView.backgroundColor = _progressColor;
    self.progressView.layer.cornerRadius = _progressRadius;
    self.progressView.layer.masksToBounds = YES;
    
    // tabBar
    self.pagerBarView.backgroundColor = _pagerBarColor;
    self.collectionViewBar.backgroundColor = _collectionViewBarColor;
}

- (void)configureTabButtonPropertys
{
    self.cellSpacing = 2;
    self.cellEdging = 3;
    
    self.barStyle = TYPagerBarStyleProgressView;
    
    _normalTextColor = [UIColor lightGrayColor];
    _selectedTextColor = fishcolor;
    
    _pagerBarColor = [UIColor whiteColor];
    _collectionViewBarColor = [UIColor clearColor];
    
    _progressColor = [UIColor whiteColor];
    _progressRadius = self.progressHeight/2;
    
    [self registerCellClass:[FishTabTitleViewCell class] isContainXib:NO];
}

- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    [super setBarStyle:barStyle];
    
    switch (barStyle) {
        case TYPagerBarStyleProgressView:
            self.progressWidth = 0;
            self.progressHeight = kUnderLineViewHeight;
            self.progressEdging = 3;
            break;
        case TYPagerBarStyleProgressBounceView:
        case TYPagerBarStyleProgressElasticView:
            self.progressHeight = kUnderLineViewHeight;
            self.progressWidth = 30;
            break;
        case TYPagerBarStyleCoverView:
            self.progressWidth = 0;
            self.progressHeight = self.contentTopEdging-8;
            self.progressEdging = -self.progressHeight/4;
            break;
        default:
            break;
    }
    
    if (barStyle == TYPagerBarStyleCoverView) {
        self.progressColor = [UIColor lightGrayColor];
    }else {
        self.progressColor = fishcolor;
    }
    self.progressRadius = self.progressHeight/2;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressView.backgroundColor = progressColor;
}

- (void)setPagerBarColor:(UIColor *)pagerBarColor
{
    _pagerBarColor = pagerBarColor;
    self.pagerBarView.backgroundColor = pagerBarColor;
}

- (void)setCollectionViewBarColor:(UIColor *)collectionViewBarColor
{
    _collectionViewBarColor = collectionViewBarColor;
    self.collectionViewBar.backgroundColor = collectionViewBarColor;
}

#pragma mark - private

- (void)transitionFromCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)toCell
{
    if (fromCell) {
        fromCell.titleLabel.textColor = self.normalTextColor;
        fromCell.transform = CGAffineTransformMakeScale(self.selectFontScale, self.selectFontScale);
    }
    
    if (toCell) {
        toCell.titleLabel.textColor = self.selectedTextColor;
        toCell.transform = CGAffineTransformIdentity;
    }
}

- (void)transitionFromCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    CGFloat currentTransform = (1.0 - self.selectFontScale)*progress;
    fromCell.transform = CGAffineTransformMakeScale(1.0-currentTransform, 1.0-currentTransform);
    toCell.transform = CGAffineTransformMakeScale(self.selectFontScale+currentTransform, self.selectFontScale+currentTransform);
    
    CGFloat narR,narG,narB,narA;
    [self.normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR,selG,selB,selA;
    [self.selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    fromCell.titleLabel.textColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    toCell.titleLabel.textColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    NSAssert(NO, @"you must impletement method numberOfControllersInPagerController");
    return 0;
}

- (UIViewController *)pagerController:(FishPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSAssert(NO, @"you must impletement method pagerController:controllerForIndex:");
    return nil;
}

#pragma mark - TYTabPagerControllerDelegate

- (void)pagerController:(FishTabPagerController *)pagerController configreCell:(FishTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    FishTabTitleViewCell *titleCell = (FishTabTitleViewCell *)cell;
    titleCell.titleLabel.text = title;
    titleCell.titleLabel.font = self.selectedTextFont;
}

- (void)pagerController:(FishTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)toCell animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self transitionFromCell:(FishTabTitleViewCell *)fromCell toCell:(FishTabTitleViewCell *)toCell];
        }];
    }else{
        [self transitionFromCell:fromCell toCell:toCell];
    }
}

- (void)pagerController:(FishTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<FishTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    [self transitionFromCell:fromCell toCell:toCell progress:progress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
