//
//  DecoderBLE.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/22.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "ECDecoderBLE.h"
#import "ECBLE.h"
#import "CBUUID+StringExtraction.h"

@interface ECDecoderBLE ()
{
    NSDictionary *BLEList;
}
@end

@implementation ECDecoderBLE

#pragma mark - init
+ (ECDecoderBLE *)shared
{
    static ECDecoderBLE *sharedDecoderBLE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedDecoderBLE = [[self alloc] init];
                  });
    
    return sharedDecoderBLE;
}

-(id)init
{
    if (self = [super init])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:PLIST_BLE_LIST ofType:@"plist"];
        self->BLEList = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

#pragma mark - public

-(ECBLE *)BLEWithSUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)data
{
    NSDictionary *dic = [self->BLEList objectForKey:[sUUID representativeString]];
//    if (dic == nil)
//    {
//        NSLog(@"nil");
//        return nil;
//    }
    NSAssert(dic, @"BLEList.plist 缺少 sUUID:%@", [sUUID representativeString]);

    NSString *className = [dic objectForKey:[cUUID representativeString]];
    NSAssert(className, @"BLEList.plist 缺少 cUUID:%@", [cUUID representativeString]);
    
    Class class = NSClassFromString(className);
    NSAssert(class, @"未實作類別:%@", className);
    
    ECBLE *ble = [[class alloc] initWithData:data];

    return ble;
}
@end
