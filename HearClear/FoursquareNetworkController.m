//
//  FoursquareNetworkController.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "FoursquareNetworkController.h"
#import "HCUtils.h"

@implementation FoursquareNetworkController


#define kFoursquareToken @"foursquare_token"
#define kFoursquareUser @"foursquare_user_id"
#define kAPIv2BaseURL @"https://api.foursquare.com/v2"




-(void)queryVenuesForLocation:(CLLocation *)location{
    
    NSString *latValue = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lonValue = [NSString stringWithFormat:@"%F", location.coordinate.longitude];
    //NSLog(@"Token: %@", [FoursquareNetworkController foursquareToken]);
    
    
    NSURLRequest *venueRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/venues/search?oauth_token=%@&ll=%@,%@",kAPIv2BaseURL,[FoursquareNetworkController foursquareToken],latValue,lonValue]]];
    //[venueRequest ]
    
    
    [NSURLConnection sendAsynchronousRequest:venueRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error){
            
        }else{
            NSError *parseError = nil;
            NSDictionary *foursquareJSONResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            NSArray *venueArray = [HCUtils venuesFromFoursquareAPIResponse:foursquareJSONResponse];
            
            [self.delegate foursquareQueryResult:QuerySuccess forQueryType:VenueSearch withObject:venueArray];
            
        }
    }];
    
    
   // return nil;
}


#pragma mark Foursquare Token and User Token Methods

+(BOOL)hasFoursquareToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return ([defaults objectForKey:kFoursquareToken] != nil);
}
                                  
+(NSString*)foursquareToken
{
        
    return [[NSUserDefaults standardUserDefaults] objectForKey:kFoursquareToken];
    
}


+(void)storeFoursquareToken:(NSString *)foursquareToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Don't accidentally save over an already existing token
    if([FoursquareNetworkController hasFoursquareToken])
        return;
    
    [defaults setObject:foursquareToken forKey:kFoursquareToken];
    [defaults synchronize];
}

#pragma mark User ID Methods

+(BOOL)hasUserId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    return ([defaults objectForKey:kFoursquareUser] != nil);
}

+(NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kFoursquareUser];
}

+(void)storeUserId:(NSString *)userID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:userID forKey:kFoursquareUser];
    [defaults synchronize];
}

@end
