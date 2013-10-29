//
//  SerialNumberString.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/9/3.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import "SerialNumberString.h"

@implementation SerialNumberString

#pragma mark - init
-(id)init
{
    if (self = [super init])
    {
        self->_sUUID = @"180a";
        self->_cUUID = @"2a25";
    }
    
    return self;
}

#pragma mark - private
-(NSDictionary *)decoderFromData:(NSData *)data
{
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    NSString *serial = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [list setObject:serial forKey:BLE_KEY_SERIAL];
    
    return list;
}
@end
