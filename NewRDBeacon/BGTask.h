//
//  BGTask.h
//  locationdemo
//
//  Created by yebaojia on 16/2/24.
//  Copyright © 2016年 mjia. All rights reserved.
//


@interface BGTask : NSObject
+(instancetype)shareBGTask;
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask; //开启后台任务
@end
