//
//  HCNetwork.h
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueCheckin.h"

typedef enum{
    PostSuccess,
    PostFailure
} PostResult;

typedef enum{
    VenueLoudness,
    UserCreate,
    VenueCreate,
    CheckinCreate
}   PostType;


@protocol HCNetworkDelegate <NSObject>
-(void)hcResult:(PostResult)result forPostType:(PostType)type withObject:(id)object;
@end

@interface HCNetwork : NSObject

@property(nonatomic,weak) id<HCNetworkDelegate> delegate;


+(void)postCheckinInformation:(VenueCheckin*)checkin withDetails:(NSDictionary *)details;

+(void)userExists;
+(void)createUser;

+(void)venueExists:(NSDictionary*)venueDict;
+(void)createVenue:(NSDictionary *)venueDict;
-(NSString *)venueInfoForVenue:(NSDictionary *)venueDict;


@end
