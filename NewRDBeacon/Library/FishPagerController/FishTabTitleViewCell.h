//
//  FishTabTitleViewCell.h
//  鱼大师
//
//  Created by totyu3 on 16/9/29.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishTabTitleCellProtocol.h"

@interface FishTabTitleViewCell : UICollectionViewCell<FishTabTitleCellProtocol>
@property (nonatomic, weak,readonly) UILabel *titleLabel;
@end