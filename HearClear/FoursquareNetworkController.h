//
//  FoursquareNetworkController.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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

@protocol FSQEngineDelegate <NSObject>

@required
-(void)foursquareQueryResult:(QueryResult)result forQueryType:(QueryType)type withObject:(id)object;
@end


@interface FoursquareNetworkController : NSObject

@property (weak, nonatomic) id<FSQEngineDelegate> delegate;

+(BOOL)hasFoursquareToken;
+(void)storeFoursquareToken:(NSString *)foursquareToken;
+(NSString*)foursquareToken;

+(void)storeUserId:(NSString *)userID;
+(NSString *)userID;
+(BOOL)hasUserId;




-(void)queryVenuesForLocation:(CLLocation *)location;
@end
