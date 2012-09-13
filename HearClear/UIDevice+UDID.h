// UIDevice+UDID
// Created by William Denniss
// Public domain. No rights reserved.

#import <Foundation/Foundation.h>

@interface UIDevice (UDID)

- (NSString*) macAddressForInterface:(NSString*)interfaceNameOrNil;
- (NSString*) UDID;
- (NSString*) UDIDWithSalt:(NSString*)salt;

@end
