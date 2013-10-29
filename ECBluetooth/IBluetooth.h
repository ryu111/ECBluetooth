//
//  IBluethooth.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/15.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_PATHS_IBLUETOOTH_IS_CONNECT @"isConnect"

@protocol IECBluetooth <NSObject>
@property (nonatomic) BOOL isConnect;

-(NSString *)Name;
-(BOOL)isBLE;
@end
