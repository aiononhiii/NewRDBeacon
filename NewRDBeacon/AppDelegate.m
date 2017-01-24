//
//  AppDelegate.m
//  NewRDBeacon
//
//  Created by totyu3 on 17/1/24.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "AppDelegate.h"
#import "BGTask.h"
#import<CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    BOOL isCollect;
}
@property (strong, nonatomic) CLLocationManager * LocationManager;
@property (nonatomic, strong) NSMutableDictionary *BeaconInfo;
@property (strong, nonatomic) CLBeaconRegion *SelectBeacon;//被扫描的iBeacon
@property (nonatomic, strong) NSMutableArray *updateBeaconArray;
@property (nonatomic, strong) NSArray *BeaconArray;
@property (nonatomic, strong) NSDictionary *currentBeaconDic;
@property (strong , nonatomic) BGTask *bgTask; //后台任务
@end

@implementation AppDelegate

+(CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.activityType = CLActivityTypeFitness;
    });
    return _locationManager;
}

-(instancetype)init
{
    if(self == [super init])
    {
        _bgTask = [BGTask shareBGTask];
        isCollect = NO;
        [self applicationEnterBackground];
    }
    return self;
}

-(NSMutableArray *)updateBeaconArray{
    
    if (!_updateBeaconArray) {
        _updateBeaconArray = [NSMutableArray array];
    }
    return _updateBeaconArray;
}

-(NSArray *)BeaconArray{
    
    if (!_BeaconArray) {
        _BeaconArray = [NSArray array];
    }
    return _BeaconArray;
}

-(NSDictionary *)currentBeaconDic{
    
    if (!_currentBeaconDic) {
        _currentBeaconDic = [NSDictionary dictionary];
    }
    return _currentBeaconDic;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.LocationManager = [[CLLocationManager alloc] init];//初始化
    
    self.LocationManager.delegate = self;
    
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(updateBeaconDataList)
                                   userInfo:nil
                                    repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:600.0
                                     target:self
                                   selector:@selector(updateSBSeverBeaconList)
                                   userInfo:nil
                                    repeats:YES];
    
    [self GetBeaconInfo];
    
    //位置を取得し始める
    [self startLocation];
    return YES;
}

-(void)updateBeaconDataList {
    

    NSLog(@"%@",self.BeaconArray);
    NSString *identifierForVendor=[[[UIDevice currentDevice] identifierForVendor]UUIDString];
    for (CLBeacon *beacon in self.BeaconArray){
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *time = [fmt stringFromDate:[NSDate date]];
        NSString* Acc  =[NSString stringWithFormat:@"%.2f",beacon.accuracy];
        NSString* Rssi  =[NSString stringWithFormat:@"%ld",(long)beacon.rssi ];
        
        self.currentBeaconDic = @{@"useruuid":identifierForVendor,@"uuid":beacon.proximityUUID.UUIDString,@"major":beacon.major.stringValue,@"minor":beacon.minor.stringValue,@"updatedate":time,@"acc":Acc,@"rssi":Rssi};
        
        [self.updateBeaconArray addObject:self.currentBeaconDic];
    }
}

-(void)updateSBSeverBeaconList{
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:[self ArrayToJson:self.updateBeaconArray] forKey:@"updatedata"];
    [[SealAFNetworking NIT] PostWithUrl:Rdupdatedata parameters:parameter mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = success;
        if ([[tmpDic valueForKey:@"code"]isEqualToString:@"200"]) {
            [self.updateBeaconArray removeAllObjects];
        }
        NSLog(@"返回数组%@",[tmpDic valueForKey:@"aaa"]);
    }defeats:^(NSError *defeats){
    }];
}

/**
 *  数组转json
 */
-(NSString*)ArrayToJson:(NSMutableArray*)array{
    
    NSMutableArray *scenariodtlinfo = [NSMutableArray arrayWithArray:array];
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:scenariodtlinfo
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    NSString *jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    return jsonstr;
}

-(void)GetBeaconInfo{
//    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [[SealAFNetworking NIT] PostWithUrl:GetBeaconInfo parameters:nil mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = success;
        self.BeaconInfo = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        [self initCLBeaconRegion];
    }defeats:^(NSError *defeats){
    }];
}

-(void)initCLBeaconRegion{
    
    NSArray *beacons = [self.BeaconInfo allKeys];
    for(int i = 0 ; i < beacons.count; i++){
        NSString *name = beacons[i];
        NSString *uuid = [[self.BeaconInfo objectForKey:name] objectForKey:@"uuid"];
        self.SelectBeacon = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] identifier:@"rdbeacon"];
        [self.LocationManager startMonitoringForRegion:self.SelectBeacon];
        [self.LocationManager startRangingBeaconsInRegion:self.SelectBeacon];
        [self.LocationManager requestStateForRegion:self.SelectBeacon];
    }
}

#pragma mark - CLLocationManager Delegate

-(void)applicationEnterBackground
{
    CLLocationManager *locationManager = [AppDelegate shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_bgTask beginNewBackgroundTask];
}

//开启服务
- (void)startLocation {
    NSLog(@"开启定位");
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
        } else {
            CLLocationManager *locationManager = [AppDelegate shareBGLocation];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

//重启定位服务
-(void)restartLocation
{
    CLLocationManager *locationManager = [AppDelegate shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.bgTask beginNewBackgroundTask];
}
//停止后台定位
-(void)stopLocation
{
    isCollect = NO;
    CLLocationManager *locationManager = [AppDelegate shareBGLocation];
    [locationManager stopUpdatingLocation];
}
#pragma mark --delegate
//定位回调里执行重启定位和关闭定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
   
    //如果正在10秒定时收集的时间，不需要执行延时开启和关闭定位
    if (isCollect) {
        return;
    }
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:140];
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:10];
    isCollect = YES;//标记正在定位
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"DidPauseLocationUpdates");
}
-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"DidResumeLocationUpdates");
}

/**
 允许一直在后台运行
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.LocationManager startMonitoringForRegion:self.SelectBeacon];
    }
}

//找的iBeacon后扫描它的信息

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{

    [self.delegate BeaconSelect:beacons];
    
    self.BeaconArray = beacons;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
