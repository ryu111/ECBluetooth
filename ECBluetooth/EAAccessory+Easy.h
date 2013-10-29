//
//  EAAccessory+Easy.h
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/16.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <ExternalAccessory/ExternalAccessory.h>
#import "IBluetooth.h"

@interface EAAccessory (Easy) <IECBluetooth, EAAccessoryDelegate>
@property (readonly, strong, nonatomic) EASession *session;
@property (readonly, strong, nonatomic) id<NSStreamDelegate> streamDelegate;

-(void)connect;
-(void)disconnect;
-(void)setDecoderDelegate:(id<NSStreamDelegate>)streamDelegate;
@end
