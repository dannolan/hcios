//
//  FSNetwork.h
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HCUtils.h"

typedef enum {
    VenueSearch,
    VenueInfo,
    Checkin
} QueryType;


typedef enum {
    QuerySuccess,
    QueryFailNetwork,
    QueryFailUnknown,
    QueryFailFoursquare
} QueryResult;

@protocol FSNetworkDelegate <NSObject>

@required
-(void)fsResult:(QueryResult)result forQueryType:(QueryType)type withObject:(id)object;
@end


@interface FSNetwork : NSObject

@property(nonatomic,weak) id<FSNetworkDelegate> delegate;


+(BOOL)hasFoursquareToken;
+(void)storeFoursquareToken:(NSString *)foursquareToken;
+(NSString*)foursquareToken;

+(void)storeUserId:(NSString *)userID;
+(NSString *)userID;
+(BOOL)hasUserId;

+(void)updateUserCredentials;


-(void)venuesForLocation:(CLLocation *)location;
-(void)informationForVenue:(NSString *)venueId;
-(void)checkinForVenue:(NSString *)venueId;


@end
