//
//  NewBeaconVC.m
//  NewRDBeacon
//
//  Created by totyu3 on 17/1/24.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define DEVICE_UUID @"00000000-609D-1001-B000-001C4DBF2A46"

#import "NewBeaconVC.h"
#import "BeaconCell.h"
#import "AppDelegate.h"
#import<CoreLocation/CoreLocation.h>


@interface NewBeaconVC ()<BeaconSelectDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *NewBeaconCV;

@property (nonatomic, strong) NSArray *BeaconArr;//存放扫描到的iBeacon

@end

@implementation NewBeaconVC

static NSString * const reuseIdentifier = @"NewBeaconCell";

-(NSArray *)BeaconArr{
    if (!_BeaconArr) {
        _BeaconArr = [NSArray array];
    }
    return _BeaconArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)BeaconSelect:(NSArray *)beaconarray{
    self.BeaconArr = beaconarray;
    [_NewBeaconCV reloadData];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.BeaconArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BeaconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSMutableDictionary *dict = [self.BeaconArr objectAtIndex:indexPath.row];
    
    CLBeacon *beacon = [dict objectForKey:@"beacon"];
    NSLog(@"UUID %@",[beacon.proximityUUID UUIDString]);
    NSLog(@"Acc:%.2fm Rssi:%ld",beacon.accuracy,(long)beacon.rssi);
    NSLog(@"beacon.major %@",beacon.major);
    NSLog(@"beacon.minor %@",beacon.minor);
    NSLog(@"beacon.proximity %ld",beacon.proximity);
    

    switch (beacon.proximity) {
        case CLProximityImmediate:
            cell.proximity.text = @"超近";
            [cell.statusImage setImage:[UIImage imageNamed:@"on5"]];
            break;
        case CLProximityNear:
            cell.proximity.text = @"近";
            [cell.statusImage setImage:[UIImage imageNamed:@"on4"]];
            break;
        case CLProximityFar:
            cell.proximity.text = @"远";
            [cell.statusImage setImage:[UIImage imageNamed:@"on3"]];
            break;
        case CLProximityUnknown:
            cell.proximity.text = @"不见了";
            [cell.statusImage setImage:[UIImage imageNamed:@"on1"]];
            break;
        default:
            break;
    }
    cell.locationName.text = [dict objectForKey:@"beaconname"];
    cell.uuidLabel.text = [beacon.proximityUUID UUIDString];
    cell.majorLabel.text = [NSString stringWithFormat:@"%@",beacon.major];
    cell.minorLabel.text = [NSString stringWithFormat:@"%@",beacon.minor];
    NSString* strValue  =[NSString stringWithFormat:@"Acc:%.2fm Rssi:%ld",beacon.accuracy,(long)beacon.rssi ];
    cell.accuracyLabel.text = strValue;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

@end
