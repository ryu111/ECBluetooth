//
//  BatteryLevel.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/22.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import "BatteryLevel.h"

@implementation BatteryLevel

#pragma mark - init
-(id)init
{
    if (self = [super init])
    {
        self->_sUUID = @"180f";
        self->_cUUID = @"2a19";
    }
    
    return self;
}

#pragma mark - private
-(NSDictionary *)decoderFromData:(NSData *)data
{
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    Byte *byte = (Byte *)[data bytes];
    NSInteger battery = byte[0];
    NSString *level = [NSString stringWithFormat:@"%ld", (long)battery];
    [list setObject:level forKey:BLE_KEY_BATTERY_LEVEL];
    
    return list;
}
@end
