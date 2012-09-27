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
#define kCheckinURL @"https://api.foursquare.com/v2/checkins/add"
#define kUserInfoURL @"https://api.foursquare.com/v2/users/self?"
#define kClientID @"VS1C3CG0UFVGIRQLDMN3C5W4Z31SDMEKJVLTUNVWLGJKSKJB"
#define kClientSecret @"EJDWSNZ2P01YIOV4NEUDJ0WULFATZZRA5BOYD2VSF4TWXTXQ"


@implementation FSNetwork






#pragma mark Venue Search
-(void)venuesForLocation:(CLLocation *)location{
    NSString *latValue = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lonValue = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    
    NSString *venueSearchURL = [NSString stringWithFormat:@"%@client_id=%@&client_secret=%@&ll=%@,%@", kVenueSearchURL, kClientID, kClientSecret, latValue, lonValue];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"API connection queried");
    NSURLRequest *venueSearchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:venueSearchURL]];
    
    [NSURLConnection sendAsynchronousRequest:venueSearchRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if(error)
       {
           NSLog(@"Error on API: %@", [error localizedDescription]);
       }else{
           NSLog(@"API Connection returned");
           dispatch_async(dispatch_get_main_queue(), ^{
               NSError *parseError = nil;
               NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
               //TODO: Handle parse error
               
               NSArray *venueArray = [HCUtils venuesFromFoursquareAPIResponse:jsonData];
               
               //NSLog(@"Array from API: %@", [venueArray description]);
               [self.delegate fsResult:QuerySuccess forQueryType:VenueSearch withObject:venueArray];
               
               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               
           });
 
           
       }
        
    }];
    
}


#pragma mark Venue Info
-(void)informationForVenue:(NSString *)venueId{
    NSString *venueInfoURL = [NSString stringWithFormat:@"%@%@?oauth_token=%@", kVenueInfoURL, venueId, [FSNetwork foursquareToken]];
    
    
    NSURLRequest *venueInfoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:venueInfoURL]];
        
    [NSURLConnection sendAsynchronousRequest:venueInfoRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *parseError = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                NSDictionary *venueInfo = [HCUtils venueInfoFromFoursquareAPIResponse:jsonData];
                
                
                [self.delegate fsResult:QuerySuccess forQueryType:VenueInfo withObject:venueInfo];
            });
      
            
        }
    }];
}


#pragma mark Checkin
-(void)checkinForVenue:(NSString *)venueId{
    //Note: Checkin is a POST transaction
    
    
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


+(void)requestUserID{
    NSString *userQueryString = [NSString stringWithFormat:@"%@oauth_token=%@", kUserInfoURL, [FSNetwork foursquareToken]];
    
    NSURLRequest *userInfoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:userQueryString]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:userInfoRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error){
            NSLog(@"ERROR!: %@", [error localizedDescription]);
        }else{
            NSError *parseError = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            NSString *user_id = [[[jsonData objectForKey:@"response"] objectForKey:@"user"]objectForKey:@"id"];
            [FSNetwork storeUserId:user_id];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //NSLog(@"User id is: %@", user_id);
        }
    }];
    
}

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
