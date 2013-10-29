//
//  HeartRateMeasurement.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/23.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import "HeartRateMeasurement.h"

@implementation HeartRateMeasurement
#pragma mark - init
-(id)init
{
    if (self = [super init])
    {
        self->_sUUID = @"180d";
        self->_cUUID = @"2a37";
    }
    
    return self;
}

#pragma mark - private
-(NSDictionary *)decoderFromData:(NSData *)data
{
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    Byte *byte = (Byte *)[data bytes];
    
    NSInteger hr = 256*byte[2] + byte[1];
    [list setObject:[NSNumber numberWithInteger:hr] forKey:BLE_KEY_HEART_RATE];
    
    NSMutableArray *rrDatas = [NSMutableArray array];
    for (int i=5;i<[data length];i+=2)
    {
        NSInteger rrValue = 256*byte[i+1]+byte[i];
        [rrDatas addObject:[NSNumber numberWithInteger:rrValue]];
    }
    [list setObject:rrDatas forKey:BLE_KEY_HEART_RRI_DATAS];
    
    return list;
}
@end
