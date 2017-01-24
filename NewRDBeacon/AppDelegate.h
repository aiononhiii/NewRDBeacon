//
//  AppDelegate.h
//  NewRDBeacon
//
//  Created by totyu3 on 17/1/24.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeaconSelectDelegate <NSObject>
-(void)BeaconSelect:(NSArray*)beaconarray;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) id<BeaconSelectDelegate>delegate;

@end

