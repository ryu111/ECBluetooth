//
//  BlueThoothManager.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/15.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "ECBlueToothManager.h"
#import "CBPeripheral+Easy.h"
#import "EAAccessory+Easy.h"

@implementation ECBlueToothManager
@synthesize delegate;
@synthesize central;
@synthesize bluetooths;

#pragma mark - init
+ (ECBlueToothManager *)shared
{
    static ECBlueToothManager *sharedBlueToothManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedBlueToothManager = [[self alloc] init];
    });
    
    return sharedBlueToothManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.bluetooths = [NSMutableArray array];
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(AccessoryDidConnectNotification:)
                                                     name:EAAccessoryDidConnectNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - public
- (void)scanBluetooth
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.central.state == CBCentralManagerStatePoweredOn)
    {
        NSAssert(self.delegate, @"%@:未設定 Delegate, Scan 沒有意義!", self);
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(stopScan:) userInfo:nil repeats:NO];
        if([self.delegate respondsToSelector:@selector(startSconWithBlueToothManager:)])
        {
            [self.delegate startSconWithBlueToothManager:self];
        }
        
        [self.bluetooths removeAllObjects];
        [self.central scanForPeripheralsWithServices:nil options:nil];
        
        [self scanBluetooth3];
    }
    else
    {
        [self centralManagerDidUpdateState:self.central];
    }
}

- (void)connectWithIBluetooth:(id<IECBluetooth>)bluetooth
{
    if(bluetooth.isConnect)
        return;
    
    if ([bluetooth isKindOfClass:[CBPeripheral class]])
    {
        [self.central connectPeripheral:(CBPeripheral *)bluetooth options:nil];
    }
    else
    {
        EAAccessory *accessory = (EAAccessory *)bluetooth;
        [accessory connect];
        
        // 3.0 能見到，就是已經連線上，直接用 delegate 建立 NSStreamDelegate
        if (self.delegate)
        {
            [self.delegate blueToothManager:self didConnectIBluetooth:bluetooth];
        }
    }
}

- (void)disConnectWithIBluetooth:(id<IECBluetooth>)bluetooth
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if(!bluetooth.isConnect)
        return;
    
    if ([bluetooth isKindOfClass:[CBPeripheral class]])
    {
        [self.central cancelPeripheralConnection:(CBPeripheral *)bluetooth];
    }
    else
    {
        EAAccessory *accessory = (EAAccessory *)bluetooth;
        [accessory disconnect];
        if (self.delegate)
        {
            [self.delegate blueToothManager:self didDisconnectIBluetooth:bluetooth];
        }
    }
}

#pragma mark - private
- (void)stopScan:(NSTimer *)timer
{
    [self.central stopScan];
    
    if (self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(stopSconWithBlueToothManager:)])
        {
            [self.delegate stopSconWithBlueToothManager:self];
        }
    }
}

- (void)scanBluetooth3
{
    NSArray *accessories = [EAAccessoryManager sharedAccessoryManager].connectedAccessories;
    for (EAAccessory *accessory in accessories)
    {
        if (accessory.protocolStrings.count == 0)
            continue;
        
        if([accessory.protocolStrings.lastObject isEqualToString:@"com.apple.accessory.updater.app.8"])
            continue;
            
        if([self.bluetooths containsObject:accessory])
            continue;
        
        NSLog(@"%@", accessory.protocolStrings);
        accessory.delegate = self;
        [self.bluetooths addObject:accessory];
        if (self.delegate)
        {
            [self.delegate blueToothManager:self didDisconverIBluetooth:accessory];
        }
    }
}

#pragma mark - notification
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.central stopScan];
    
    if (self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(stopSconWithBlueToothManager:)])
        {
            [self.delegate stopSconWithBlueToothManager:self];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.central stopScan];
    
    for (id<IECBluetooth> bluetooth in self.bluetooths)
    {
        [self disConnectWithIBluetooth:bluetooth];
    }
}

- (void)AccessoryDidConnectNotification:(NSNotification *)notification
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self scanBluetooth3];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (self.central.state)
    {
        case CBCentralManagerStateUnknown:
            NSLog(@"藍芽未知狀態，請進行更新");
            break;
            
        case CBCentralManagerStateResetting:
            NSLog(@"藍芽與系統失去連結，請進行更新");
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"藍芽不支持 Low Energy 連結");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"應用程式未授權藍芽 Low Energy 連結");
            break;
            
        case CBCentralManagerStatePoweredOff:
            NSLog(@"藍芽處於關閉狀態");
            break;
            
        case CBCentralManagerStatePoweredOn:
            NSLog(@"藍芽處於開啟狀態");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if(![self.bluetooths containsObject:peripheral])
    {
        [self.bluetooths addObject:peripheral];
    }
    
    if (self.delegate)
    {
        [self.delegate blueToothManager:self didDisconverIBluetooth:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.delegate)
    {
        [self.delegate blueToothManager:self didConnectIBluetooth:peripheral];
    }
    
    [peripheral discoverServices:nil];
    
    [peripheral setIsConnect:YES];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), error);

    switch (error.code)
    {
        default:
            [self scanBluetooth];
            break;
    }
    
    if([self.bluetooths containsObject:peripheral])
    {
        [self.bluetooths removeObject:peripheral];
    }
    
    [peripheral setIsConnect:NO];
    if (self.delegate)
    {
        [self.delegate blueToothManager:self didDisconnectIBluetooth:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if([self.bluetooths containsObject:peripheral])
    {
        [self.bluetooths removeObject:peripheral];
    }
}

#pragma mark - EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)accessory
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    
    if ([self.bluetooths containsObject:accessory])
    {
        accessory.delegate = nil;
        [accessory disconnect];
        [self.bluetooths removeObject:accessory];
        if (self.delegate)
        {
            [self.delegate blueToothManager:self didDisconnectIBluetooth:accessory];
        }
    }
}
@end
