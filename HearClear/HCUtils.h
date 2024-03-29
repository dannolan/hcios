//
//  HCUtils.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Utils.h"
#import "UIDevice-Hardware.h"


//Enum for foursquare meta response
typedef enum{
    Success,
    Forbidden,
    Failure,
    NotFound,
    Error
}ResponseType;

@interface HCUtils : NSObject


+(ResponseType)responseTypeForFSResponse:(NSDictionary *)foursquareData;
+(NSArray *)venuesFromFoursquareAPIResponse:(NSDictionary *)foursquareData;
+(NSString *)userInfoFromFoursquareResponse:(NSDictionary *)foursquareData;
+(NSDictionary *)venueInfoFromFoursquareAPIResponse:(NSDictionary *)foursquareData;
+(NSDictionary *)fixJSONDictionary:(NSDictionary *)JSONDict;
+(NSString*)loudnessStringForLoudnessValue:(NSNumber*)loudnessValue;
+(NSString *)HCID;
+(NSString *)HCDeviceString;
+(NSDictionary *)userInfoDictionary;

@end
