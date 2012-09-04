//
//  FSNetwork.m
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "FSNetwork.h"


#define kFoursquareToken @"foursquare_token"
#define kFoursquareUser @"foursquare_user_id"
#define kAPIv2BaseURL @"https://api.foursquare.com/v2"
#define kVenueSearchURL @"https://api.foursquare.com/v2/venues/search?"
#define kVenueInfoURL @"https://api.foursquare.com/v2/venues/"
#define kCheckinURL @"https://api.foursquare.com/v2/"
#define kUserInfoURL @"https://api.foursquare.com/v2/users/self?"


@implementation FSNetwork


#pragma mark User Info

+(void)loadUserCredentials{
    
    NSString *queryURL = [NSString stringWithFormat:@"%@%@", kUserInfoURL, [FSNetwork foursquareToken]];
    
    NSURLRequest *userInfoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:queryURL]];
    
    [NSURLConnection sendAsynchronousRequest:userInfoRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        
        
    }];
    
}




#pragma mark Venue Search
-(void)venuesForLocation:(CLLocation *)location{
    
}


#pragma mark Venue Info
-(void)informationForVenue:(NSString *)venueId{
    
}


#pragma mark Checkin
-(void)checkinForVenue:(NSString *)venueId{
    
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
    if([FSNetwork hasFoursquareToken])
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
