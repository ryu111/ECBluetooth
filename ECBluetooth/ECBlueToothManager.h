//
//  BlueThoothManager.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/15.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "IBluetooth.h"

@protocol ECBlueToothManagerDelegate;

@interface ECBlueToothManager : NSObject <CBCentralManagerDelegate, EAAccessoryDelegate>
@property (weak, nonatomic) id<ECBlueToothManagerDelegate> delegate;
@property (strong, nonatomic) CBCentralManager *central;
@property (strong, nonatomic) NSMutableArray *bluetooths;

+ (ECBlueToothManager *)shared;
- (void)scanBluetooth;
- (void)connectWithIBluetooth:(id<IECBluetooth>)bluetooth;
- (void)disConnectWithIBluetooth:(id<IECBluetooth>)bluetooth;
@end



@protocol ECBlueToothManagerDelegate <NSObject>

@required
- (void)blueToothManager:(ECBlueToothManager *)manager didDisconverIBluetooth:(id<IECBluetooth>)bluetooth;
- (void)blueToothManager:(ECBlueToothManager *)manager didConnectIBluetooth:(id<IECBluetooth>)bluetooth;
- (void)blueToothManager:(ECBlueToothManager *)central didDisconnectIBluetooth:(id<IECBluetooth>)bluetooth;

@optional
- (void)startSconWithBlueToothManager:(ECBlueToothManager *)manager;
- (void)stopSconWithBlueToothManager:(ECBlueToothManager *)manager;

@end
