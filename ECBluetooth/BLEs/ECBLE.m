//
//  BLEs.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/22.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import "ECBLE.h"

@implementation ECBLE
@synthesize sUUID = _sUUID;
@synthesize cUUID = _cUUID;
@synthesize valueList = _valueList;

-(id)initWithData:(NSData *)data;
{
    if (self = [super init])
    {
        self->_valueList = [self decoderFromData:data];
    }
    
    return self;
}

-(BOOL)isEqualWithSUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID
{
    if(![sUUID isEqual:[CBUUID UUIDWithString:self->_sUUID]])
        return NO;

    if (![cUUID isEqual:[CBUUID UUIDWithString:self->_cUUID]])
        return NO;
    
    return YES;
}

-(NSDictionary *)decoderFromData:(NSData *)data
{
    NSAssert(NO, @"%@:未實作 %@ 方法", self, NSStringFromSelector(_cmd));
    return nil;
}
@end
