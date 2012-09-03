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
#define kAPIv2BaseURL @"https://api.foursquare.com/v2"




-(void)objectForVenueSearchAtLocation:(CLLocation *)location{
    
    NSString *latValue = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lonValue = [NSString stringWithFormat:@"%F", location.coordinate.longitude];
    
    
    NSURLRequest *venueRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/venues/search?oauth_token=%@&ll=%@,%@",kAPIv2BaseURL,[FoursquareNetworkController foursquareToken],latValue,lonValue]]];
    //[venueRequest ]
    
    
    [NSURLConnection sendAsynchronousRequest:venueRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error){
            
        }else{
            NSError *parseError = nil;
            NSDictionary *foursquareJSONResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            NSArray *venueArray = [HCUtils venuesFromFoursquareAPIResponse:foursquareJSONResponse];
            
            [self.delegate FSQVenueReturnVenues:venueArray];
            
        }
    }];
    
    
   // return nil;
}

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
@end
