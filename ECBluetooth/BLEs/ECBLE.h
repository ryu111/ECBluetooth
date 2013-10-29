//
//  BLEs.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/22.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ECBLE : NSObject
{
    @protected
    NSString *_sUUID;
    NSString *_cUUID;
    NSDictionary *_valueList;
}

@property (readonly, strong, nonatomic) NSString *sUUID;
@property (readonly, strong, nonatomic) NSString *cUUID;
@property (readonly, strong, nonatomic) NSDictionary *valueList;

-(id)initWithData:(NSData *)data;
-(BOOL)isEqualWithSUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID;
@end
