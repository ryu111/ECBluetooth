//
//  CBPeripheral+Easy.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/16.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "IBluetooth.h"
#import "ECBLE.h"

@interface CBPeripheral (Easy) <IECBluetooth>
@property (readonly, strong, nonatomic) NSArray *notifyBLEs;
-(void)notificationWithBLE:(ECBLE *)ble service:(CBService *)s enabled:(BOOL)enabled;
-(void)readCharacteristicWithBLE:(ECBLE *)ble;
@end
