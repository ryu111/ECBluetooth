//
//  CBPeripheral+Easy.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/16.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CBPeripheral+Easy.h"

@implementation CBPeripheral (Easy)
@dynamic notifyBLEs;
static char kPropertyNotifyBLEs;
- (NSArray *)notifyBLEs
{
    return (NSArray *)objc_getAssociatedObject(self, &(kPropertyNotifyBLEs));
}

- (void)setNotifyBLEs:(NSArray *)notifyBLEs
{
    objc_setAssociatedObject(self, &kPropertyNotifyBLEs, notifyBLEs, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - IBluetooth
-(NSString *)Name
{
    return self.name;
}

-(BOOL)isBLE
{
    return YES;
}

-(void)setIsConnect:(BOOL)isConnect
{
}

-(BOOL)isConnect
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        return (self.state == CBPeripheralStateConnected);
    }
    
    return self.isConnected;
}

#pragma mark - public
-(void)notificationWithBLE:(ECBLE *)ble service:(CBService *)s enabled:(BOOL)enabled
{
    CBCharacteristic *characteristic;
    for(CBCharacteristic *c in s.characteristics)
    {
        if ([ble isEqualWithSUUID:s.UUID cUUID:c.UUID])
        {
            characteristic = c;
            break;
        }
    }
    
    if (!characteristic)
        return;
    
    [self setNotifyValue:enabled forCharacteristic:characteristic];
}

-(void)readCharacteristicWithBLE:(ECBLE *)ble
{
    for (CBService *service in self.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:ble.sUUID]])
        {
            for ( CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ble.cUUID]])
                {
                    [self readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}
@end
