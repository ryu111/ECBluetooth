//
//  DecoderBLE.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/22.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECBLE.h"

#define PLIST_BLE_LIST @"BLEList"

@interface ECDecoderBLE : NSObject
+ (ECDecoderBLE *)shared;
-(ECBLE *)BLEWithSUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)data;
@end
