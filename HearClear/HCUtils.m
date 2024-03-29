//
//  HCUtils.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "HCUtils.h"
#import "UIDevice+UDID.h"

@implementation HCUtils



//Response type checking
+(ResponseType)responseTypeForFSResponse:(NSDictionary *)foursquareData
{
    if([foursquareData hasValueForKey:@"meta"]){
        NSDictionary *repairedDict = [HCUtils fixJSONDictionary:[foursquareData objectForKey:@"meta"]];
        if([repairedDict hasValueForKey:@"code"])
        {
            int responseCode = [[repairedDict valueForKey:@"code"] intValue];
            if(responseCode == 200){
                return Success;
            }else if(responseCode == 404){
                return NotFound;
            }else{
                return Error;
            }
        }else{
            return Error;
        }
        
        
    }else{
     
        return Error;
    }
    
    return Error;
}


//Fix the NSNULL issue with dictionaries
+(NSDictionary *)fixJSONDictionary:(NSDictionary *)JSONDict{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:[JSONDict count]];
    
    NSString *key;
    for(key in JSONDict){
        if ([[JSONDict objectForKey:key] isKindOfClass:[NSNull class]]) {
            [mutableDict setObject:@"" forKey:key];
        }else{
            [mutableDict setObject:[JSONDict objectForKey:key] forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:mutableDict];
    
}

+(NSDictionary *)venueInfoFromFoursquareAPIResponse:(NSDictionary *)foursquareData;
{
    //NSLog(@"Venue Info: %@", [foursquareData description]);
    //TODO: Extend
    return nil;
}

+(NSString*)loudnessStringForLoudnessValue:(NSNumber*)loudnessValue
{
    float lval = [loudnessValue floatValue];
    if(lval == 0)
    {
        return @"No Data";
    }else if (lval > 0 && lval <= 0.1)
    {
        return @"Silent";
    }else if(lval > 0.1 && lval <= 0.2)
    {
        return @"Soft";
    }else if(lval > 0.2 && lval <= 0.4)
    {
        return @"Low";
    }else if(lval > 0.4 && lval <= 0.5)
    {
        return @"Average";
    }else if(lval > 0.5 && lval <= 0.65)
    {
        return @"Loud";
    }else if(lval > 0.65 && lval <= 0.8)
    {
        return @"Very Loud";
    }else if(lval > 0.8)
    {
        return @"Deafening";
    }
    
    
    return @"No Data";
}

+(NSArray *)venuesFromFoursquareAPIResponse:(NSDictionary *)foursquareData{
    
    NSMutableArray *mv = [[NSMutableArray alloc]init];
    NSArray *arrayData = [[foursquareData objectForKey:@"response"]objectForKey:@"groups"];
    
    //catch an error here maybe?
    NSArray *items = [[arrayData objectAtIndex:0] objectForKey:@"items"];
    //foursquare data is the data straight from the API, we have made sure that we have at least a 200, may be no data though
    for(NSDictionary *v in items){
        //NSLog(@"Venue info is: %@", [v description]);
        NSDictionary *loc = [HCUtils fixJSONDictionary:[v objectForKey:@"location"]];
        //NSLog(@"Outputting the updated dictionary from the API :%@", [loc description]);
        NSString *longitude = [loc objectForKey:@"lng"];
        NSString *latitude = [loc objectForKey:@"lat"];
        NSString *ven_id = [v objectForKey:@"id"];
        NSString *ven_dist = [loc objectForKey:@"distance"];
        NSString *ven_name = [v objectForKey:@"name"];
        
        [mv addObject:@{ @"id" : ven_id, @"name": ven_name, @"distance" : ven_dist, @"latitude" : latitude, @"longitude" : longitude }];
        
        
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    
    [mv sortUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    return [NSArray arrayWithArray:mv];
}

+(NSString *)userInfoFromFoursquareResponse:(NSDictionary *)foursquareData{
    
    
    NSString *userId = [[[foursquareData objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"id"];
    
    return userId;
}

+(NSDictionary *)userInfoDictionary
{
    
    NSDictionary *userDictionary = @{@"deviceID" : [HCUtils HCID], @"device" : [HCUtils HCDeviceString]};
    return userDictionary;
}

+(NSString *)HCID
{
    return [[UIDevice currentDevice] UDID];
    //return [[UIDevice currentDevice] uniqueIdentifier];
}

+(NSString *)HCDeviceString{
    
    return [[UIDevice currentDevice] platformString];
    
}


@end
