// UIDevice+UDID
// Created by William Denniss
// Public domain. No rights reserved.

#import "UIDevice+UDID.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "NSString+SHA1.h"

@implementation UIDevice (UDID)

// returns the local MAC address. 
- (NSString*) macAddressForInterface:(NSString*)interfaceNameOrNil
{
    // uses en0 as the default interface name
    NSString* interfaceName = interfaceNameOrNil;
    if (interfaceName == nil)
    {
        interfaceName = @"en0";
    }
    
    // code snippet via Georg Kitz, via FreeBSD hackers email list 
    // ref: https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5/blob/master/Classes/UIDevice%2BIdentifierAddition.m
        
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex([interfaceName UTF8String])) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr*) buf;
    sdl = (struct sockaddr_dl*) (ifm + 1);
    ptr = (unsigned char*) LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

// returns a 40 char string that is the sha1 hash of the user's en0 MAC address
- (NSString*) UDID
{
    return [[self macAddressForInterface:nil] sha1];
}

// gets a salted UDID. For a per-application UDID, you could use [[NSBundle mainBundle] bundleIdentifier]
- (NSString*) UDIDWithSalt:(NSString*)salt
{
  return [[NSString stringWithFormat:@"%@%@", [self macAddressForInterface:nil], salt] sha1];
}

@end
