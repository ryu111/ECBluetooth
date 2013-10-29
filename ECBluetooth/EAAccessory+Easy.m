//
//  EAAccessory+Easy.m
//  EasyBluetooth
//
//  Created by SU BO-YU on 13/8/16.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <objc/runtime.h>
#import "EAAccessory+Easy.h"

@implementation EAAccessory (Easy)
@dynamic session;
static char kPropertySession;
- (EASession *)session
{
    return (EASession *)objc_getAssociatedObject(self, &(kPropertySession));
}

- (void)setSession:(EASession *)session
{
    objc_setAssociatedObject(self, &kPropertySession, session, OBJC_ASSOCIATION_RETAIN);
}

@dynamic streamDelegate;
static char kPropertyStreamDelegate;
- (id<NSStreamDelegate>)streamDelegate
{
    return (id<NSStreamDelegate>)objc_getAssociatedObject(self, &(kPropertyStreamDelegate));
}

- (void)setStreamDelegate:(id<NSStreamDelegate>)streamDelegate
{
    objc_setAssociatedObject(self, &kPropertyStreamDelegate, streamDelegate, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - IBluetooth
-(NSString *)Name
{
    return self.name;
}

-(BOOL)isBLE
{
    return NO;
}

-(void)setIsConnect:(BOOL)isConnect
{
}

-(BOOL)isConnect
{
    return (self.session)?YES:NO;
}

#pragma mark - public
-(void)connect
{
    NSString *protocol = [self.protocolStrings lastObject];
    self.session = [self sessionWithProtocol:protocol delegate:self.streamDelegate];
    self.isConnect = YES;
}

-(void)disconnect
{
    if (self.session == nil)
        return;
    
    NSLog(@"關閉 Session:%@ ", self.session.protocolString);
    
    [[self.session inputStream] setDelegate:nil];
    [[self.session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop]
                                           forMode:NSRunLoopCommonModes];
    [[self.session inputStream] close];
    
    [[self.session outputStream] setDelegate:nil];
    [[self.session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop]
                                            forMode:NSRunLoopCommonModes];
    [[self.session outputStream] close];
    
    self.session = nil;
    self.isConnect = NO;
}

-(void)setDecoderDelegate:(id<NSStreamDelegate>)streamDelegate
{
    self.streamDelegate = streamDelegate;
    [[self.session inputStream] setDelegate:streamDelegate];
    [[self.session outputStream] setDelegate:streamDelegate];
}

#pragma mark - private
-(EASession *)sessionWithProtocol:(NSString *)protocolString delegate:(id<NSStreamDelegate>)delegate
{
    EASession *session = [[EASession alloc] initWithAccessory:self forProtocol:protocolString];
    if (session)
    {
        [[session inputStream] setDelegate:delegate];
        [[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                   forMode:NSRunLoopCommonModes];
        [[session inputStream] open];
        
        [[session outputStream] setDelegate:delegate];
        [[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                    forMode:NSRunLoopCommonModes];
        [[session outputStream] open];
    }
    
    NSLog(@"建立 Session:%@ ", session.protocolString);
    return session;
}
@end
